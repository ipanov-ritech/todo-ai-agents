# TechDebtGPT Integration Guide

Complete guide for connecting TechDebtGPT to track AI agent performance in your Azure DevOps + GitHub setup.

---

## Overview

This integration enables TechDebtGPT to:
- Track work items completed by each AI agent
- Monitor commit frequency and code quality per agent
- Measure cycle time and throughput
- Identify bottlenecks and underperforming agents
- Provide data for the Agent Health MVP to optimize agents

---

## Part 1: Azure DevOps Connection

### Step 1: Create Personal Access Token (PAT)

1. Go to Azure DevOps: `https://dev.azure.com/{your-org}`
2. Click **User Settings** icon (top right) → **Personal access tokens**
3. Click **+ New Token**

**Token Configuration:**
```
Name: TechDebtGPT Integration
Organization: {your-org}
Expiration: 90 days

Scopes (Custom defined):
✅ Work Items (Read)
✅ Code (Read)
✅ Project and Team (Read)
✅ Build (Read)
✅ Graph (Read)
✅ Analytics (Read)
```

4. Click **Create** and **SAVE THE TOKEN** immediately

### Step 2: Configure TechDebtGPT Connection

In TechDebtGPT dashboard:

1. Navigate to **Settings** → **Integrations** → **Azure DevOps**
2. Click **Add Connection**
3. Enter connection details:

```json
{
  "connection_name": "Todo AI Agents Demo",
  "organization_url": "https://dev.azure.com/your-org",
  "project_name": "Todo AI Agents",
  "personal_access_token": "your-pat-token-here",
  "sync_interval": "15m",
  "enabled": true
}
```

4. Click **Test Connection** to verify
5. Click **Save**

### Step 3: Configure Metrics Collection

Enable these metrics in TechDebtGPT:

**Work Item Metrics:**
- Work items completed (by assignee)
- Work items created (by created by)
- Cycle time (Created → Done)
- Lead time (Created → In Progress)
- Work in progress (WIP) per agent
- Re-opened work items

**Activity Metrics:**
- Comments per work item
- Work item updates per day
- Sprint velocity per agent

**Query Configuration:**
```wiql
SELECT [System.Id], [System.Title], [System.AssignedTo],
       [System.State], [System.CreatedDate], [System.ChangedDate]
FROM WorkItems
WHERE [System.TeamProject] = 'Todo AI Agents'
  AND [System.WorkItemType] IN ('User Story', 'Bug', 'Task')
  AND [System.ChangedDate] >= @StartOfDay('-30')
ORDER BY [System.ChangedDate] DESC
```

---

## Part 2: GitHub Integration

### Step 1: Create GitHub Personal Access Token

1. Go to GitHub: https://github.com/settings/tokens
2. Click **Generate new token** → **Classic**
3. Configure token:

```
Note: TechDebtGPT Integration
Expiration: 90 days

Scopes:
✅ repo (Full control of private repositories)
  ✅ repo:status
  ✅ repo:deployment
  ✅ public_repo
  ✅ repo:invite
✅ read:org
✅ read:user
✅ user:email
```

4. Click **Generate token** and **SAVE IT**

### Step 2: Configure GitHub Connection in TechDebtGPT

1. Navigate to **Settings** → **Integrations** → **GitHub**
2. Click **Add Connection**
3. Enter details:

```json
{
  "connection_name": "Todo AI Agents Repo",
  "repository_owner": "your-github-username",
  "repository_name": "todo-ai-agents",
  "personal_access_token": "ghp_your_token_here",
  "sync_interval": "10m",
  "enabled": true
}
```

### Step 3: Configure Commit Attribution

Map agent git identities to TechDebtGPT:

```json
{
  "agent_mapping": {
    "pm-agent-bot@todo-ai-agents.demo": {
      "name": "PM Agent",
      "role": "ProductManager",
      "azure_devops_email": "pm-agent-bot@outlook.com",
      "github_email": "pm-agent-bot@todo-ai-agents.demo"
    },
    "backend-agent-bot@todo-ai-agents.demo": {
      "name": "Backend Agent",
      "role": "BackendDeveloper",
      "azure_devops_email": "backend-agent-bot@outlook.com",
      "github_email": "backend-agent-bot@todo-ai-agents.demo"
    },
    "frontend-agent-bot@todo-ai-agents.demo": {
      "name": "Frontend Agent",
      "role": "FrontendDeveloper",
      "azure_devops_email": "frontend-agent-bot@outlook.com",
      "github_email": "frontend-agent-bot@todo-ai-agents.demo"
    },
    "devops-agent-bot@todo-ai-agents.demo": {
      "name": "DevOps Agent",
      "role": "DevOpsEngineer",
      "azure_devops_email": "devops-agent-bot@outlook.com",
      "github_email": "devops-agent-bot@todo-ai-agents.demo"
    },
    "qa-agent-bot@todo-ai-agents.demo": {
      "name": "QA Agent",
      "role": "QAEngineer",
      "azure_devops_email": "qa-agent-bot@outlook.com",
      "github_email": "qa-agent-bot@todo-ai-agents.demo"
    }
  }
}
```

### Step 4: Enable Commit Metrics

Track these GitHub metrics per agent:

- Commits per day/week
- Lines added/deleted per commit
- Files changed per commit
- Commit message quality score
- PR creation frequency
- PR merge time
- PR review comments given/received

---

## Part 3: Linking Azure DevOps ↔ GitHub

### Step 1: Enable Azure Boards GitHub Integration

1. In Azure DevOps: **Project Settings** → **GitHub connections**
2. Click **Connect your GitHub account**
3. Authorize Azure Boards app
4. Select repository: `todo-ai-agents`

### Step 2: Configure Work Item Linking

**Method 1: Commit Messages**
```bash
git commit -m "feat(api): Add priority field

Implements priority enum for tasks

AB#123"
```
- `AB#` prefix links to Azure Boards work item

**Method 2: PR Descriptions**
```markdown
## Summary
Add priority field to task entity

## Related Work Items
- AB#123
```

### Step 3: Configure TechDebtGPT to Track Links

Enable in TechDebtGPT settings:
```json
{
  "link_tracking": {
    "azure_boards_prefix": "AB#",
    "github_issue_prefix": "#",
    "track_pr_to_workitem": true,
    "track_commit_to_workitem": true
  }
}
```

---

## Part 4: Dashboard & Reporting

### Key Performance Indicators (KPIs) to Track

#### Agent Productivity Metrics:
1. **Work Items Completed per Sprint**
   - Target: 3-5 per agent
   - Alert if: < 2

2. **Average Cycle Time**
   - Target: 2-3 days
   - Alert if: > 5 days

3. **Code Commit Frequency**
   - Target: 5-10 commits per week
   - Alert if: < 2

4. **PR Merge Time**
   - Target: < 24 hours
   - Alert if: > 48 hours

5. **Test Pass Rate**
   - Target: 100% (QA agent)
   - Alert if: < 95%

6. **Code Review Quality**
   - Comments per PR: 3-5
   - Issues found: 1-3

#### Agent Health Scores:

Calculate composite score (0-100):
```
AgentHealthScore =
  (WorkItemsCompleted * 0.3) +
  (CommitFrequency * 0.2) +
  (CodeQuality * 0.25) +
  (CycleTimeScore * 0.15) +
  (CollaborationScore * 0.1)
```

### Sample TechDebtGPT Dashboard Queries

**1. Agent Performance Leaderboard:**
```sql
SELECT
  agent_name,
  COUNT(work_items) AS completed_items,
  AVG(cycle_time_days) AS avg_cycle_time,
  COUNT(commits) AS total_commits,
  agent_health_score
FROM agent_metrics
WHERE date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY agent_name
ORDER BY agent_health_score DESC
```

**2. Bottleneck Detection:**
```sql
SELECT
  work_item_id,
  title,
  assigned_to,
  state,
  DATEDIFF(NOW(), changed_date) AS days_stale
FROM work_items
WHERE state = 'In Progress'
  AND DATEDIFF(NOW(), changed_date) > 5
ORDER BY days_stale DESC
```

**3. Agent Velocity Trend:**
```sql
SELECT
  DATE(completed_date) AS completion_date,
  assigned_to AS agent,
  COUNT(*) AS items_completed
FROM work_items
WHERE state = 'Done'
  AND completed_date >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY completion_date, agent
ORDER BY completion_date, agent
```

---

## Part 5: Agent Health MVP Connection

### Step 1: Export TechDebtGPT Data

TechDebtGPT should expose an API endpoint:

```
GET /api/v1/agents/{agent_id}/metrics
Authorization: Bearer {api_token}

Response:
{
  "agent_id": "backend-agent-bot",
  "period": "30d",
  "metrics": {
    "work_items_completed": 12,
    "avg_cycle_time_days": 2.5,
    "commit_count": 45,
    "lines_changed": 1250,
    "pr_count": 8,
    "avg_pr_merge_time_hours": 18,
    "test_pass_rate": 0.96,
    "code_review_comments": 23,
    "health_score": 78
  }
}
```

### Step 2: Configure Agent Health MVP

In your Agent Health MVP application:

```json
{
  "techdebtgpt_config": {
    "api_url": "https://api.techdebtgpt.com/v1",
    "api_token": "your-api-token",
    "sync_interval": "1h",
    "agents_to_monitor": [
      "pm-agent-bot",
      "backend-agent-bot",
      "frontend-agent-bot",
      "devops-agent-bot",
      "qa-agent-bot"
    ]
  },
  "health_thresholds": {
    "critical": 50,
    "warning": 65,
    "good": 80
  }
}
```

### Step 3: Define Optimization Rules

When Agent Health MVP detects underperformance:

```javascript
// Example optimization logic
if (agent.health_score < 65) {
  if (agent.metrics.avg_cycle_time_days > 5) {
    recommendations.push({
      type: "REDUCE_SCOPE",
      message: "Agent is taking too long per task. Consider breaking down work items into smaller pieces."
    });
  }

  if (agent.metrics.commit_count < 10) {
    recommendations.push({
      type: "INCREASE_COMMIT_FREQUENCY",
      message: "Agent is not committing often enough. Recommend more frequent, smaller commits."
    });
  }

  if (agent.metrics.test_pass_rate < 0.90) {
    recommendations.push({
      type: "IMPROVE_TEST_QUALITY",
      message: "Test pass rate is low. Review test coverage and quality practices."
    });
  }
}
```

---

## Part 6: Demo Workflow Testing

### Test Scenario 1: Complete Feature Cycle

1. **PM Agent** creates work item in Azure Boards
2. **Backend Agent** implements feature:
   ```bash
   .\scripts\switch-agent.ps1 backend
   # Make changes
   git commit -m "feat(api): Add feature AB#1"
   git push origin feature/add-feature
   # Create PR
   ```
3. **TechDebtGPT** tracks:
   - Work item transition: To Do → In Progress
   - Commit attributed to backend-agent-bot
   - PR created and linked to AB#1

4. **QA Agent** reviews and merges:
   ```bash
   .\scripts\switch-agent.ps1 qa
   # Review PR, run tests
   gh pr review {pr-number} --approve
   gh pr merge {pr-number}
   ```
5. **TechDebtGPT** records:
   - Work item transition: In Progress → Done
   - Cycle time calculation
   - Agent health score update

### Test Scenario 2: Detect Bottleneck

1. **Frontend Agent** starts work but gets stuck
2. Work item stays "In Progress" for 6 days
3. **TechDebtGPT** alerts: "Frontend Agent has stale work item"
4. **Agent Health MVP** recommends: "Break down work item or reassign"

### Validation Checklist

- [ ] Azure DevOps connection successful
- [ ] GitHub connection successful
- [ ] Commits attributed to correct agents
- [ ] Work items linked to commits/PRs
- [ ] Cycle time calculated correctly
- [ ] Agent health scores updating
- [ ] Dashboard showing all 5 agents
- [ ] Alerts triggering for stale work
- [ ] Agent Health MVP receiving data
- [ ] Optimization recommendations generated

---

## Troubleshooting

### Issue: TechDebtGPT not seeing Azure DevOps work items
**Solution:**
- Verify PAT token has "Work Items (Read)" scope
- Check organization URL is correct (https://dev.azure.com/{org})
- Ensure project name matches exactly

### Issue: Commits not attributed to agents
**Solution:**
- Verify git email matches agent definition
- Use `git log --format="%an <%ae>"` to check commit author
- Ensure agent mapping in TechDebtGPT is correct

### Issue: Work items not linking to GitHub PRs
**Solution:**
- Use `AB#123` format in commit messages or PR descriptions
- Verify Azure Boards GitHub app is connected
- Check repository is selected in Azure DevOps GitHub settings

### Issue: Agent Health scores not updating
**Solution:**
- Check TechDebtGPT API connection to Agent Health MVP
- Verify sync interval is not too long
- Check API token hasn't expired

---

## API Reference for Custom Integrations

If you need to build custom integrations:

### TechDebtGPT REST API Endpoints:

```
GET /api/v1/agents
GET /api/v1/agents/{agent_id}
GET /api/v1/agents/{agent_id}/metrics
GET /api/v1/agents/{agent_id}/work-items
GET /api/v1/agents/{agent_id}/commits
GET /api/v1/agents/{agent_id}/health-score
POST /api/v1/agents/{agent_id}/optimize
```

### Webhook Configuration:

Set up webhooks to get real-time updates:

```json
{
  "webhook_url": "https://your-agent-health-mvp.com/webhooks/techdebtgpt",
  "events": [
    "work_item.completed",
    "work_item.stale",
    "agent.health_score_updated",
    "agent.underperforming"
  ],
  "secret": "your-webhook-secret"
}
```

---

## Next Steps

After completing integration:

1. ✅ Run test scenarios to validate data flow
2. ✅ Monitor dashboard for 1-2 sprints
3. ✅ Tune health score thresholds
4. ✅ Train Agent Health MVP with optimization rules
5. ✅ Document lessons learned for production rollout

---

**Integration Time Estimate:** 1-2 hours
**Prerequisites:** Azure DevOps org, GitHub repo, TechDebtGPT access, Agent Health MVP
**Dependencies:** Both Azure DevOps and GitHub must be set up first
