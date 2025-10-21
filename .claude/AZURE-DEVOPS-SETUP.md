# Azure DevOps Setup Guide - AI Agents Demo

Complete step-by-step guide to set up 5 AI agent accounts in Azure DevOps for your demo.

---

## Part 1: Create Outlook.com Email Aliases (5 minutes)

### Step 1: Sign in to Outlook.com
1. Go to https://outlook.live.com
2. Sign in with your existing Microsoft account (or create a free one)

### Step 2: Access Alias Settings
1. Click the **Settings icon** (gear) in top right
2. Go to **View all Outlook settings**
3. Navigate to **Accounts → Your info**
4. Or go directly to: https://account.microsoft.com/profile/

### Step 3: Add Email Aliases
1. Under "Account info", find "**Email addresses**" section
2. Click "**Add email**" or "**Manage how you sign in to Microsoft**"
3. Create 5 new Outlook.com aliases:

```
pm-agent-bot@outlook.com
backend-agent-bot@outlook.com
frontend-agent-bot@outlook.com
devops-agent-bot@outlook.com
qa-agent-bot@outlook.com
```

**Note:** If those names are taken, try variations like:
- `pm-agent-demo@outlook.com`
- `backend-dev-agent@outlook.com`
- Use your org name: `pm-agent-yourcompany@outlook.com`

### Step 4: Verify Aliases
1. All aliases should appear in your account
2. All emails to these aliases will arrive in your main inbox
3. You can sign in to Microsoft services using any alias

✅ **You now have 5 valid email addresses for Azure DevOps!**

---

## Part 2: Set Up Azure DevOps Organization (5 minutes)

### Step 1: Create or Access Your Organization
1. Go to https://dev.azure.com
2. Sign in with your Microsoft account
3. Create a new organization or use existing one
4. Organization name suggestion: `todo-ai-agents-demo`

### Step 2: Create a New Project
1. Click "**+ New Project**"
2. Project name: `Todo AI Agents`
3. Visibility: **Private**
4. Work item process: **Basic** or **Agile**
5. Click "**Create**"

---

## Part 3: Invite Agent Users to Azure DevOps (10 minutes)

### Option A: Manual Invitation (Recommended for Demo)

1. Go to **Organization Settings** (bottom left)
2. Click **Users** under "General"
3. Click "**Add users**"

For each agent, add:

**Agent 1 - PM Agent:**
- Email: `pm-agent-bot@outlook.com`
- Access level: **Basic** (or Stakeholder for free)
- Add to project: `Todo AI Agents`
- Azure DevOps Groups: `Project Contributors`

**Agent 2 - Backend Agent:**
- Email: `backend-agent-bot@outlook.com`
- Access level: **Basic**
- Add to project: `Todo AI Agents`
- Azure DevOps Groups: `Project Contributors`

**Agent 3 - Frontend Agent:**
- Email: `frontend-agent-bot@outlook.com`
- Access level: **Basic**
- Add to project: `Todo AI Agents`
- Azure DevOps Groups: `Project Contributors`

**Agent 4 - DevOps Agent:**
- Email: `devops-agent-bot@outlook.com`
- Access level: **Basic**
- Add to project: `Todo AI Agents`
- Azure DevOps Groups: `Project Contributors`

**Agent 5 - QA Agent:**
- Email: `qa-agent-bot@outlook.com`
- Access level: **Basic**
- Add to project: `Todo AI Agents`
- Azure DevOps Groups: `Project Contributors`

4. Click "**Add**" to send invitations

### Option B: PowerShell Script with Azure DevOps CLI

See `scripts/invite-agents-to-azdo.ps1` for automated approach.

---

## Part 4: Accept Invitations (5 minutes)

### Step 1: Check Your Email Inbox
1. Go to https://outlook.live.com
2. You'll see 5 invitation emails from Azure DevOps
3. Each email says "You've been invited to join..."

### Step 2: Accept Each Invitation
1. Open first invitation email
2. Click "**Accept invitation**"
3. You'll be signed in with that alias
4. Complete any Azure DevOps setup prompts
5. Repeat for all 5 aliases

**Tip:** Use browser incognito windows to accept invitations without signing out each time, or just accept them one by one.

---

## Part 5: Configure Azure Boards (10 minutes)

### Step 1: Enable Azure Boards
1. Go to your project: `https://dev.azure.com/{org}/Todo AI Agents`
2. Click **Boards** in left menu
3. Click **Work Items**

### Step 2: Create Custom Fields (Optional)
1. Go to **Project Settings** → **Project configuration**
2. Under **Process**, click your process template
3. Add custom field: "**Agent Type**" (text field)
4. Add custom field: "**TechDebtGPT Score**" (integer field)

### Step 3: Create Sample Work Items for Demo

Create these 3 user stories:

#### Story 1: Add Priority Field to Tasks (Backend)
```
Title: Add Priority Field to Tasks
Assigned to: backend-agent-bot@outlook.com
Description:
Add priority field (High/Medium/Low) to task entity for better task organization.

Acceptance Criteria:
- [ ] Task entity has Priority enum field (High=1, Medium=2, Low=3)
- [ ] API accepts priority when creating tasks
- [ ] API accepts priority when updating tasks
- [ ] API returns priority with task data
- [ ] Database migration created
- [ ] Default priority is Medium if not specified

Tags: backend, database, api
```

#### Story 2: Add Priority UI to Task Form (Frontend)
```
Title: Add Priority UI to Task Form
Assigned to: frontend-agent-bot@outlook.com
Depends on: Story 1
Description:
Add priority dropdown to task creation/editing UI and display priority badges in task list.

Acceptance Criteria:
- [ ] Task form shows priority dropdown with High/Medium/Low options
- [ ] Task list displays priority badge with color coding
- [ ] Priority is color-coded (High=red, Medium=yellow, Low=green)
- [ ] Default priority is Medium when creating new tasks
- [ ] Redux state includes priority field

Tags: frontend, ui, react
```

#### Story 3: Priority Feature Integration Tests (QA)
```
Title: Priority Feature Integration Tests
Assigned to: qa-agent-bot@outlook.com
Depends on: Story 1, Story 2
Description:
Test priority feature end-to-end with integration and E2E tests.

Acceptance Criteria:
- [ ] Integration tests for priority API endpoints
- [ ] E2E tests for priority UI functionality
- [ ] Test priority default values
- [ ] Test priority updates
- [ ] All tests passing in CI/CD

Tags: qa, testing, integration-test
```

### Step 4: Configure Board View
1. Go to **Boards** → **Boards**
2. Configure columns: To Do → In Progress → Review → Done
3. Add swimlanes by agent (optional)

---

## Part 6: Connect GitHub Repository (5 minutes)

### Step 1: Install Azure Boards App in GitHub
1. Go to **Project Settings** → **GitHub connections**
2. Click "**Connect your GitHub account**"
3. Authorize Azure Boards in GitHub
4. Select repository: `todo-ai-agents`

### Step 2: Enable Work Item Linking
1. In project settings, enable "**Commit mention linking**"
2. Commits with `#123` will link to work items
3. PRs with `AB#123` will link to Azure Boards items

### Step 3: Test Connection
1. Make a test commit: `git commit -m "test: Azure Boards connection AB#1"`
2. Check if commit appears in work item #1

---

## Part 7: Generate Personal Access Token (PAT) (3 minutes)

You'll need this for TechDebtGPT integration.

### Step 1: Create PAT
1. Click your profile icon (top right)
2. Select "**Personal access tokens**"
3. Click "**+ New Token**"

### Step 2: Configure Token
- Name: `TechDebtGPT Integration`
- Organization: `todo-ai-agents-demo`
- Expiration: 90 days (or custom)
- Scopes:
  - ✅ Work Items (Read)
  - ✅ Code (Read)
  - ✅ Project and Team (Read)
  - ✅ Build (Read)
  - ✅ Release (Read)

### Step 3: Save Token
1. Click "**Create**"
2. **COPY THE TOKEN** - you won't see it again!
3. Save it securely (password manager or temp file)

---

## Part 8: Connect TechDebtGPT (from your other MVP)

### Step 1: Configure Azure DevOps Connection
1. Open TechDebtGPT dashboard
2. Go to "**Integrations**" or "**Settings**"
3. Click "**Add Azure DevOps Connection**"

### Step 2: Enter Connection Details
```
Organization URL: https://dev.azure.com/todo-ai-agents-demo
Project Name: Todo AI Agents
Personal Access Token: [paste your PAT from Part 7]
```

### Step 3: Configure Metrics Tracking
Enable tracking for:
- ✅ Work items completed per agent
- ✅ Cycle time by assignee
- ✅ Commit frequency per agent
- ✅ PR review time
- ✅ Bug/issue reopening rate

### Step 4: Map Agents to Email Patterns
Configure TechDebtGPT to recognize agents:
```json
{
  "agents": [
    {
      "name": "PM Agent",
      "email": "pm-agent-bot@outlook.com",
      "github": "pm-agent-bot@todo-ai-agents.demo",
      "role": "ProductManager"
    },
    {
      "name": "Backend Agent",
      "email": "backend-agent-bot@outlook.com",
      "github": "backend-agent-bot@todo-ai-agents.demo",
      "role": "BackendDeveloper"
    },
    {
      "name": "Frontend Agent",
      "email": "frontend-agent-bot@outlook.com",
      "github": "frontend-agent-bot@todo-ai-agents.demo",
      "role": "FrontendDeveloper"
    },
    {
      "name": "DevOps Agent",
      "email": "devops-agent-bot@outlook.com",
      "github": "devops-agent-bot@todo-ai-agents.demo",
      "role": "DevOpsEngineer"
    },
    {
      "name": "QA Agent",
      "email": "qa-agent-bot@outlook.com",
      "github": "qa-agent-bot@todo-ai-agents.demo",
      "role": "QAEngineer"
    }
  ]
}
```

---

## Part 9: Demo Workflow

### Demo Script:
1. **Show Azure DevOps Board** with 3 stories assigned to agents
2. **Backend Agent** implements Story 1:
   - Use `.\scripts\switch-agent.ps1 backend`
   - Commit with message: `feat(api): Add Priority field AB#1`
   - Create PR, assign to QA agent
3. **Frontend Agent** implements Story 2:
   - Use `.\scripts\switch-agent.ps1 frontend`
   - Commit with message: `feat(ui): Add priority dropdown AB#2`
   - Create PR, assign to QA agent
4. **QA Agent** tests and approves:
   - Review both PRs
   - Merge when tests pass
5. **Show TechDebtGPT Dashboard**:
   - Display agent performance metrics
   - Show commit attribution per agent
   - Highlight any bottlenecks
6. **Show Agent Health MVP**:
   - Analyze underperforming agents
   - Suggest optimizations

---

## Troubleshooting

### Issue: Alias email not working in Azure DevOps
**Solution:** Make sure you're using the alias as a full Microsoft account. Sign in to https://login.microsoft.com with the alias first to verify it works.

### Issue: Can't add users (no licenses)
**Solution:** Use "Stakeholder" license (free, up to unlimited users) or use free tier (5 Basic users).

### Issue: GitHub commits not linking to work items
**Solution:** Use format `AB#123` in commit messages, not just `#123`.

### Issue: TechDebtGPT can't connect
**Solution:** Verify PAT token has correct scopes and hasn't expired.

### Issue: Invitations not received
**Solution:** Check your main Outlook inbox - all alias emails go there.

---

## Quick Reference

### Agent Emails (Update with your actual aliases):
```
pm-agent-bot@outlook.com
backend-agent-bot@outlook.com
frontend-agent-bot@outlook.com
devops-agent-bot@outlook.com
qa-agent-bot@outlook.com
```

### Azure DevOps URLs:
```
Organization: https://dev.azure.com/{your-org}
Project: https://dev.azure.com/{your-org}/Todo AI Agents
Boards: https://dev.azure.com/{your-org}/Todo AI Agents/_boards
```

### Git Commands for Agent Switching:
```powershell
.\scripts\switch-agent.ps1 backend
.\scripts\switch-agent.ps1 frontend
.\scripts\switch-agent.ps1 qa
.\scripts\switch-agent.ps1 devops
.\scripts\switch-agent.ps1 pm
```

---

## Next Steps After Demo

1. ✅ Document agent performance results
2. ✅ Analyze TechDebtGPT metrics
3. ✅ Identify optimization opportunities
4. ✅ Test meta-agent optimization loop
5. ✅ Prepare for production rollout

---

**Setup Time Estimate:** 30-40 minutes total
**Prerequisites:** Microsoft account, GitHub account, TechDebtGPT access
**Cost:** Free (using Azure DevOps free tier)
