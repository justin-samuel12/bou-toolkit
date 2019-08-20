[string]$logfile = $null;
[ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")][string]$Level = "INFO";

function Write-ToLogFile{
<#PSScriptInfo
.SYNOPSIS
    Custom logging
.DESCRIPTION
    Creating log file for process
.PARAMETER CommandType
    What command do you want the function to execute.
    
    Initialize - Create the file if not existing (in addition to directory structure). Must give full path or will not continue
    Comment - What is the message to add to log
    Start - Adding header
    End - Close out
    Error
.PARAMETER Value
    What is the value for the above parameter
.EXAMPLE 
    Write-ToLogFile -commandtype 'initialize' 'D:\logging\log.txt'

#>
[CmdletBinding()]
param 
( 
    [Parameter(Mandatory=$True)][ValidateSet("Initialize","Comment","Start","End","Error")][string]$CommandType,
    [Parameter(Mandatory=$false)][string]$Value    
)
$ErrorActionPreference = "Stop"
Trap 
{
    $script:Level ="Error";
    $err = $_.Exception    
    while ( $err.InnerException )
    {
        $err = $err.InnerException
        Write-ToLogFile -CommandType "Error" -Value $err.Message 
    };
    Write-ToLogFile -CommandType "End";
}

switch($CommandType)
{
    "Initialize" {
        $script:logfile = $Value;
        $directory= [System.IO.Path]::GetDirectoryName($script:logfile);
        $filename = [System.IO.Path]::GetFileName($script:logfile);
        
        if ($directory.length -eq 0){
            Write-Host "No directory has been mentioned. Please add directory and try again" -ForegroundColor darkred -BackgroundColor white
            exit
        }
        elseif ($filename.length -eq 0){
            Write-Host "No file name has been mentioned. Please add filename and try again" -ForegroundColor darkred -BackgroundColor white
            exit
        }
        
        # check to see if folder exists, if not create
        if ( -not (Test-Path $directory)) { 
                New-Item -ItemType Directory -Path $directory -Force 
            };
        
        # since ps can't handle text delimited with outputting text file, have to use alternative method
        if ( -not (Test-Path $script:logfile) ) { 
                [System.IO.File]::Create($script:logfile).Close() | Out-Null;
            }#create if not exists
    }
    
    "Start" {
        $Header = "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:: Date Creation: " + (Get-Date).toString("D") + "
:: Powershell Version: " + (Get-PSVersion) + "
:: Executed by: " + [System.Security.Principal.WindowsIdentity]::GetCurrent().Name + "
:: Executed Machine: " + [System.Environment]::MachineName + "
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Level			Date			Event
-------------------	-------------------	--------------------------------------------------------------------------------------------"
    Add-Content -Path ($script:logfile) -Value $Header;	 
    }

    "End" {
        $Footer ="`r`n**********************************************************************************************************************************"
        Add-Content -Path ($script:logfile) -Value $Footer;	 
    }

    default {
        IF ($CommandType -eq 'Error') {Write-Output  -ForegroundColor Red -BackgroundColor DarkBlue;} 
        Add-Content -Path ($script:logfile) -Value ("$script:level :`t`t`t" +(Get-Date).ToString("s") + "`t$Value");	 
    }

}
}

# SIG # Begin signature block
# MIIYEwYJKoZIhvcNAQcCoIIYBDCCGAACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxEPmQVOMyr60BquddDbAE0UO
# vJagghJ/MIIFPDCCAySgAwIBAgIQTWjUKzekWKhOweWTZNRm1jANBgkqhkiG9w0B
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQULvDn
# fTS4gtcvLcA0xMVeAUsz5oIwDQYJKoZIhvcNAQEBBQAEggIAdsLoBc0K+7IsjvFt
# 5Td6TZvrI+9v4KWXlfOZTZMk3QCUhvmdc0o0xZmz7zFNbgqsu9a56cvSbu2LdSdo
# L4AdamjMSbKJzOrk6+Ytl8chnhIPmlTMwBsU8e+0+63YTSYv3C9yWXhV2r9eItXV
# NT0KtdfJ3L/8ADBMZoifsDGq+JZnzZrVMhlktQPCsJd0QmDwUfRxaND2SLq2o+w7
# jkVPOl4TNfe0AqlxREmJKemihQaUejsYH9ivcO/T1Mijjrb74ah4sOeY1r1QTxic
# X84MAy4z4+3DgEEhrTr809r++htH7LgViy1ghvo5bH6dFqpcEj93utJ8fqRwwpUI
# KI1D0n80rgQfpqQVQkdSNgXLzInoGDvc6sagmcfiGe+D9CPwJ76DZw1AxWxybYMJ
# ekwNLMFA+R0zwoy3egIgmDkwb7huKES3PcDvpYhVvFMrn03ASzzRoPnPcywIJDO1
# adacitgDYdeYdqTocsHXqwI0UAhuKuHze0g4lHwTt/WwyrVxym7xk2dKATQw2Ol7
# xFfFs9FDTTD6qnPqeTrq+9XDlUt+Maw3jT5ujD2xknoQ/NVFmSKqMz/BkOpF/VEi
# XVZBpNzcwtyoVIZxwZqe/LnEx4si6G3oFLbIGUcLTGEe0Es65VsPSiLzSZv0cubd
# PYPdvTaapymjEm/a3Tb8WrmF4wuhggIPMIICCwYJKoZIhvcNAQkGMYIB/DCCAfgC
# AQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVk
# IElEIENBLTECEAMBmgI6/1ixa9bV6uYX8GYwCQYFKw4DAhoFAKBdMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgxNjIwNDAzOFow
# IwYJKoZIhvcNAQkEMRYEFOWoC+PGeLadWEMNqSrl5sn5ASOcMA0GCSqGSIb3DQEB
# AQUABIIBADZaeKvPaiTySrtwbrVwAJJ2N/Wd51B6cwWBxdZeVJ3QqQdT3NmfWahh
# 039xUPvjy5502zeP069+46dWjdN66fN0e7UxeHCERxgvdUpUMsAC/IZ3L/zm27Gt
# 00VlQldvma1yX27fzblxzDjIdBc7l2sTo3mI/2ohCSmB78fvcdT/LzKOkVw2cNsy
# M4iUHS8+b8m6H6equXJCZAvaifSWhoYK+j3cHceOFY4HG0VMMx9BUmNgxYfbpu/5
# phaML28bJZPk9BdAflDpnKDi5Tx4UvwD/nE2Jms89GWKpsLehDRVnEwa0CmUdo4x
# ckMjOLhuRv5NLfKPLIwnK6tIwF0QMWU=
# SIG # End signature block
