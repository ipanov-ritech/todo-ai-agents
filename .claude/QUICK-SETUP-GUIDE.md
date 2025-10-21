# Quick Setup Guide - AI Agents Demo

**Goal**: Set up 5 AI agents in Azure DevOps that can work on features, with their activity tracked in TechDebtGPT.

**Time**: 30 minutes total

---

## Part 1: Azure DevOps Organization Setup (10 minutes)

### Step 1: Access Your Azure DevOps Organization

You already have an organization: **ipanov-ritech**
- URL: https://dev.azure.com/ipanov-ritech
- Existing project: `techdebtgpt-agent-health-mvp`

**Decision Point**: Do you want to:
- **Option A**: Use the existing project `techdebtgpt-agent-health-mvp` ✅ RECOMMENDED
- **Option B**: Create a new project called `Todo AI Agents`

For this guide, we'll use **Option A** (existing project).

### Step 2: Invite AI Agents to Your Organization

Go to https://dev.azure.com/ipanov-ritech/_settings/users

Click **"Add users"** and add each of these agents:

| Email | Access Level | Add to Project |
|-------|-------------|----------------|
| techdebtdemo2025po@outlook.com | Basic | techdebtgpt-agent-health-mvp |
| techdebtdemo2025be@outlook.com | Basic | techdebtgpt-agent-health-mvp |
| techdebtdemo2025fe@gmail.com | Basic | techdebtgpt-agent-health-mvp |

**For DevOps and QA agents**, you'll need to create email addresses first, then add them.

**Note**: If you don't have enough "Basic" licenses, use "Stakeholder" (free, unlimited).

---

## Part 2: Accept Agent Invitations (5 minutes)

1. Check your email inbox (for techdebtdemo2025po@outlook.com, etc.)
2. You'll receive invitation emails from Azure DevOps
3. Click "Accept invitation" in each email
4. Complete any Azure DevOps onboarding prompts

**Tip**: You can use browser incognito mode to stay signed in as multiple agents simultaneously.

---

## Part 3: Create Work Items for Sprint 1 (10 minutes)

Go to: https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_workitems

Your project uses the **"Basic"** process, so you'll create **"Issues"** (not User Stories).

### Issue 1: Backend - Add Priority Field
```
Title: Story 1: Add Priority to Tasks (Backend)
Assigned To: techdebtdemo2025be@outlook.com
State: To Do
Tags: backend, api, database, sprint-1

Description:
As a user, I want to assign a priority level to my tasks so that I can organize by importance.

Acceptance Criteria:
- [ ] Task entity has Priority enum field (High=1, Medium=2, Low=3)
- [ ] API accepts priority when creating/updating tasks
- [ ] API returns priority with task data
- [ ] Database migration created
- [ ] Default priority is Medium if not specified

Technical Notes:
- Create TaskPriority enum in Entities folder
- Update TodoTask entity with Priority property
- Create EF migration: dotnet ef migrations add AddTaskPriority
- Update TasksController to handle priority field
```

### Issue 2: Frontend - Priority UI
```
Title: Story 2: Priority UI Components (Frontend)
Assigned To: techdebtdemo2025fe@gmail.com
State: To Do
Tags: frontend, ui, react, sprint-1
Related: Links to Issue 1 (Depends On)

Description:
As a user, I want to see and set priority on tasks in the UI so that I can visually identify important tasks.

Acceptance Criteria:
- [ ] Priority dropdown in add/edit task form
- [ ] Priority badge on each task with color coding (High=Red, Medium=Yellow, Low=Green)
- [ ] Priority selector uses React-Bootstrap components
- [ ] Redux state includes priority field

Technical Notes:
- Update TaskForm component with priority dropdown
- Create PriorityBadge component
- Update Redux actions and reducers
```

### Issue 3: Frontend - Filter and Sort
```
Title: Story 3: Filter and Sort by Priority (Frontend)
Assigned To: techdebtdemo2025fe@gmail.com
State: To Do
Tags: frontend, ui, react, sprint-1
Related: Links to Issue 2 (Depends On)

Description:
As a user, I want to filter and sort tasks by priority so that I can focus on high-priority items.

Acceptance Criteria:
- [ ] Filter dropdown to show only tasks of selected priority
- [ ] "All" option to show all priorities
- [ ] Tasks can be sorted by priority (High → Low)
- [ ] Filter/sort state persisted in Redux
- [ ] UI updates immediately when filter changes
```

---

## Part 4: Connect GitHub Repository (5 minutes)

### Step 1: Install Azure Boards App in GitHub

1. Go to your GitHub repository: https://github.com/ipanov-ritech/todo-ai-agents
2. Go to **Settings → Integrations → Applications**
3. Search for **"Azure Boards"**
4. Click **"Configure"** on Azure Boards
5. Select your repository: `ipanov-ritech/todo-ai-agents`
6. Click **"Install & Authorize"**

### Step 2: Link in Azure DevOps

1. Go to: https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_settings/boards-external-integration
2. Click **"Connect to GitHub"**
3. Authorize the connection
4. Select repository: `ipanov-ritech/todo-ai-agents`

### Step 3: Test the Connection

Make a test commit:
```bash
git commit -m "test: Azure Boards integration AB#1"
git push
```

Then check if the commit appears linked to work item #1 in Azure DevOps.

**Note**: Use `AB#{number}` format in commit messages to link to Azure Boards work items.

---

## Part 5: Configure Agent Git Identities (Already Done!)

You already have the agent definitions in `.claude/agents/` and the git switching script in `scripts/setup-agent-git.ps1`.

**Your existing agents:**
- PM Agent: techdebtdemo2025po@outlook.com
- Backend Agent: techdebtdemo2025be@outlook.com
- Frontend Agent: techdebtdemo2025fe@gmail.com

**To switch agents:**
```powershell
.\scripts\setup-agent-git.ps1 -Agent backend
.\scripts\setup-agent-git.ps1 -Agent frontend
.\scripts\setup-agent-git.ps1 -Agent pm
```

---

## Part 6: TechDebtGPT Integration

### Create Azure DevOps Personal Access Token (PAT)

1. Go to: https://dev.azure.com/ipanov-ritech/_usersSettings/tokens
2. Click **"+ New Token"**
3. Configure:
   - Name: `TechDebtGPT Integration`
   - Organization: `ipanov-ritech`
   - Expiration: 90 days (or custom)
   - Scopes:
     - ✅ **Work Items** (Read)
     - ✅ **Code** (Read)
     - ✅ **Project and Team** (Read)
4. Click **"Create"**
5. **COPY THE TOKEN** - save it securely!

### Configure TechDebtGPT

In your TechDebtGPT application, add this configuration:

```json
{
  "azureDevOps": {
    "organizationUrl": "https://dev.azure.com/ipanov-ritech",
    "project": "techdebtgpt-agent-health-mvp",
    "personalAccessToken": "YOUR_PAT_TOKEN_HERE"
  },
  "github": {
    "owner": "ipanov-ritech",
    "repo": "todo-ai-agents",
    "personalAccessToken": "YOUR_GITHUB_PAT_HERE"
  },
  "agents": [
    {
      "name": "PM Agent",
      "email": "techdebtdemo2025po@outlook.com",
      "role": "ProductManager"
    },
    {
      "name": "Backend Agent",
      "email": "techdebtdemo2025be@outlook.com",
      "role": "BackendDeveloper"
    },
    {
      "name": "Frontend Agent",
      "email": "techdebtdemo2025fe@gmail.com",
      "role": "FrontendDeveloper"
    }
  ]
}
```

---

## Part 7: Test the Full Workflow

### Test 1: Backend Agent Works on a Feature

```powershell
# Switch to backend agent identity
.\scripts\setup-agent-git.ps1 -Agent backend

# Verify identity
git config user.email  # Should show: techdebtdemo2025be@outlook.com

# Create feature branch (you already have this!)
git checkout feature/add-priority-backend

# Make a small change or just commit what you have
git add .
git commit -m "feat(api): Add Priority field to Task entity AB#1

- Added TaskPriority enum
- Updated TodoTask entity with Priority property
- Created EF Core migration
- API supports priority in requests/responses"

# Push and create PR
git push origin feature/add-priority-backend
```

### Test 2: Verify in Azure DevOps

1. Go to: https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_workitems
2. Open work item #1
3. You should see your commit linked under "Development"

### Test 3: Verify in TechDebtGPT

Your TechDebtGPT app should now show:
- Commit by `techdebtdemo2025be@outlook.com` (Backend Agent)
- Work item #1 updated
- Metrics tracked for Backend Agent

---

## Summary Checklist

- [ ] Azure DevOps organization accessible
- [ ] 3 agents invited (PM, Backend, Frontend)
- [ ] Agents accepted invitations
- [ ] 3 work items created and assigned
- [ ] GitHub repo connected to Azure Boards
- [ ] PAT token created for TechDebtGPT
- [ ] TechDebtGPT configured with Azure DevOps connection
- [ ] Test commit linked to work item
- [ ] Agent activity showing in TechDebtGPT

---

## Next Steps

Once setup is complete:

1. **Backend Agent** implements Story 1 (Priority field)
2. **Frontend Agent** implements Stories 2-3 (UI components)
3. **TechDebtGPT** tracks all agent activity
4. **Agent Health MVP** analyzes performance and suggests optimizations

---

## Troubleshooting

### Issue: Can't add users (no licenses)
**Solution**: Use "Stakeholder" access level (free, unlimited users)

### Issue: Commits not linking to work items
**Solution**: Ensure you use `AB#{number}` format in commit messages

### Issue: TechDebtGPT can't connect
**Solution**:
1. Verify PAT token hasn't expired
2. Check PAT has correct scopes (Work Items Read, Code Read)
3. Verify organization URL is exact: `https://dev.azure.com/ipanov-ritech`

### Issue: Agent invitation not received
**Solution**: Check spam folder, or manually add users through Azure DevOps portal

---

## Useful Links

- **Azure DevOps Organization**: https://dev.azure.com/ipanov-ritech
- **Project**: https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp
- **Work Items**: https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_workitems
- **Boards**: https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_boards
- **GitHub Repo**: https://github.com/ipanov-ritech/todo-ai-agents
