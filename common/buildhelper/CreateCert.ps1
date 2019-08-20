#requires -runasadministrator

Clear-History
Clear-Host

$xmlconfig = [xml](get-content "$(Split-Path -Path $PSScriptRoot -Parent)\config.xml")
$pswd = Get-DecryptPassword ($xmlconfig.Root.DigitalSigning.key) ($xmlconfig.Root.DigitalSigning.value)

# create temporary
$cert = New-SelfSignedCertificate `
-Subject "DBA - DevOPS Powershell signing Certificate" `
-FriendlyName "DBADevOpsToolKit" `
-Type CodeSigningCert `
-KeyUsage DigitalSignature `
-KeyLength 4096 `
-KeyAlgorithm RSA `
-HashAlgorithm SHA256 `
-CertStoreLocation Cert:\LocalMachine\My `
-NotAfter (Get-Date).AddYears(5) `
-KeyExportPolicy Exportable `

# This certificate does not contain the private key
# and is for public usage
Export-Certificate -Cert $cert -FilePath "DBADevOpsToolKit.cer"

# export		
Export-PfxCertificate -Cert $cert `
			-FilePath "DBADevOpsToolKit.pfx" `
			-Password (ConvertTo-SecureString -String $pswd -Force -AsPlainText)

# remove from store
Remove-Item $cert.psPath -Verbose
