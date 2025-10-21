# Azure DevOps Complete Setup Guide

**Date**: 2025-10-21
**Status**: Configuration Updated - Restart Required

---

## ✅ What's Been Configured

1. **Azure DevOps MCP `.env` file updated**:
   - Organization: `https://dev.azure.com/ipanov-ritech`
   - Project: `TodoAIAgents`
   - PAT Token: Configured with your latest token
   - Location: `C:/Users/USER/Documents/Cline/MCP/azuredevops-mcp/.env`

2. **Agent Emails Ready**:
   - PM: `techdebtdemo2025po@outlook.com`
   - Backend: `techdebtdemo2025be@outlook.com`
   - Frontend: `techdebtdemo2025fe@gmail.com`

---

## 🔄 Required: Restart Claude Code

The Azure DevOps MCP server needs to be restarted to pick up the new configuration.

**How to Restart:**

### Option 1: Restart Claude Code (Recommended)
1. Close Claude Code completely
2. Reopen Claude Code
3. The MCP will automatically restart with new config

### Option 2: Kill and Restart MCP Process
```powershell
# Find the process
tasklist | findstr node

# Kill the azuredevops-mcp process
taskkill /F /IM node.exe /FI "WINDOWTITLE eq *azuredevops-mcp*"

# Claude Code will auto-restart it
```

---

## 📋 Next Steps After Restart

### Step 1: Verify Azure DevOps Connection

After restarting, I'll test the connection by listing projects:

```
# This should return your projects in ipanov-ritech organization
mcp__azuredevops-mcp__listProjects
```

### Step 2: Create TodoAIAgents Project

If the project doesn't exist, we'll create it with:

**Project Settings:**
- Name: `TodoAIAgents`
- Process Template: `Agile` (supports User Stories, Tasks, Bugs)
- Visibility: `Private` or `Public`
- Description: "AI Agent Team Demo for TechDebtGPT"

**Using Azure DevOps MCP:**
```javascript
mcp__azuredevops-mcp__createProject({
  name: "TodoAIAgents",
  description: "AI Agent Team Demo for TechDebtGPT",
  visibility: "private",
  processTemplate: "Agile"
})
```

### Step 3: Add Agent Contributors

Add your 3 agent emails as project contributors:

**Contributors to Add:**
1. `techdebtdemo2025po@outlook.com` - Product Manager AI
2. `techdebtdemo2025be@outlook.com` - Backend Developer AI
3. `techdebtdemo2025fe@gmail.com` - Frontend Developer AI

**Access Level:** Basic (allows creating work items, committing code)

**Using Azure CLI or Portal:**
```bash
# Via Azure CLI
az devops user add \
  --email-id techdebtdemo2025po@outlook.com \
  --license-type express \
  --org https://dev.azure.com/ipanov-ritech

# Repeat for other 2 emails
```

### Step 4: Create Sprint 1 Backlog

Create work items for Sprint 1 - Task Priority Feature:

#### Epic
- **Title**: Task Priority Feature
- **Description**: Add priority levels (High/Medium/Low) to tasks
- **Assigned**: PM Agent

#### User Stories

**Story 1: Backend - Add Priority Field**
- **Title**: Add Priority to Tasks (Backend API)
- **Description**: Implement priority field in API and database
- **Acceptance Criteria**:
  - TaskPriority enum created (High=1, Medium=2, Low=3)
  - TodoTask entity has Priority property
  - EF Core migration created
  - API accepts/returns priority
  - Default priority is Medium
- **Assigned**: `techdebtdemo2025be@outlook.com`
- **Tags**: `backend`, `api`, `sprint-1`

**Story 2: Frontend - Priority UI**
- **Title**: Priority Dropdown and Badges (Frontend)
- **Description**: Add UI components for priority selection and display
- **Acceptance Criteria**:
  - Priority dropdown in task form
  - Color-coded priority badges (Red/Yellow/Green)
  - Redux state includes priority
- **Assigned**: `techdebtdemo2025fe@gmail.com`
- **Tags**: `frontend`, `ui`, `sprint-1`

**Story 3: Frontend - Priority Filter**
- **Title**: Filter and Sort by Priority (Frontend)
- **Description**: Allow users to filter/sort tasks by priority
- **Acceptance Criteria**:
  - Filter dropdown (All/High/Medium/Low)
  - Sort by priority option
  - Filter state in Redux
- **Assigned**: `techdebtdemo2025fe@gmail.com`
- **Tags**: `frontend`, `ui`, `sprint-1`

**Story 4: QA - Integration Tests**
- **Title**: Priority Feature Integration Tests
- **Description**: Test priority functionality end-to-end
- **Acceptance Criteria**:
  - API integration tests
  - E2E Playwright tests
  - Default priority validation
- **Assigned**: TBD (waiting for QA agent email)
- **Tags**: `qa`, `testing`, `sprint-1`

**Story 5: DevOps - CI/CD Updates**
- **Title**: Build and Deployment for Priority Feature
- **Description**: Ensure migrations run in CI/CD
- **Acceptance Criteria**:
  - Pipeline runs migrations
  - Build succeeds with new schema
  - No breaking changes
- **Assigned**: TBD (waiting for DevOps agent email)
- **Tags**: `devops`, `ci-cd`, `sprint-1`

### Step 5: Configure Kanban Board

**Board Columns:**
1. **New** - Newly created items
2. **Active** - In progress
3. **Resolved** - Code complete, in review
4. **Closed** - Merged and done

**Swimlanes:**
- By Agent (PM, Backend, Frontend, QA, DevOps)
- Or by Priority (High, Medium, Low)

### Step 6: Link to GitHub Repository

Configure Azure Boards to link with your GitHub repo:

**Integration Setup:**
1. Install **Azure Boards** GitHub App
2. Connect to repository: `ipanov-ritech/todo-ai-agents`
3. Enable automatic linking via commit messages

**Agent Workflow:**
```bash
# When committing, agents reference work items
git commit -m "feat(api): Add Priority field

- Add TaskPriority enum
- Update TodoTask entity

AB#1234"  # Links to Azure Boards work item #1234
```

---

## 🎯 Integration with TechDebtGPT

### How It Works Together

```
Azure Boards          GitHub             TechDebtGPT
    ↓                   ↓                     ↓
Work Items ----→ Commits/PRs ------→ Agent Metrics
    ↓                   ↓                     ↓
Sprint Board       Code Review        Performance Dashboard
    ↓                   ↓                     ↓
Agent Tasks       Agent Commits      Agent Scores
```

### Agent Workflow

1. **PM Agent** creates work items in Azure Boards
2. **Developer Agents** implement features, commit to GitHub with `AB#` references
3. **GitHub** tracks commits and PRs
4. **Azure Boards** shows linked commits on work items
5. **TechDebtGPT** analyzes commit quality
6. **Meta-agent** identifies lowest performer from TechDebtGPT metrics

---

## 📊 Demo Day Presentation

**What to Show:**

1. **Azure Boards** - Sprint board showing agent tasks
2. **GitHub** - Commits and PRs from different agents
3. **Azure Boards** - Work items showing linked GitHub commits
4. **TechDebtGPT** - Dashboard showing individual agent metrics
5. **Meta-agent** - Improvement suggestion for lowest performer

**The Story:**
> "We have 5 AI agents working as a development team. Azure Boards tracks their sprint work, GitHub hosts the code, and TechDebtGPT measures each agent's performance. When an agent underperforms, the meta-agent automatically suggests prompt improvements."

---

## 🔧 Troubleshooting

### MCP Still Shows 401 Error

**Solution:** Restart Claude Code completely

### Can't Create Project

**Check:**
1. PAT token has "Project: Read, write, & manage" permission
2. Organization URL is correct: `https://dev.azure.com/ipanov-ritech`
3. You have admin access to the organization

### Can't Add Contributors

**Check:**
1. Email addresses are valid
2. Users have accepted Azure DevOps invitation
3. PAT token has "User Entitlements: Write" permission

---

## 📝 Configuration Summary

```env
# Current Azure DevOps MCP Configuration
AZURE_DEVOPS_ORG_URL=https://dev.azure.com/ipanov-ritech
AZURE_DEVOPS_PROJECT=TodoAIAgents
AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN=<YOUR_PAT_TOKEN_HERE>
# Note: PAT token configured in C:/Users/USER/Documents/Cline/MCP/azuredevops-mcp/.env
```

**Repository:**
- GitHub: https://github.com/ipanov-ritech/todo-ai-agents

**Agents:**
- PM: techdebtdemo2025po@outlook.com
- Backend: techdebtdemo2025be@outlook.com
- Frontend: techdebtdemo2025fe@gmail.com
- DevOps: TBD
- QA: TBD

---

## ✅ Ready for Next Steps

**After you restart Claude Code, I can:**

1. ✅ List your Azure DevOps projects
2. ✅ Create TodoAIAgents project (if needed)
3. ✅ Add agent contributors
4. ✅ Create Sprint 1 work items
5. ✅ Set up Kanban board
6. ✅ Configure GitHub integration

**Please restart Claude Code and let me know when ready to continue!**
