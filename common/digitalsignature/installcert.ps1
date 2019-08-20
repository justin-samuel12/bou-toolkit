#requires -Version 4.0
#requires -RunAsAdministrator

Clear-History
Clear-Host
$ErrorActionPreference = "Stop"

$CurrentDirectory = (Split-Path -Path $PSScriptRoot -parent) #Split-Path $script:MyInvocation.MyCommand.Path;
$digitalsigniturefile=  "$CurrentDirectory\DigitalSignature\DBADevOpsToolKit.pfx";
$xmlconfig = [xml](get-content "$CurrentDirectory\config.xml")

$digitalSigningKey = $xmlconfig.Root.DigitalSigning.key
$Bytes = [byte[]]::new($digitalSigningKey.Length / 2)

For($i=0; $i -lt $digitalSigningKey.Length; $i+=2){
    $Bytes[$i/2] = [convert]::ToByte($digitalSigningKey.Substring($i, 2), 16)
}

$securestring = $xmlconfig.Root.DigitalSigning.value | ConvertTo-SecureString -Key $Bytes
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securestring)
$pswd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)  

Import-PfxCertificate -FilePath $digitalsigniturefile -Password (ConvertTo-SecureString -String $pswd -AsPlainText -Force)  -CertStoreLocation Cert:\LocalMachine\Root -verbose