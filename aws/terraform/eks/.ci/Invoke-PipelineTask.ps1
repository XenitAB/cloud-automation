<#
.Synopsis
    Script to use Terraform locally and in Azure DevOps
.DESCRIPTION
    Build:
        Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -build
    Deploy:
        Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -deploy
.NOTES
    Name: Invoke-PipelineTask.ps1
    Author: Simon Gottschlag
    Date Created: 2019-11-24
    Version History:
        2019-11-24 - Simon Gottschlag
            Initial Creation


    Xenit AB
#>

[cmdletbinding(DefaultParameterSetName = 'build')]
Param(
    [Parameter(Mandatory = $true, ParameterSetName = 'build')]
    [switch]$build,
    [Parameter(Mandatory = $true, ParameterSetName = 'deploy')]
    [switch]$deploy,
    [Parameter(Mandatory = $true, ParameterSetName = 'destroy')]
    [switch]$destroy,
    [Parameter(Mandatory = $true, ParameterSetName = 'import')]
    [switch]$import,
    [Parameter(Mandatory = $false, ParameterSetName = 'build')]
    [Parameter(Mandatory = $false, ParameterSetName = 'deploy')]
    [Parameter(Mandatory = $false, ParameterSetName = 'destroy')]
    [Parameter(Mandatory = $false, ParameterSetName = 'import')]
    [switch]$azureDevOps,
    [Parameter(Mandatory = $true, ParameterSetName = 'build')]
    [Parameter(Mandatory = $true, ParameterSetName = 'deploy')]
    [Parameter(Mandatory = $true, ParameterSetName = 'destroy')]
    [Parameter(Mandatory = $true, ParameterSetName = 'import')]
    [string]$tfFolderName,
    [Parameter(Mandatory = $false, ParameterSetName = 'build')]
    [Parameter(Mandatory = $false, ParameterSetName = 'deploy')]
    [Parameter(Mandatory = $false, ParameterSetName = 'destroy')]
    [Parameter(Mandatory = $true, ParameterSetName = 'import')]
    [string]$tfImportResource,
    [string]$tfVersion = "0.12.24",
    [string]$tfPath = "$($PSScriptRoot)/../$($tfFolderName)/",
    [string]$tfEncPassword,
    [string]$environmentShort = "dev",
    [string]$artifactPath,
    [bool]$createBackendBucket = $true,
    [string]$tfBackendKey = "$($tfFolderName)/$($environmentShort).tfstate",
    [string]$tfBackendRegion = "eu-north-1",
    [string]$tfBackendRegionShort = "en1",
    [string]$tfBackendBucket = "s3-$($environmentShort)-$($tfBackendRegionShort)-tfstate",
    [int]$opaBlastRadius = 50
)

Begin {
    $ErrorActionPreference = "Stop"

    # Function to retrun error code correctly from binaries
    function Invoke-Call {
        param (
            [scriptblock]$ScriptBlock,
            [string]$ErrorAction = $ErrorActionPreference,
            [switch]$SilentNoExit        
        )
        if ($SilentNoExit) {
            & @ScriptBlock 2>$null
        }
        else {
            & @ScriptBlock

            if (($lastexitcode -ne 0) -and $ErrorAction -eq "Stop") {
                exit $lastexitcode
            }
        }
    }

    function Log-Message {
        Param(
            [string]$message,
            [switch]$header
        )

        if ($header) {
            Write-Output ""
            Write-Output "=============================================================================="
        }
        else {
            Write-Output ""
            Write-Output "---"
        }
        Write-Output $message
        if ($header) {
            Write-Output "=============================================================================="
            Write-Output ""
        }
        else {
            Write-Output "---"
            Write-Output ""
        }
    }

    if (!$($artifactPath)) {
        if (!($ENV:IsWindows) -or $($ENV:IsWindows) -eq $false) {
            $artifactPath = "/tmp/$($ENV:USER)-$($environmentShort)-$($tfFolderName)-terraform-output"
        }
        else {
            $artifactPath = "$($ENV:TMP)\$($environmentShort)-$($tfFolderName)-terraform-output"
        }
        if (!$(Test-Path $artifactPath)) {
            New-Item -Path $artifactPath -ItemType Directory | Out-Null
            Log-Message -message "INFO: artifactPath ($($artifactPath)) created."
        }
        else {
            Log-Message -message "INFO: artifactPath ($($artifactPath)) already exists."
        }
    }

    $tfPlanFile = "$($artifactPath)/$($environmentShort).tfplan"
    if ($tfEncPassword -or $ENV:tfEncPassword) {
        $tfPlanEncryption = $true
        $opensslBin = $(Get-Command openssl -ErrorAction Stop)
        if (!$tfEncPassword) {
            $tfEncPassword = $ENV:tfEncPassword
        }
    }

    function Invoke-TerraformInit {
        Log-Message -message "START: terraform init"
        Invoke-Call ([ScriptBlock]::Create("$tfBin init -input=false -backend-config=`"key=$($tfBackendKey)`" -backend-config=`"bucket=$($tfBackendBucket)`" -backend-config=`"region=$($tfBackendRegion)`""))
        try {
            Invoke-Call ([ScriptBlock]::Create("$tfBin workspace new $($environmentShort)")) -SilentNoExit
            Log-Message -message "INFO: terraform workspace $($environmentShort) created"
        }
        catch {
            Log-Message -message "INFO: terraform workspace $($environmentShort) already exists"
        }
        Log-Message -message "START: terraform workspace select $($environmentShort)"
        Invoke-Call ([ScriptBlock]::Create("$tfBin workspace select $($environmentShort)"))
        Invoke-Call ([ScriptBlock]::Create("$tfBin init -input=false -backend-config=`"key=$($tfBackendKey)`" -backend-config=`"bucket=$($tfBackendBucket)`" -backend-config=`"region=$($tfBackendRegion)`""))
        Log-Message -message "END: terraform workspace select $($environmentShort)"
    }

}
Process {
    Set-Location -Path $tfPath -ErrorAction Stop

    $awsBin = $(Get-Command aws -ErrorAction Stop)

    if ($azureDevOps) {
        Log-Message -message "INFO: Running Azure DevOps specific configuration"

        # Download and extract Terraform
        Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/$($tfVersion)/terraform_$($tfVersion)_linux_amd64.zip" -OutFile "/tmp/terraform_$($tfVersion)_linux_amd64.zip"
        Expand-Archive -Force -Path "/tmp/terraform_$($tfVersion)_linux_amd64.zip" -DestinationPath "/tmp"
        $tfBin = "/tmp/terraform"
        $chmodBin = $(Get-Command chmod -ErrorAction Stop)
        Invoke-Call ([ScriptBlock]::Create("$chmodBin +x $tfBin"))
        Log-Message -message "INFO: Using Terraform version $($tfVersion) from $($tfBin)"

        # Download and extract OPA (Open Policy Agent)
        Invoke-WebRequest -Uri "https://openpolicyagent.org/downloads/latest/opa_linux_amd64" -OutFile "/tmp/opa"
        $opaBin = "/tmp/opa"
        Invoke-Call ([ScriptBlock]::Create("$chmodBin +x $opaBin"))
        Log-Message -message "INFO: Using Open Policy Agent (opa) from $($opaBin)"

        if ($createBackendBucket) {
            $ErrorActionPreference = "SilentlyContinue" # TODO: Fix invoke-call to handle erroractionpreference
            Invoke-Call ([ScriptBlock]::Create("$awsBin s3api create-bucket --bucket $($tfBackendBucket) --region $($tfBackendRegion) --create-bucket-configuration LocationConstraint=$($tfBackendRegion)")) -SilentNoExit
            $ErrorActionPreference = "Stop"

            Log-Message -message "INFO: Testing if S3 bucket $($tfBackendBucket) was successfully provisioned."
            Invoke-Call ([ScriptBlock]::Create("$awsBin s3api wait bucket-exists --bucket $($tfBackendBucket)"))
            Log-Message -message "INFO: S3 bucket $($tfBackendBucket) was successfully provisioned."

            Invoke-Call ([ScriptBlock]::Create("$awsBin s3api put-bucket-versioning --bucket $($tfBackendBucket) --versioning-configuration Status=Enabled"))
            if ($LastExitCode -eq 0) {
                Log-Message -message "INFO: S3 bucket $($tfBackendBucket) successfully enabled versioning."
            }
            else {
                Log-Message -message "ERROR: S3 bucket $($tfBackendBucket) failed to enable versioning."
                exit 1
            }
        }

    }
    else {
        try {
            $tfBin = $(Get-Command terraform -ErrorAction Stop)
        }
        catch {
            Write-Error "Terraform isn't installed"
        }

        try {
            $opaBin = $(Get-Command opa -ErrorAction Stop)
        }
        catch {
            Write-Error "OPA (Open Policy Agent) isn't installed"
        }
    }

    switch ($PSCmdlet.ParameterSetName) {
        'build' {
            Log-Message -message "START: Build" -header
            try {
                Invoke-TerraformInit

                Log-Message -message "START: terraform validate"
                Invoke-Call ([ScriptBlock]::Create("$tfBin validate"))
                Log-Message -message "END: terraform validate"

                Log-Message -message "START: terraform plan"
                Invoke-Call ([ScriptBlock]::Create("$tfBin plan -input=false -var-file=`"variables/$($environmentShort).tfvars`" -var-file=`"variables/common.tfvars`" -out=`"$($tfPlanFile)`""))
                Log-Message -message "END: terraform plan"

                Log-Message -message "START: open policy agent"
                Invoke-Call ([ScriptBlock]::Create("$tfBin show -json `"$($tfPlanFile)`"")) | Out-File -Path "$($tfPlanFile).json"
                Invoke-Call ([ScriptBlock]::Create("$opaBin test ../opa-policies/ -v"))
                $opaData = Get-Content "../opa-policies/data.json" | ConvertFrom-Json
                $opaData.blast_radius = $opaBlastRadius
                $opaData | ConvertTo-Json | Out-File "/tmp/$($ENV:USER)-data.json"
                $opaAuthz=Invoke-Call ([ScriptBlock]::Create("$opaBin eval --format pretty --data /tmp/$($ENV:USER)-data.json --data ../opa-policies/terraform.rego --input `"$($tfPlanFile).json`" `"data.terraform.analysis.authz`""))
                $opaScore=Invoke-Call ([ScriptBlock]::Create("$opaBin eval --format pretty --data /tmp/$($ENV:USER)-data.json --data ../opa-policies/terraform.rego --input `"$($tfPlanFile).json`" `"data.terraform.analysis.score`""))
                if ($opaAuthz -eq "true") {
                    Log-Message -message "INFO: OPA Authorization: true (score: $($opaScore) / blast_radius: $($opaBlastRadius))"
                } else {
                    Log-Message -message "ERROR: OPA Authorization: false (score: $($opaScore) / blast_radius: $($opaBlastRadius))"
                    Remove-Item -Force -Path "$($tfPlanFile)" | Out-Null
                    Log-Message -message "INFO: Terraform plan ($($tfPlanFile)) removed."
                    Write-Error "OPA Authorization failed."
                }
                Log-Message -message "END: open policy agent"

                if ($tfPlanEncryption) {
                    Log-Message -message "START: Encrypt terraform plan"
                    Invoke-Call ([ScriptBlock]::Create("$opensslBin enc -aes-256-cbc -a -salt -in `"$($tfPlanFile)`" -out `"$($tfPlanFile).enc`" -pass `"pass:$($tfEncPassword)`""))
                    Remove-Item -Force -Path "$($tfPlanFile)" | Out-Null
                    Remove-Item -Force -Path "$($tfPlanFile).json" | Out-Null
                    Log-Message -message "END: Encrypt terraform plan"
                }

            }
            catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Error "Message: $ErrorMessage`r`nItem: $FailedItem"
                exit 1
            }
            Log-Message -message "END: Build" -header
        }
        'deploy' {
            Log-Message -message "START: Deploy" -header
            try {
                Invoke-TerraformInit

                if ($tfPlanEncryption) {
                    Log-Message -message "START: Decrypt terraform plan"
                    Invoke-Call ([ScriptBlock]::Create("$opensslBin enc -aes-256-cbc -a -d -salt -in `"$($tfPlanFile).enc`" -out `"$($tfPlanFile)`" -pass `"pass:$($tfEncPassword)`""))
                    Log-Message -message "END: Decrypt terraform plan"
                }

                Log-Message -message "START: terraform apply"
                Invoke-Call ([ScriptBlock]::Create("$tfBin apply -input=false -auto-approve `"$($tfPlanFile)`""))
                Log-Message -message "END: terraform apply"
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Error "Message: $ErrorMessage`r`nItem: $FailedItem"
                exit 1
            }
            Log-Message -message "END: Deploy" -header
        }
        'destroy' {
            Log-Message -message "START: Destroy" -header
            try {
                Invoke-TerraformInit

                Log-Message -message "START: terraform destroy"
                Log-Message -message "INFO: Manual input required"
                $destroyConfirmation = Read-Host -Prompt "Continue and destroy $($tfFolderName) (environment: $($environmentShort))? [y/n]"
                if ( $destroyConfirmation -match "[yY]" ) { 
                    Invoke-Call ([ScriptBlock]::Create("$tfBin destroy -var-file=`"variables/$($environmentShort).tfvars`" -var-file=`"variables/common.tfvars`""))
                }
                Log-Message -message "END: terraform destroy"
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Error "Message: $ErrorMessage`r`nItem: $FailedItem"
                exit 1
            }
            Log-Message -message "END: Deploy" -header
        }
        'import' {
            Log-Message -message "START: Destroy" -header
            try {
                Invoke-TerraformInit

                Log-Message -message "START: terraform import"
                Invoke-Call ([ScriptBlock]::Create("$tfBin import -var-file=`"variables/$($environmentShort).tfvars`" -var-file=`"variables/common.tfvars`" $($tfImportResource)"))
                Log-Message -message "END: terraform import"
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Error "Message: $ErrorMessage`r`nItem: $FailedItem"
                exit 1
            }
            Log-Message -message "END: Deploy" -header
        }
        default {
            Write-Error "No options chosen."
            exit 1
        }
    }
}
End {
    
}