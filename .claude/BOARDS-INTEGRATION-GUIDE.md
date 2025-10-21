# Boards Integration Guide: GitHub Projects vs Azure Boards

**Decision**: How to manage Sprint 1 work items and track agent progress

---

## 🎯 The Three Options

### Option 1: GitHub Projects Only (Simplest)
Use GitHub's native project management

### Option 2: Azure Boards + GitHub Integration (Best of Both)
Use Azure Boards for work items, GitHub for code

### Option 3: Hybrid Manual Sync
Manually keep both in sync (NOT recommended)

---

## Option 1: GitHub Projects Only ⭐ RECOMMENDED FOR DEMO

### What GitHub Projects Offers

**Features:**
- ✅ Kanban board view
- ✅ Table view (like spreadsheet)
- ✅ Roadmap/timeline view
- ✅ Custom fields
- ✅ Automation (move cards on PR merge, etc.)
- ✅ Sprint planning with Milestones
- ✅ Linked to Issues and PRs

**For AI Agent Demo:**
- ✅ **Simple**: Everything in one place (GitHub)
- ✅ **Visual**: See agent progress on board
- ✅ **Integrated**: Issues → PRs → Commits tracked together
- ✅ **TechDebtGPT**: Works naturally with GitHub Issues/PRs

### How to Set Up GitHub Projects

#### Step 1: Create Project Board

1. Go to your repository: https://github.com/ipanov-ritech/todo-ai-agents
2. Click **Projects** tab → **New Project**
3. Choose template: **Team backlog** or **Kanban**
4. Name it: "Sprint 1 - Task Priority Feature"

#### Step 2: Create Issues for Sprint Stories

Create 5 GitHub Issues (one per story):

**Issue #1: Backend - Add Priority Field**
```markdown
## Story
As a user, I want to assign priority to tasks

## Acceptance Criteria
- [ ] TaskPriority enum created (High=1, Medium=2, Low=3)
- [ ] TodoTask entity updated with Priority property
- [ ] EF Core migration created
- [ ] API accepts/returns priority
- [ ] Default priority is Medium

## Assigned To
@backend-agent-ritech

## Labels
- `feature`
- `backend`
- `Sprint-1`
```

**Issue #2: Frontend - Priority UI**
```markdown
## Story
As a user, I want to see and set priority in the UI

## Acceptance Criteria
- [ ] Priority dropdown in task form
- [ ] Priority badges with color coding
- [ ] Redux state includes priority

## Assigned To
@frontend-agent-ritech

## Labels
- `feature`
- `frontend`
- `Sprint-1`
```

(Continue for all 5 stories...)

#### Step 3: Add Issues to Project Board

1. In Project, click **Add item**
2. Search for your issues
3. Add all Sprint 1 issues

#### Step 4: Configure Board Columns

Set up workflow columns:
- **Backlog** - Not started
- **In Progress** - Agent working on it
- **In Review** - PR created
- **Done** - Merged to develop

#### Step 5: Set Up Automation

GitHub Projects can auto-move cards:
- Issue assigned → Move to "In Progress"
- PR created → Move to "In Review"
- PR merged → Move to "Done"

### Agent Workflow with GitHub Projects

```bash
# PM Agent creates issue
# Issue appears in "Backlog" column

# Backend Agent picks up issue #1
# Manually move to "In Progress" or assign self

# Backend Agent creates feature branch
git checkout -b feature/add-priority-backend

# Backend Agent implements and creates PR
gh pr create --base develop --head feature/add-priority-backend

# Card auto-moves to "In Review" when PR created

# Frontend/QA agents review PR
# Add comments, request changes

# Backend agent addresses feedback
git commit -m "fix: Address PR review feedback"
git push

# QA agent approves and merges
# Card auto-moves to "Done"
```

---

## Option 2: Azure Boards + GitHub Integration

### What This Gives You

**Azure Boards Features:**
- ✅ Rich work item types (Epic, Feature, User Story, Task, Bug)
- ✅ Hierarchical structure
- ✅ Sprint planning with capacity
- ✅ Burndown charts
- ✅ Advanced queries (WIQL)
- ✅ Dashboards and widgets

**GitHub Features:**
- ✅ Code repository
- ✅ Pull requests
- ✅ Code reviews
- ✅ Actions (CI/CD)
- ✅ TechDebtGPT integration

### How Azure Boards + GitHub Works

**Integration Flow:**
```
Azure Boards Work Item #1234
         ↓
GitHub PR mentions "AB#1234" in commit message
         ↓
Work item automatically linked to PR
         ↓
PR merged → Work item status updated
```

### Setup Steps

#### Step 1: Install Azure Boards GitHub App

1. Go to GitHub repository settings
2. Navigate to **Integrations** → **GitHub Apps**
3. Search for **Azure Boards**
4. Install and configure
5. Connect to your Azure DevOps organization

#### Step 2: Create Azure DevOps Project

1. Go to https://dev.azure.com
2. Create new project: "TodoAI-Agents"
3. Choose "Agile" process template
4. Make it public or private

#### Step 3: Create Work Items in Azure Boards

```
Epic: Task Priority Feature
  ↓
Feature: Priority Management
  ↓
User Story: Add Priority to Tasks
  ├─ Task: Create Priority enum (Backend)
  ├─ Task: Update database schema (Backend)
  ├─ Task: Add UI dropdown (Frontend)
  └─ Task: Write integration tests (QA)
```

#### Step 4: Link GitHub Commits to Work Items

In commit messages, reference Azure Boards work items:

```bash
git commit -m "feat(api): Add Priority field

- Add TaskPriority enum
- Update TodoTask entity
- Create EF migration

AB#1234"
```

The `AB#1234` automatically links the commit to Azure Boards work item #1234.

#### Step 5: Link PRs to Work Items

In PR description:
```markdown
## Summary
Implements priority field for tasks

## Related Work Items
- AB#1234: Add Priority to Tasks
- AB#1235: Update database schema

## Changes
- Created TaskPriority enum
- ...
```

### Agent Workflow with Azure Boards + GitHub

```bash
# PM Agent creates work item in Azure Boards
# Work Item #1234 appears in Sprint backlog

# Backend Agent picks up work item
# Changes status to "Active" in Azure Boards

# Backend Agent creates feature branch
git checkout -b feature/add-priority-backend

# Backend Agent implements with AB# reference
git commit -m "feat(api): Add Priority field AB#1234"

# Work item automatically shows linked commit

# Backend Agent creates PR with AB# reference
gh pr create --title "Add Priority Field AB#1234"

# Work item shows linked PR

# QA agent merges PR
# Work item auto-updates to "Closed"
```

---

## 📊 Comparison Table

| Feature | GitHub Projects | Azure Boards + GitHub |
|---------|----------------|---------------------|
| **Setup Complexity** | ⭐ Simple (5 min) | ⭐⭐⭐ Complex (30 min) |
| **Cost** | ✅ Free | ✅ Free (up to 5 users) |
| **Work Item Hierarchy** | ❌ Flat issues | ✅ Epic→Feature→Story→Task |
| **Sprint Planning** | ⭐⭐ Basic (milestones) | ⭐⭐⭐ Advanced (capacity, burndown) |
| **TechDebtGPT Integration** | ✅ Native | ⚠️ Via GitHub only |
| **Demo Simplicity** | ⭐⭐⭐ Single platform | ⭐⭐ Two platforms |
| **Visual Appeal** | ⭐⭐ Good | ⭐⭐⭐ Professional |
| **Query Language** | ⭐ Basic search | ⭐⭐⭐ WIQL |
| **Automation** | ⭐⭐ GitHub Actions | ⭐⭐⭐ Azure Pipelines |
| **Agent Bot Support** | ✅ Easy | ⚠️ Need work emails |

---

## 🎯 Recommendation

### For Your TechDebtGPT Demo: **GitHub Projects** ⭐

**Why:**

1. **Simpler Story**
   - "We track AI agents through GitHub"
   - One platform to show in demo
   - No context switching

2. **TechDebtGPT Native**
   - TechDebtGPT sees GitHub Issues directly
   - Metrics tied to Issues/PRs
   - Better integration

3. **Faster Setup**
   - 5 minutes to create project
   - Create 5 issues for Sprint 1
   - Done!

4. **Agent Bot Accounts**
   - Easy to create free GitHub accounts
   - No need for work emails
   - Simple for demo

5. **Demo Day**
   - Show board: "Here's Sprint 1"
   - Show PR: "Backend Agent's work"
   - Show TechDebtGPT: "Agent metrics"
   - All in GitHub ecosystem

### When to Use Azure Boards + GitHub

Use the hybrid approach if:
- ❓ Your company requires Azure DevOps
- ❓ You need advanced sprint planning features
- ❓ You want hierarchical work items (Epic→Story→Task)
- ❓ Compliance requires Azure DevOps

For a **demo**, this adds complexity without much benefit.

---

## 🚀 Quick Start: GitHub Projects

Let me create the Sprint 1 board for you right now:

### Step 1: Create Issues

I can help create 5 GitHub issues for Sprint 1 stories using the GitHub MCP tools.

### Step 2: Create Project Board

Then create the project board and add issues to it.

### Step 3: Configure Automation

Set up auto-move rules when PRs are created/merged.

---

## 📝 Decision

**Recommended**: Use **GitHub Projects** for your demo

**Next Steps:**
1. I'll create Sprint 1 issues in GitHub
2. Set up GitHub Project board
3. Configure automation rules
4. Update agent specs with issue references

**Want me to proceed with setting up GitHub Projects now?**
