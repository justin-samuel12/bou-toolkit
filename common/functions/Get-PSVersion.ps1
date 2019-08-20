function Get-PSVersion {
<#PSScriptInfo
.SYNOPSIS
    Return current Powershell version
.DESCRIPTION
    Return current Powershell version
.NOTES
    Author: Justin-Samuel
.EXAMPLE 
    Get-PSVersion
#>
    if (test-path variable:psversiontable ) {$psversiontable.psversion} else {[version]"1.0.0.0"}
}


# SIG # Begin signature block
# MIIYEwYJKoZIhvcNAQcCoIIYBDCCGAACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUYWHFIEOm5Z34ed5fJAfqsqjD
# ObOgghJ/MIIFPDCCAySgAwIBAgIQTWjUKzekWKhOweWTZNRm1jANBgkqhkiG9w0B
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUKUsN
# wtfH+Yzz2NNH5deIBuKJdAwwDQYJKoZIhvcNAQEBBQAEggIAcHP/Tbsc/OCHJWrK
# JwyT4zFNeaBT6KIsw88Hssije7cZviqd3qfkSPJiL+TlhiuqakysdB+ebXs439Fo
# TMojkYdMPTOPXrq2RhV/EAsI7CViy8qRmLAb9AmXwlEZudDIFTqZCpx8nWdlZ4ra
# kyHZ+rCr3+q2tCpPyfEyNUNAQmqHehOPH73YuwK4w5XRtNclbh83Drt2s0QixQ+l
# wuf9kCHPWaQ6UrnYKUE1QKNparEcj+VhN0Y/uBcG4FWBghZe3P81g6Qt98CFa22v
# ZHTgU2GkIWadr7RDvstGRClizC9yF7JuKP/00SqUzQqdK3xrhyWVo0H3WaKX1kpq
# WzPQMvCpGPBBKY3ZyzMu8Maw9fCj+rRXnkt5V6K4jIyN58g/iW/BUDdr/i+rFVC6
# Zy5kgPk3HnT6PKvppzf5xPouf2iQuMJKnxTihhi10nxDAl8LyWB9DY4xeU98SQ3g
# js+HpW3RfeU+dp2iPf1QlU4pvUeYWTKiEaPLxppkgikKIA2spLbUwThDe0EMMsbs
# UXOd4cyNyz0sfIHWMfTZf4EL8PZGX4+hCoxy59lRoMLUJ8IIvBh9WcOJDjhQ3YYh
# sbWGDKdzoXgfKFHE9GORmYL8WKzCBBaDAj2gEpiwFrRtHNGhCVizFdqV725zj1iC
# sMMQPWVGJWVCe4/Y3PewAWhOpYGhggIPMIICCwYJKoZIhvcNAQkGMYIB/DCCAfgC
# AQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVk
# IElEIENBLTECEAMBmgI6/1ixa9bV6uYX8GYwCQYFKw4DAhoFAKBdMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgxNjIwNDAzN1ow
# IwYJKoZIhvcNAQkEMRYEFLINb9754FIHsinKIAc9rVXsw8VgMA0GCSqGSIb3DQEB
# AQUABIIBAGHMmebeGiPiFZaPIuzaWvW6vvA9W7MP3SeNC1napcKcireyljGZZQ08
# arxqDtyYKN9BLV4x53yBiVubcnxP0pIiSjouNRK4dgQWCz3v+Dx8CTd4XdDUcFOt
# qkVQvbsxRAXaCYBLyi108XLk4DZXduO2Mr924tBrDR4ilwMMGEoVihu2qZJcysgo
# xeWPfOM/gTqtHNlnpMqKa0Q+u0ac4dCWyUMXm1pyHQbGnjgBXtq1T9HI9CSGRnaw
# Wgwx7eykNSS4j0vcKHCfWCKNrpb2661OyRIjhkDMJF24Z2zuZnydkEfD8mFe/m34
# ywn7QiZsMeqHLPa9430nBBL+S4WQl4g=
# SIG # End signature block