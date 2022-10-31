<#
.DESCRIPTION
    Get the local admin password form Legacy Microsoft LAPS in Active Directory
.EXAMPLE
    Get-LegacyMicrosoftLAPSPassword -DomainName corp.local -Computer Front-Desk -Credentials $credentials
.EXAMPLE
    Get-LegacyMicrosoftLAPSPassword -DomainName test.local -Computer Test-VM -Credentials $credentials -PlainText
#>

function Get-LegacyMicrosoftLAPSPassword {
    [CmdletBinding()]
    param (
        # FQDA of Active Directory
        [Parameter(Mandatory = $true)]
        [string]
        $DomainName,

        # Parameter help description
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Computer,

        # AD User password
        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credentials,

        # Export as plan text
        [Parameter(Mandatory = $false)]
        [switch]
        $PlainText
    )

    begin {

    }
    
    process {
        # Test if ms-Mcs-AdmPwd is blank or no permissions
        $TestAccess = $null
        $TestAccess = Get-ADComputer -Server $DomainName -Credential $Credentials -Identity $Computer -Properties ms-Mcs-AdmPwd | Select-Object ms-Mcs-AdmPwd | Format-Table -hide | Out-String -Stream | Where-Object { $_.Trim().Length -gt 0 }
        if ($null -ne $TestAccess) {
            if ($PlanText -eq $true) {
                # Export password as plain text
                Get-ADComputer -Server $DomainName -Credential $Credentials -Identity $Computer -Properties ms-Mcs-AdmPwd | Select-Object ms-Mcs-AdmPwd | Format-Table -hide | Out-String -Stream | Where-Object { $_.Trim().Length -gt 0 }
            }
            else {
                # Export password as SecureString
                Get-ADComputer -Server $DomainName -Credential $Credentials -Identity $Computer -Properties ms-Mcs-AdmPwd | Select-Object ms-Mcs-AdmPwd | Format-Table -hide | Out-String -Stream | Where-Object { $_.Trim().Length -gt 0 } | ConvertTo-SecureString -AsPlainText -Force
            }
        }
        else {
            Write-Host "Error: Check DomainName, Credentials, Computer, Permissisions to ms-Mcs-AdmPwd, or password might not exist" -ErrorAction Stop
        }
        
    }
    
    end {
        
    }
}