function Set-EncryptPassword {
<#PSScriptInfo
.SYNOPSIS
    Allow to store encrypted password files to be used for other powershell utilities
.DESCRIPTION
    Encrypt single value and create either key/password file or output values to be used in config file
.PARAMETER Value
    What is the value that will be encrypted
.PARAMETER Key
    What is the key that will be used to encrypt the value (optional)
.PARAMETER Location
    Where is the directory location in which the key/password file will be created (optional)
.PARAMETER FileName
    What is the name for both file (only 1 name can be used but will create 2 files with the same name) (optional)
.EXAMPLE 
    Set-EncryptPassword -Value 'This$i$my$tr0ngpa$$w0rd' -location 'D:\' -filename 'passwordfile'
    Set-EncryptPassword -Value 'This$i$my$tr0ngpa$$w0rd' -Keystring '01d74082f4c4aa25efdd74a8c8410ea41bd46ef88c504f19c1ff270d0b03bbb9' -location 'D:\' -filename 'passwordfile'
    
    Set-EncryptPassword -Value 'This$i$my$tr0ngpa$$w0rd' -output
    Set-EncryptPassword -Value 'This$i$my$tr0ngpa$$w0rd' -Keystring '01d74082f4c4aa25efdd74a8c8410ea41bd46ef88c504f19c1ff270d0b03bbb9' -output 
#>
[CmdletBinding()]
param 
( 
    [parameter(Mandatory=$true,ValueFromPipeline)] [string]$Value,    
    [parameter(ValueFromPipeline)][string]$Keystring = $null,    
    [Parameter(ValueFromPipeline)][string]$Location, 
    [parameter(ValueFromPipeline)][string]$FileName,
    [parameter(ValueFromPipeline)][switch]$Output
)     
    [byte[]]$key;
    #create the key				
    IF ($Keystring.length -eq 0)
    {
        $Key = New-Object Byte[] 32
        [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    
        $HexKeyString = [System.Text.StringBuilder]::new($Key.Length * 2)
        ForEach($byte in $Key)
        {
            $HexKeyString.AppendFormat("{0:x2}", $byte) | Out-Null
        }
        $Keystring = $HexKeyString.ToString()
    }
    else 
    {
        $key  = Convert-FromStringToByte $Keystring;
    }    

    #create the password
    $pswd = ConvertTo-SecureString -String $Value -AsPlainText -Force | ConvertFrom-SecureString -Key $Key;

    switch ($Output) {
        $true
        {  
            Write-Host "";
            Write-Host "";
            Write-Host "Secure-Password: ${pswd}" -BackgroundColor DarkBlue;
            Write-Host "Key: ${KeyString}" -BackgroundColor DarkRed;
            Write-Host "Please take note of the above information. If using it in a project, please ensure you have both values."
        }
        $false 
        {
            IF (!(Test-Path $Location))
            {
                Throw "Invalid path given: ${Location}";
                break;
            };
            IF ($FileName.length -eq 0) 
            {
                Throw "Filename is required";
                break;
            };

            $KeyFile = "$Location\$KeyString.key";
            $PasswordFile = "$Location\$FileName-password.txt"  

            #output the key
            IF (!(Test-Path $KeyFile)) {$KeyString | out-file $KeyFile;}
            
            #create the password file
            $pswd | Set-Content $PasswordFile;
            
            Write-Host "Key and Password text file has been created and exported to: $($Location)" -BackgroundColor DarkRed;
            Write-Host "Key filename: $KeyString.key";
            Write-Host "Key filename: $FileName-password.txt";
        }
    }

}
# SIG # Begin signature block
# MIIYEwYJKoZIhvcNAQcCoIIYBDCCGAACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXUniIH5nyVtwQZI+aDCa3wlX
# YTOgghJ/MIIFPDCCAySgAwIBAgIQTWjUKzekWKhOweWTZNRm1jANBgkqhkiG9w0B
# AQsFADA2MTQwMgYDVQQDDCtEQkEgLSBEZXZPUFMgUG93ZXJzaGVsbCBzaWduaW5n
# IENlcnRpZmljYXRlMB4XDTE5MDgxNjE1NTgwNFoXDTI0MDgxNjE2MDgwM1owNjE0
# MDIGA1UEAwwrREJBIC0gRGV2T1BTIFBvd2Vyc2hlbGwgc2lnbmluZyBDZXJ0aWZp
# Y2F0ZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOHIuMDttsbQI5Zi
# Y5lrTXepqlUKSPKdyZ+KibLdrwu58Yk0h2f8O9XZ6RsnseqT0FkAjW3ZHzQ58Cy/
# J760CZXQbsbhVxXLkbV4DNNe8aX7IqIBtWK78CpQ4ru58j9xPARvzLW/sjXEe33d
# pxuTL9VMKeamY35Ay2elsHQRRak7HxlKikqeoJwiZguJIWlTvij2fHo/DFMUOowK
# uWQJo4Cs24UE2HpkGSE7JSYD/E6lhuzSLG+eoSBx4UlzS55IanRnkMnXY9iXHTmk
# uXvJ9TOmprjNHUJq2cnhZsl+/o147PjH6Ce5rxcyZFURiqJBpUYV4VtalzvKw08C
# zokV1yo5dm2llCMxz7CFNdECJpH3RvjSO6hQKePA1YUIEsqLP6hVrEjko8KfH0jl
# NpTGgI13f/Nhsr9eVczVV2bR/wVv+Kgtsd0JbpqvP55WIwzOjgnST8GkHgIWrSj9
# +q0ArWmiXqCe4pcYyPvvrOnyOpf20pN8XNKDCdZ9L/Jf+6WBIN7NNMYV+xYQVAuF
# ytfV4niKdgqSA1NpbAolvdw6qF+1qP7PNshy9TnhSsthHxv0vzEDQSddDIStbmeh
# QmlPnNCJHUQuau5nCrLnDnAgsH5Al/l6YIaF0TeIP9h1l+bNkLCENVCy23pN7bw4
# oYmosnB+/hwlw+7BnUn4vS6WTpeBAgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUA/MDsbvE/qmDClN8iviXeJho
# 9m0wDQYJKoZIhvcNAQELBQADggIBAGO7WT9fcqWmO/97S0WmgfXvPdo4NtYdrKLG
# T+c8FSjmbr24PdmTMnvSbN39J/FeelRsbzby5kvba+CZqZVmOdaQHza9nTOhpaDA
# M4NvmQOFE0EN3hDf4KVHYLUaJhixB1/1Hz2ZQ3j98zJXLl7o0PTLeNahUDoPIA8f
# RwKj6rWtSqkfEH7sovsvnJbXttFRTRqZghE0YNOlixzn7V0YGh9KtDBchYFZ3Sdh
# aCC508fV92Ac3GCcz/fBdVujXXh7Nk3CaYSSosBfZPlO/2HimHdcv7+ZxnPrJOnX
# k2U3yrk3P9uzvdn+7MHEbeSzC7or7a+UW+8WmgIdGHSpZPRV6wBKVPpByq3iXox0
# pE/25ga1njCIolrAblY//PkdhtqzaemJtuQlXNnCyal4rjSplTRt60q+gAbCTqLp
# epyWrn3KD69jNgXUjiSyKOmqINsJxtzNbtlJMUlPZavibxjbxATCRryj8SffJFJJ
# 4z2YY0hnzF3eMYTrliXGS7pp5wD1u/dMwEQBOOLz+MvgJI0Q4Czd4UEvXD9DiAJG
# eX/txxpzYFUSOQcFZr4g8aaf6B9GuZ0DD4VJmtdTzKMLX8P3G4kzi2fBx2JDxTzH
# 9zL5sJqVQ9jlu58T2W7Ru3BTOF56AclMdPzIrwA6CTBDjQPg5JLMVhn/PB5Gxybj
# 31U0sW1zMIIGajCCBVKgAwIBAgIQAwGaAjr/WLFr1tXq5hfwZjANBgkqhkiG9w0B
# AQUFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVk
# IElEIENBLTEwHhcNMTQxMDIyMDAwMDAwWhcNMjQxMDIyMDAwMDAwWjBHMQswCQYD
# VQQGEwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJTAjBgNVBAMTHERpZ2lDZXJ0IFRp
# bWVzdGFtcCBSZXNwb25kZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCjZF38fLPggjXg4PbGKuZJdTvMbuBTqZ8fZFnmfGt/a4ydVfiS457VWmNbAklQ
# 2YPOb2bu3cuF6V+l+dSHdIhEOxnJ5fWRn8YUOawk6qhLLJGJzF4o9GS2ULf1ErNz
# lgpno75hn67z/RJ4dQ6mWxT9RSOOhkRVfRiGBYxVh3lIRvfKDo2n3k5f4qi2LVkC
# YYhhchhoubh87ubnNC8xd4EwH7s2AY3vJ+P3mvBMMWSN4+v6GYeofs/sjAw2W3rB
# erh4x8kGLkYQyI3oBGDbvHN0+k7Y/qpA8bLOcEaD6dpAoVk62RUJV5lWMJPzyWHM
# 0AjMa+xiQpGsAsDvpPCJEY93AgMBAAGjggM1MIIDMTAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDCCAb8GA1UdIASC
# AbYwggGyMIIBoQYJYIZIAYb9bAcBMIIBkjAoBggrBgEFBQcCARYcaHR0cHM6Ly93
# d3cuZGlnaWNlcnQuY29tL0NQUzCCAWQGCCsGAQUFBwICMIIBVh6CAVIAQQBuAHkA
# IAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUAcgB0AGkAZgBpAGMAYQB0AGUA
# IABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMAYwBlAHAAdABhAG4AYwBlACAA
# bwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQAIABDAFAALwBDAFAAUwAgAGEA
# bgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAAUABhAHIAdAB5ACAAQQBnAHIA
# ZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkAbQBpAHQAIABsAGkAYQBiAGkA
# bABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4AYwBvAHIAcABvAHIAYQB0AGUA
# ZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYAZQByAGUAbgBjAGUALjALBglg
# hkgBhv1sAxUwHwYDVR0jBBgwFoAUFQASKxOYspkH7R7for5XDStnAs0wHQYDVR0O
# BBYEFGFaTSS2STKdSip5GoNL9B6Jwcp9MH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6
# Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDig
# NqA0hjJodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURD
# QS0xLmNybDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0EtMS5jcnQwDQYJKoZIhvcNAQEFBQAD
# ggEBAJ0lfhszTbImgVybhs4jIA+Ah+WI//+x1GosMe06FxlxF82pG7xaFjkAneNs
# hORaQPveBgGMN/qbsZ0kfv4gpFetW7easGAm6mlXIV00Lx9xsIOUGQVrNZAQoHuX
# x/Y/5+IRQaa9YtnwJz04HShvOlIJ8OxwYtNiS7Dgc6aSwNOOMdgv420XEwbu5AO2
# FKvzj0OncZ0h3RTKFV2SQdr5D4HRmXQNJsQOfxu19aDxxncGKBXp2JPlVRbwuwqr
# HNtcSCdmyKOLChzlldquxC5ZoGHd2vNtomHpigtt7BIYvfdVVEADkitrwlHCCkiv
# sNRu4PQUCjob4489yq9qjXvc2EQwggbNMIIFtaADAgECAhAG/fkDlgOt6gAK6z8n
# u7obMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdp
# Q2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0Rp
# Z2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0wNjExMTAwMDAwMDBaFw0yMTEx
# MTAwMDAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFz
# c3VyZWQgSUQgQ0EtMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOiC
# LZn5ysJClaWAc0Bw0p5WVFypxNJBBo/JM/xNRZFcgZ/tLJz4FlnfnrUkFcKYubR3
# SdyJxArar8tea+2tsHEx6886QAxGTZPsi3o2CAOrDDT+GEmC/sfHMUiAfB6iD5IO
# UMnGh+s2P9gww/+m9/uizW9zI/6sVgWQ8DIhFonGcIj5BZd9o8dD3QLoOz3tsUGj
# 7T++25VIxO4es/K8DCuZ0MZdEkKB4YNugnM/JksUkK5ZZgrEjb7SzgaurYRvSISb
# T0C58Uzyr5j79s5AXVz2qPEvr+yJIvJrGGWxwXOt1/HYzx4KdFxCuGh+t9V3CidW
# fA9ipD8yFGCV/QcEogkCAwEAAaOCA3owggN2MA4GA1UdDwEB/wQEAwIBhjA7BgNV
# HSUENDAyBggrBgEFBQcDAQYIKwYBBQUHAwIGCCsGAQUFBwMDBggrBgEFBQcDBAYI
# KwYBBQUHAwgwggHSBgNVHSAEggHJMIIBxTCCAbQGCmCGSAGG/WwAAQQwggGkMDoG
# CCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9z
# aXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAA
# bwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMA
# dABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgA
# ZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgA
# ZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4A
# dAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAA
# YQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIA
# ZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwDFTAS
# BgNVHRMBAf8ECDAGAQH/AgEAMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGB
# BgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRBc3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIr
# E5iymQftHt+ivlcNK2cCzTAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823I
# DzANBgkqhkiG9w0BAQUFAAOCAQEARlA+ybcoJKc4HbZbKa9Sz1LpMUerVlx71Q0L
# QbPv7HUfdDjyslxhopyVw1Dkgrkj0bo6hnKtOHisdV0XFzRyR4WUVtHruzaEd8wk
# pfMEGVWp5+Pnq2LN+4stkMLA0rWUvV5PsQXSDj0aqRRbpoYxYqioM+SbOafE9c4d
# eHaUJXPkKqvPnHZL7V/CSxbkS3BMAIke/MV5vEwSV/5f4R68Al2o/vsHOE8Nxl2R
# uQ9nRc3Wg+3nkg2NsWmMT/tZ4CMP0qquAHzunEIOz5HXJ7cW7g/DvXwKoO4sCFWF
# IrjrGBpN/CohrUkxg0eVd3HcsRtLSxwQnHcUwZ1PL1qVCCkQJjGCBP4wggT6AgEB
# MEowNjE0MDIGA1UEAwwrREJBIC0gRGV2T1BTIFBvd2Vyc2hlbGwgc2lnbmluZyBD
# ZXJ0aWZpY2F0ZQIQTWjUKzekWKhOweWTZNRm1jAJBgUrDgMCGgUAoHgwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUWcIz
# sy/uORPf1jrxhI+R/BUvX8cwDQYJKoZIhvcNAQEBBQAEggIAGgsSvqnunB7B+pZu
# ybY64bwE7jQuLX/lJJFCRHpgpReKmMmGKLexRCmZVPq3MBLD15HhEneW1waM0xvQ
# WU1hq++dCy6NTyVLzpzRqoZxutX09lUc07QhaF2jkIW9ndg3A9TvHeQoHUbv3AWq
# G38czgOVmAdyUQaiCWJuNoxZt4qa8sX0a4udE0JuOEEylC5rvsN3i9W4bKVpsv7J
# uXBt6vpvF2phHxJ23xIVO8x2VlC9vrztt5i+dLkob2nJ0QrMZQ9my+YZ+OhF3PmB
# s9fp4jj30fvxCuxr88xdKxzp/rZtdF1Pv7voumVK94fI7c+Nqg07RocDSBgo0KtF
# EGhvooA/JCm29JKmm08cZD6cM//QqFqzY0vY1S6xxyvuGl+mUgsH14DR17IvHhsC
# b8Q3Wplvpw5A/y4lqC+19Py2tWkIuo9KVZPB4n+Wjy9shqM0OMmeehIgxZHDzYBW
# HTYfbeeqZEtssJx4JQXqqSV218Q+muXEgZ2EvLT6ZdFVssTUjhOJUtyFU+9ffXrt
# ZzW5ImLoQ4eEpwqbxIbQKYhPZhmIAxuPCt97Qx+YGwzDVfWye8eBPCqV0JJN9dCq
# xyJH5s+DkWq2V47zHHldJhczurkYvxaSRlNYJJbJHccZhAE7fpjJyVDIoU2qGMZ3
# JTMgn3efaqBcHcTjKwwjPC9qO2yhggIPMIICCwYJKoZIhvcNAQkGMYIB/DCCAfgC
# AQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVk
# IElEIENBLTECEAMBmgI6/1ixa9bV6uYX8GYwCQYFKw4DAhoFAKBdMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgxNjIwNDAzOFow
# IwYJKoZIhvcNAQkEMRYEFNU5L31Wk7qWmAbXo6d/onv/9zOyMA0GCSqGSIb3DQEB
# AQUABIIBAE1PCC0pQNX06TkshqBeL3+a3vW9hz1YQOtwkgwsUp+9GOZcveAvQSw/
# BpQU2cMl0hV8dpq2n6dOZy0SGtm9RcqzfuSAimLLHlHcCT7Lh0pU8XzJ6pbPs1cv
# +kQPGIurhRwrslgZ5lH5Ep2PouwCcw8hktp21u/ZiMRMn3THRDJw0rLTlxgRmzC8
# oRID/GjkWFT1H2wOl/oGgmL6kM0YHLxrMnxRBRSyWXr5garmIkMju1BVbXghrq83
# rBLv3Jb7/fJr7MK7H1vJgLoc1LebfpqBsoHnK1p5lY3TOdZaWpRQKvOqmt6hhM8Q
# Wqf0EL5JyVQQNiOlsh8cPZUWoERpIHE=
# SIG # End signature block
