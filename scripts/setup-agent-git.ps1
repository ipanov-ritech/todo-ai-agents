# Setup Git Configuration for AI Agents
# This script allows you to switch between agent identities when making commits

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('pm', 'backend', 'frontend', 'devops', 'qa', 'reset')]
    [string]$Agent
)

$agents = @{
    'pm' = @{
        name = 'Product Manager AI'
        email = 'techdebtdemo2025po@outlook.com'
    }
    'backend' = @{
        name = 'Backend Developer AI'
        email = 'techdebtdemo2025be@outlook.com'
    }
    'frontend' = @{
        name = 'Frontend Developer AI'
        email = 'techdebtdemo2025fe@gmail.com'
    }
    'devops' = @{
        name = 'DevOps Engineer AI'
        email = 'devops-agent-bot@todo-ai-agents.demo'
    }
    'qa' = @{
        name = 'QA Engineer AI'
        email = 'qa-agent-bot@todo-ai-agents.demo'
    }
}

if ($Agent -eq 'reset') {
    Write-Host "Resetting git config to global defaults..." -ForegroundColor Yellow
    git config --local --unset user.name
    git config --local --unset user.email
    Write-Host "✓ Git config reset. Using global config now." -ForegroundColor Green
    git config user.name
    git config user.email
} else {
    $agentConfig = $agents[$Agent]
    Write-Host "Setting git identity to: $($agentConfig.name)" -ForegroundColor Cyan
    git config --local user.name $agentConfig.name
    git config --local user.email $agentConfig.email

    Write-Host "✓ Git configured for $($agentConfig.name)" -ForegroundColor Green
    Write-Host "  Name:  $($agentConfig.name)" -ForegroundColor Gray
    Write-Host "  Email: $($agentConfig.email)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "You can now make commits as this agent." -ForegroundColor Green
    Write-Host "To reset: .\setup-agent-git.ps1 -Agent reset" -ForegroundColor Gray
}
