# Project Status: AI Agent Team for TechDebtGPT Demo

**Last Updated**: 2025-10-21
**Current Branch**: `feature/add-priority-backend`
**Status**: ✅ Agent Infrastructure Complete - Ready for Development

## 🎯 Project Goal

Demonstrate AI agents working as a collaborative development team, tracked by TechDebtGPT to identify underperforming agents and enable meta-agent optimization.

## 👥 Agent Team Setup

### Active Agents (with Azure DevOps accounts)

| Role | Name | Email | Git Username | Status |
|------|------|-------|--------------|--------|
| Product Manager | Product Manager AI | techdebtdemo2025po@outlook.com | techdebtdemo2025po | ✅ Active |
| Backend Developer | Backend Developer AI | techdebtdemo2025be@outlook.com | techdebtdemo2025be | ✅ Active |
| Frontend Developer | Frontend Developer AI | techdebtdemo2025fe@gmail.com | techdebtdemo2025fe | ✅ Active |

### Pending Agents (emails TBD)

| Role | Name | Status |
|------|------|--------|
| DevOps Engineer | DevOps Engineer AI | ⏳ Email pending |
| QA Engineer | QA Engineer AI | ⏳ Email pending |

## 📋 Current Sprint: Add Task Priority Feature

**Feature**: Allow users to assign priority levels (High/Medium/Low) to tasks

### Sprint Stories

1. ✅ **Story 1**: Backend API - Add Priority field ([spec](.claude/sprint-1-feature.md#story-1))
   - Assigned to: Backend Agent
   - Status: Ready to implement

2. ⏳ **Story 2**: Frontend UI - Priority dropdown and badges ([spec](.claude/sprint-1-feature.md#story-2))
   - Assigned to: Frontend Agent
   - Status: Waiting for backend

3. ⏳ **Story 3**: Frontend - Filter/sort by priority ([spec](.claude/sprint-1-feature.md#story-3))
   - Assigned to: Frontend Agent
   - Status: Waiting for Story 2

4. ⏳ **Story 4**: Integration & E2E tests ([spec](.claude/sprint-1-feature.md#story-4))
   - Assigned to: QA Agent
   - Status: Waiting for DevOps agent email

5. ⏳ **Story 5**: CI/CD pipeline updates ([spec](.claude/sprint-1-feature.md#story-5))
   - Assigned to: DevOps Agent
   - Status: Waiting for agent email

## 🛠️ How to Work as an Agent

### Switch Agent Identity

Use the PowerShell script to switch your Git identity before making commits:

```powershell
# Switch to Product Manager
.\scripts\setup-agent-git.ps1 -Agent pm

# Switch to Backend Developer
.\scripts\setup-agent-git.ps1 -Agent backend

# Switch to Frontend Developer
.\scripts\setup-agent-git.ps1 -Agent frontend

# Reset to your personal identity
.\scripts\setup-agent-git.ps1 -Agent reset
```

### Agent Workflow

1. **Check your assignment** in `.claude/sprint-1-feature.md`
2. **Switch to agent identity** using the script above
3. **Read your agent spec** in `.claude/agents/[role]-agent.md`
4. **Implement your story** following acceptance criteria
5. **Commit with agent identity** (script automatically configures Git)
6. **Create PR** and assign to appropriate reviewers

### Commit Message Format

Each agent should use conventional commits with their role prefix:

```bash
# Product Manager
git commit -m "feat: Add priority field to Sprint 1 backlog"

# Backend Developer
git commit -m "feat(api): Add Priority field to Task entity"

# Frontend Developer
git commit -m "feat(ui): Add priority badge component"
```

## 🔄 TechDebtGPT Integration

### How It Works

1. **Agents make commits** using their Azure DevOps emails
2. **TechDebtGPT analyzes** each agent's commits for quality metrics
3. **Meta-agent monitors** agent performance through TechDebtGPT API
4. **Lowest performer identified** automatically
5. **Improvement suggestions** generated for underperforming agents

### Agent Discovery

TechDebtGPT can identify agents by email pattern:
- `*-agent-bot@todo-ai-agents.demo` (demo emails)
- `techdebtdemo2025*@*.com` (real Azure DevOps accounts)

### Metrics Tracked

- **Code Quality**: Bug count, code complexity
- **Velocity**: Commits per sprint, story points delivered
- **Collaboration**: PR review participation, merge conflicts
- **Test Coverage**: Test creation rate, pass/fail ratio

## 📁 Project Structure

```
todo-ai-agents/
├── .claude/
│   ├── agents/               # Agent specifications
│   │   ├── pm-agent.md      # Product Manager
│   │   ├── backend-agent.md # Backend Developer
│   │   ├── frontend-agent.md# Frontend Developer
│   │   ├── devops-agent.md  # DevOps Engineer
│   │   └── qa-agent.md      # QA Engineer
│   ├── sprint-1-feature.md  # Current sprint backlog
│   └── PROJECT-STATUS.md    # This file
├── scripts/
│   ├── setup-agent-git.ps1  # Switch agent identities
│   └── invite-agents-to-azdo.ps1 # Azure DevOps setup
├── ReactReduxTodo/          # ASP.NET Core backend
├── ClientApp/               # React frontend
└── README.md                # Project overview
```

## 🎬 Next Steps

### Immediate (Next 1-2 hours)

1. **Add DevOps and QA agent emails** to Azure DevOps
2. **Update agent specs** with remaining emails
3. **Start Story 1** (Backend Developer): Implement Priority field
4. **Create branch**: `feature/add-priority-backend`

### Short-term (This Sprint)

1. Backend Developer implements Story 1
2. Frontend Developer implements Stories 2-3
3. QA Agent writes integration/E2E tests (Story 4)
4. DevOps Agent updates CI/CD pipeline (Story 5)
5. All agents create PRs for review

### Medium-term (Next Sprint)

1. Install TechDebtGPT on this repository
2. Generate first agent health report
3. Identify lowest-performing agent
4. Implement meta-agent improvement suggestions

## 🔗 Related Documentation

- [Sprint 1 Feature Spec](.claude/sprint-1-feature.md) - Detailed acceptance criteria
- [Azure DevOps Setup](.claude/AZURE-DEVOPS-SETUP.md) - Team configuration
- [TechDebtGPT Integration](.claude/TECHDEBTGPT-INTEGRATION.md) - Monitoring setup
- [Agent Specifications](.claude/agents/README.md) - Role descriptions

## 📊 Success Metrics

This demo will be successful when we can show:

1. ✅ **5 AI agents** with distinct Git identities making commits
2. ⏳ **Complete feature** (Task Priority) delivered collaboratively
3. ⏳ **TechDebtGPT dashboard** showing individual agent metrics
4. ⏳ **Meta-agent analysis** identifying lowest performer
5. ⏳ **Improvement suggestion** generated and applied

---

**Demo Day Target**: Show TechDebtGPT identifying which AI agent needs prompt/configuration improvement based on code quality metrics.
