#requires -Version 3;

Properties {
    $CurrentBaseDirectory =(Split-Path -Path $PSScriptRoot -parent);
    $buildDirectory = 'PowershellBuild';
    $ModuleName = (Get-Item $CurrentBaseDirectory\*.psd1)[0].BaseName;
    $githubTokenPath = '~\Github.apitoken';
    $githubOwner = 'justin-samuel12';
    
}
$Exclude = @(
    '*.Tests.ps1',
    '.git*',
    '.publish',
    '.vscode',
    'psake*',
    'appveyor.yml',
    'module*.ps1',
    '*.md',
    'build*',
    'deploy*',
    'digitalsignature\*.cer',
    (Split-Path $PSCommandPath -Leaf)
)

Task Default -Depends Build;
Task Build -Depends Init, Clean, Setup, Sign, Deploy;
Task Stage -Depends Build, Version 
Task Publish -Depends Stage, Release;


Task Init{
    $xmlconfig = [xml](get-content "$CurrentBaseDirectory\config.xml");
    
 # Properties are not available in the script scope.
    Set-Variable buildPath -Value (Join-Path -Path (Split-Path -Path $CurrentBaseDirectory -Qualifier) -ChildPath "$buildDirectory\$ModuleName") -Scope Script;
    Set-Variable version -Value $xmlconfig.Root.Version.Number -Scope Script;
    Set-Variable projecturi -Value $xmlconfig.Root.GithubProjectUri.name -Scope Script;
    Set-Variable digitalSigningKey -Value $xmlconfig.Root.DigitalSigning.key -Scope Script;
    Set-Variable digitalSigningValue -Value $xmlconfig.Root.DigitalSigning.value -Scope Script;
    Set-Variable author -Value $xmlconfig.Root.Author.name -Scope Script;
    Set-Variable manifest -Value $xmlconfig.Root.Manifest -Scope Script;
}


Task Clean {
    ## Remove build directory
    if (Test-Path -Path (Split-Path -Path $buildPath -parent)) {
        Write-Host (' Removing build base directory "{0}".' -f (Split-Path -Path $buildPath -parent)) -ForegroundColor Yellow;
        Remove-Item (Split-Path -Path $buildPath -parent) -Recurse -Force -ErrorAction Stop;
    }
}

Task Setup {
   
    Write-Host (' Building module "{0}".' -f $ModuleName) -ForegroundColor Yellow;
    Write-Host (' Creating build for version: {0}' -f $version) -ForegroundColor Yellow

    ## Create the build directory
    Write-Host (' Creating build directory "{0}".' -f $buildPath) -ForegroundColor Yellow;
    [Ref] $null = New-Item $buildPath -ItemType Directory -Force -ErrorAction Stop;    
        
    #get function /alias information to create new psd1
    $ExportFunctions = @()
    $ExportAliases = @()

    $FunctionFiles = Get-ChildItem "$CurrentBaseDirectory\functions\*.ps1"
    foreach ($FunctionFile in $FunctionFiles) {
    $AST = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFile.FullName, [ref]$null, [ref]$null)        
    $Functions = $AST.FindAll({
            $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)
    if ($Functions.Name) {
        $ExportFunctions += $Functions.Name
    }
    $Aliases = $AST.FindAll({
            $args[0] -is [System.Management.Automation.Language.AttributeAst] -and
            $args[0].parent -is [System.Management.Automation.Language.ParamBlockAst] -and
            $args[0].TypeName.FullName -eq 'alias'
        }, $true)
    if ($Aliases.PositionalArguments.value) {
        $ExportAliases += $Aliases.PositionalArguments.value
    }        
    }

    IF ($ExportFunctions.length -eq 0) {$ExportFunctions ='*';}
    IF ($ExportAliases.length -eq 0) {$ExportAliases ='*';}

    $Parameters = @{
    Path = @(
        "$CurrentBaseDirectory\functions\*.ps1"
        "$CurrentBaseDirectory\helpers\*.ps1"
    )
    ErrorAction = 'SilentlyContinue'
    }
    $ExportModules = Get-ChildItem @Parameters | ForEach-Object { $_.fullname.replace("$CurrentBaseDirectory", ".") }
    
    Update-ModuleManifest -Path "$CurrentBaseDirectory\$ModuleName.psd1" `
    -RootModule "$ModuleName.psm1" `
    -Author $author `
    -CompanyName 'na' `
    -ModuleVersion $version `
    -Description $manifest.Description.value `
    -PowerShellVersion $manifest.PowershellMinVer.number `
    -FunctionsToExport $ExportFunctions `
    -NestedModules $ExportModules `
    -AliasesToExport $ExportAliases `
    -Tags @('Powershell','Windows') `
    -ReleaseNotes "Updated under $projecturi/README" `
    -ProjectUri $projecturi `
    -LicenseUri "$projecturi\LICENSE"
}

# Task Test {
#     $testResultsPath = Join-Path $buildPath -ChildPath 'NUnit.xml';
#     $testResults = Invoke-Pester -Path $basePath -OutputFile $testResultsPath -OutputFormat NUnitXml -PassThru -Strict;
#     if ($testResults.FailedCount -gt 0) {
#         Write-Error ('{0} unit tests failed.' -f $testResults.FailedCount);
#     }
# }

Task Deploy {
    ## Copy release files
    Write-Host (' Copying release files to build directory "{0}".' -f $buildPath) -ForegroundColor Yellow;
    
    ForEach ($f in ($buildPath))
    {   
        Get-ChildItem -Path $CurrentBaseDirectory -Exclude $exclude | Copy-Item -Destination $f -force -recurse
    }  
    
}

Task Version {
    ## Version module manifest prior to build
    $manifestPath = Join-Path $buildPath -ChildPath "$($manifest.Name).psd1";
    Write-Host (' Versioning module manifest "{0}".' -f $manifestPath) -ForegroundColor Yellow;
    Set-ModuleManifestProperty -Path $manifestPath -Version $version -CompanyName $company -Author $author;
    ## Reload module manifest to ensure the version number is picked back up
    Set-Variable manifest -Value (Get-ModuleManifest -Path $manifestPath) -Scope Script -Force;
}

Task Sign {
    #code sign the public ps1 and also the psm1
    $digitalsigniturefile=  "$CurrentBaseDirectory\digitalsignature\DBADevOpsToolKit.pfx";
    IF (!(Test-Path $digitalsigniturefile)){
        Write-Host "Missing certificate. Will skip but maybe an issue" -backgroundcolor DarkRed
        $ErrorActionPreference = 'Continue'
    }
    else {
        #install certificate
        invoke-expression "$CurrentBaseDirectory\digitalsignature\installcert.bat"; # running the batch will execute using admin privelages as certs will be installed to trusted root dir

        $Bytes = [byte[]]::new($digitalSigningKey.Length / 2)        
        For($i=0; $i -lt $digitalSigningKey.Length; $i+=2){
            $Bytes[$i/2] = [convert]::ToByte($digitalSigningKey.Substring($i, 2), 16)
        }
        
        $securestring = $digitalSigningValue | ConvertTo-SecureString -Key $Bytes
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securestring)
        $digitalsigniturecipher = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)  
        
        $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($digitalsigniturefile, $digitalsigniturecipher)       

        $Public  = @( Get-ChildItem -Path $CurrentBaseDirectory\functions\*.ps1 -ErrorAction SilentlyContinue )
        $Helpers  = @( Get-ChildItem -Path $CurrentBaseDirectory\helpers\*.ps1 -ErrorAction SilentlyContinue )
        $psm1file =@( Get-ChildItem -Path $CurrentBaseDirectory\*.psm1 -ErrorAction SilentlyContinue ) 

        #digital sign each file
        Foreach($import in @($Public) + @($Helpers) +$psm1file)
        {
            Write-Host (' Signing file "{0}":' -f $import) -ForegroundColor Yellow;
            Set-AuthenticodeSignature -FilePath $import `
                    -Certificate $Cert `
                    -IncludeChain "All" `
                    -TimeStampServer "http://timestamp.digicert.com"
        }
    } 
}

# Task Release {
#     ## Create a Github release
#     $githubApiKey = (New-Object System.Management.Automation.PSCredential 'OAUTH', (Get-Content -Path $githubTokenPath | ConvertTo-SecureString)).GetNetworkCredential().Password;
#     Write-Host (' Creating new Github "{0}" release in repository "{1}/{2}".' -f $version, $githubOwner, $manifest.Name) -ForegroundColor Yellow;
#     $release = New-GitHubRelease -Version $version -Repository $manifest.Name -Owner $githubOwner -ApiKey $githubApiKey;
#     if ($release) {
#         ## Creates the release files in the $releaseDir
#         $zipReleaseName = '{0}-v{1}.zip' -f $manifest.Name, $version;
#         $zipPath = Join-Path -Path $releasePath -ChildPath $zipReleaseName;
#         Write-Host (' Uploading asset "{0}".' -f $zipPath) -ForegroundColor Yellow;
#         $asset = Invoke-GitHubAssetUpload -Release $release -ApiKey $githubApiKey -Path $zipPath;
#         Set-Variable -Name assetUri -Value $asset.Browser_Download_Url -Scope Script -Force;
#     }
# }
