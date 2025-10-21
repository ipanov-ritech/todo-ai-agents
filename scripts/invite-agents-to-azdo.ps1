# ============================================================================
# Azure DevOps Agent Invitation Script
# ============================================================================
# This script automates inviting the 5 AI agent email addresses to Azure DevOps
# using the Azure DevOps CLI (az devops extension)
#
# Prerequisites:
# 1. Install Azure CLI: https://aka.ms/installazurecliwindows
# 2. Install Azure DevOps extension: az extension add --name azure-devops
# 3. Create Personal Access Token (PAT) with User Entitlements (Write) scope
# 4. Set up Outlook.com email aliases as described in AZURE-DEVOPS-SETUP.md
# ============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$OrganizationUrl,

    [Parameter(Mandatory=$true)]
    [string]$ProjectName,

    [Parameter(Mandatory=$false)]
    [string]$PatToken = "",

    [Parameter(Mandatory=$false)]
    [ValidateSet("Basic", "Stakeholder", "Express")]
    [string]$LicenseType = "Basic",

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

# ============================================================================
# Configuration
# ============================================================================

# Agent email addresses (UPDATE THESE with your actual Outlook aliases)
$AgentEmails = @(
    @{
        Email = "pm-agent-bot@outlook.com"
        DisplayName = "PM Agent Bot"
        Role = "Product Manager"
    },
    @{
        Email = "backend-agent-bot@outlook.com"
        DisplayName = "Backend Agent Bot"
        Role = "Backend Developer"
    },
    @{
        Email = "frontend-agent-bot@outlook.com"
        DisplayName = "Frontend Agent Bot"
        Role = "Frontend Developer"
    },
    @{
        Email = "devops-agent-bot@outlook.com"
        DisplayName = "DevOps Agent Bot"
        Role = "DevOps Engineer"
    },
    @{
        Email = "qa-agent-bot@outlook.com"
        DisplayName = "QA Agent Bot"
        Role = "QA Engineer"
    }
)

# ============================================================================
# Functions
# ============================================================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Test-AzureDevOpsCli {
    Write-ColorOutput "`nChecking Azure DevOps CLI installation..." "Cyan"

    try {
        $azVersion = az --version 2>&1 | Select-String "azure-cli"
        if ($azVersion) {
            Write-ColorOutput "✓ Azure CLI is installed" "Green"
        }
    }
    catch {
        Write-ColorOutput "✗ Azure CLI is not installed" "Red"
        Write-ColorOutput "Install from: https://aka.ms/installazurecliwindows" "Yellow"
        return $false
    }

    try {
        $devopsExt = az extension list --query "[?name=='azure-devops'].version" -o tsv
        if ($devopsExt) {
            Write-ColorOutput "✓ Azure DevOps extension is installed (version $devopsExt)" "Green"
        }
        else {
            Write-ColorOutput "✗ Azure DevOps extension not found" "Red"
            Write-ColorOutput "Installing Azure DevOps extension..." "Yellow"
            az extension add --name azure-devops
        }
    }
    catch {
        Write-ColorOutput "✗ Error checking Azure DevOps extension" "Red"
        return $false
    }

    return $true
}

function Connect-AzureDevOps {
    param([string]$OrgUrl, [string]$Pat)

    Write-ColorOutput "`nConnecting to Azure DevOps..." "Cyan"

    if ([string]::IsNullOrEmpty($Pat)) {
        Write-ColorOutput "No PAT token provided. Attempting interactive login..." "Yellow"
        try {
            az login
            az devops configure --defaults organization=$OrgUrl
            return $true
        }
        catch {
            Write-ColorOutput "✗ Login failed: $_" "Red"
            return $false
        }
    }
    else {
        try {
            $env:AZURE_DEVOPS_EXT_PAT = $Pat
            az devops configure --defaults organization=$OrgUrl
            Write-ColorOutput "✓ Connected to $OrgUrl" "Green"
            return $true
        }
        catch {
            Write-ColorOutput "✗ Connection failed: $_" "Red"
            return $false
        }
    }
}

function Invite-AgentUser {
    param(
        [string]$Email,
        [string]$DisplayName,
        [string]$OrgUrl,
        [string]$License,
        [bool]$IsDryRun
    )

    if ($IsDryRun) {
        Write-ColorOutput "  [DRY RUN] Would invite: $Email ($DisplayName) with $License license" "Yellow"
        return $true
    }

    try {
        Write-ColorOutput "  Inviting: $Email ($DisplayName)..." "White"

        # Add user to organization
        az devops user add `
            --email-id $Email `
            --license-type $License `
            --organization $OrgUrl `
            --send-email-invite true `
            --output table

        Write-ColorOutput "  ✓ Successfully invited $DisplayName" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "  ✗ Failed to invite ${DisplayName}: $_" "Red"
        return $false
    }
}

function Add-UserToProject {
    param(
        [string]$Email,
        [string]$DisplayName,
        [string]$Project,
        [bool]$IsDryRun
    )

    if ($IsDryRun) {
        Write-ColorOutput "  [DRY RUN] Would add $DisplayName to project: $Project" "Yellow"
        return $true
    }

    try {
        Write-ColorOutput "  Adding $DisplayName to project '$Project'..." "White"

        # Add user to project
        az devops security group membership add `
            --group-id "[${Project}]\Contributors" `
            --member-id $Email `
            --output table

        Write-ColorOutput "  ✓ Successfully added to project" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "  ⚠ Could not add to project (user may need to accept invitation first)" "Yellow"
        return $false
    }
}

# ============================================================================
# Main Script
# ============================================================================

Write-ColorOutput @"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║        Azure DevOps AI Agent Invitation Script                  ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
"@ "Cyan"

Write-ColorOutput "`nConfiguration:" "Cyan"
Write-ColorOutput "  Organization: $OrganizationUrl" "White"
Write-ColorOutput "  Project:      $ProjectName" "White"
Write-ColorOutput "  License Type: $LicenseType" "White"
Write-ColorOutput "  Agents:       $($AgentEmails.Count)" "White"
if ($DryRun) {
    Write-ColorOutput "  Mode:         DRY RUN (no changes will be made)" "Yellow"
}

# Check prerequisites
if (-not (Test-AzureDevOpsCli)) {
    Write-ColorOutput "`n✗ Prerequisites not met. Exiting." "Red"
    exit 1
}

# Connect to Azure DevOps
if (-not (Connect-AzureDevOps -OrgUrl $OrganizationUrl -Pat $PatToken)) {
    Write-ColorOutput "`n✗ Failed to connect to Azure DevOps. Exiting." "Red"
    exit 1
}

# Invite each agent
Write-ColorOutput "`n════════════════════════════════════════════════════════════════" "Cyan"
Write-ColorOutput "Starting agent invitations..." "Cyan"
Write-ColorOutput "════════════════════════════════════════════════════════════════" "Cyan"

$successCount = 0
$failCount = 0

foreach ($agent in $AgentEmails) {
    Write-ColorOutput "`n[$($agent.Role)]" "Magenta"

    # Invite user to organization
    $inviteSuccess = Invite-AgentUser `
        -Email $agent.Email `
        -DisplayName $agent.DisplayName `
        -OrgUrl $OrganizationUrl `
        -License $LicenseType `
        -IsDryRun $DryRun

    if ($inviteSuccess) {
        $successCount++

        # Add user to project (may fail if invitation not yet accepted)
        Start-Sleep -Seconds 2
        Add-UserToProject `
            -Email $agent.Email `
            -DisplayName $agent.DisplayName `
            -Project $ProjectName `
            -IsDryRun $DryRun
    }
    else {
        $failCount++
    }
}

# Summary
Write-ColorOutput "`n════════════════════════════════════════════════════════════════" "Cyan"
Write-ColorOutput "Summary" "Cyan"
Write-ColorOutput "════════════════════════════════════════════════════════════════" "Cyan"
Write-ColorOutput "  Total agents:     $($AgentEmails.Count)" "White"
Write-ColorOutput "  Successfully invited: $successCount" "Green"
Write-ColorOutput "  Failed:           $failCount" "$(if ($failCount -gt 0) { 'Red' } else { 'Green' })"

if ($DryRun) {
    Write-ColorOutput "`n⚠ DRY RUN completed - no actual changes were made" "Yellow"
    Write-ColorOutput "Remove -DryRun flag to perform actual invitations" "Yellow"
}
else {
    Write-ColorOutput "`n✓ Invitation process completed!" "Green"
    Write-ColorOutput "`nNext steps:" "Cyan"
    Write-ColorOutput "1. Check your Outlook inbox for invitation emails" "White"
    Write-ColorOutput "2. Accept each invitation (one per alias)" "White"
    Write-ColorOutput "3. Verify users appear in Organization Settings > Users" "White"
    Write-ColorOutput "4. Assign work items to agents in Azure Boards" "White"
}

Write-ColorOutput "`n════════════════════════════════════════════════════════════════`n" "Cyan"

# ============================================================================
# Usage Examples:
# ============================================================================
#
# Dry run (test without making changes):
# .\invite-agents-to-azdo.ps1 `
#     -OrganizationUrl "https://dev.azure.com/your-org" `
#     -ProjectName "Todo AI Agents" `
#     -DryRun
#
# Actual run with PAT token:
# .\invite-agents-to-azdo.ps1 `
#     -OrganizationUrl "https://dev.azure.com/your-org" `
#     -ProjectName "Todo AI Agents" `
#     -PatToken "your-pat-token-here"
#
# Actual run with interactive login:
# .\invite-agents-to-azdo.ps1 `
#     -OrganizationUrl "https://dev.azure.com/your-org" `
#     -ProjectName "Todo AI Agents"
#
# Use Stakeholder licenses (free):
# .\invite-agents-to-azdo.ps1 `
#     -OrganizationUrl "https://dev.azure.com/your-org" `
#     -ProjectName "Todo AI Agents" `
#     -LicenseType "Stakeholder"
#
# ============================================================================
