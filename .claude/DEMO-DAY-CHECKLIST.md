# Demo Day Checklist - AI Agents with TechDebtGPT

Quick reference checklist for your demo tomorrow. Complete these steps in order.

---

## 🕐 Night Before Demo (Tonight)

### [ ] Step 1: Create Outlook.com Email Aliases (5 min)
1. Go to https://outlook.live.com
2. Settings → Account info → Email addresses
3. Add these 5 aliases:
   - `pm-agent-bot@outlook.com`
   - `backend-agent-bot@outlook.com`
   - `frontend-agent-bot@outlook.com`
   - `devops-agent-bot@outlook.com`
   - `qa-agent-bot@outlook.com`

**If names are taken, use:**
- Pattern: `[role]-agent-demo@outlook.com`
- OR: `[role]-agent-[yourname]@outlook.com`

📝 **Write down your actual aliases here:**
```
PM:       ________________________________
Backend:  ________________________________
Frontend: ________________________________
DevOps:   ________________________________
QA:       ________________________________
```

### [ ] Step 2: Set Up Azure DevOps (15 min)
1. Go to https://dev.azure.com
2. Create organization: `todo-ai-agents-demo` (or your name)
3. Create project: `Todo AI Agents`
4. Invite the 5 agent emails:
   - Organization Settings → Users → Add users
   - Use "Basic" license or "Stakeholder" (free)
   - Add to project "Todo AI Agents"

### [ ] Step 3: Accept Azure DevOps Invitations (5 min)
1. Check your Outlook inbox
2. Accept all 5 invitations
3. Tip: Use incognito windows to stay signed in to multiple aliases

### [ ] Step 4: Create 3 Sample Work Items (10 min)

**Story 1:**
```
Title: Add Priority Field to Tasks
Assigned To: backend-agent-bot@outlook.com
Tags: backend, api, database

Description:
Add priority field (High/Medium/Low) to task entity

Acceptance Criteria:
- Task entity has Priority enum field
- API accepts priority in POST/PUT
- Default priority is Medium
- Database migration created
```

**Story 2:**
```
Title: Add Priority UI to Task Form
Assigned To: frontend-agent-bot@outlook.com
Tags: frontend, ui, react
Depends on: Story 1

Description:
Add priority dropdown and badges to UI

Acceptance Criteria:
- Task form has priority dropdown
- Task list shows priority badges
- Priority is color-coded (High=red, Medium=yellow, Low=green)
```

**Story 3:**
```
Title: Test Priority Feature
Assigned To: qa-agent-bot@outlook.com
Tags: qa, testing
Depends on: Story 1, Story 2

Description:
End-to-end testing of priority feature

Acceptance Criteria:
- Integration tests for API
- E2E tests for UI
- All tests passing
```

### [ ] Step 5: Connect GitHub to Azure Boards (5 min)
1. Project Settings → GitHub connections
2. Connect your GitHub account
3. Select repository: `todo-ai-agents`
4. Enable "Commit mention linking"

### [ ] Step 6: Create Azure DevOps PAT Token (3 min)
1. User Settings → Personal access tokens
2. New Token:
   - Name: `TechDebtGPT Integration`
   - Scopes: Work Items (Read), Code (Read), Project (Read)
   - 90 days
3. **SAVE THE TOKEN** - you need it for TechDebtGPT

📝 **Save your PAT here (temporarily):**
```
PAT Token: ________________________________
```

### [ ] Step 7: Update PowerShell Script with Your Emails
1. Open: `C:\Repos\todo-ai-agents\scripts\invite-agents-to-azdo.ps1`
2. Update line 30-54 with your actual email aliases
3. Save the file

---

## ☀️ Demo Day Morning (Before Demo)

### [ ] Step 8: Verify Git Agent Identities (2 min)
```powershell
cd C:\Repos\todo-ai-agents

# Test switching agents
.\scripts\switch-agent.ps1 backend
git config user.email  # Should show: backend-agent-bot@todo-ai-agents.demo

.\scripts\switch-agent.ps1 frontend
git config user.email  # Should show: frontend-agent-bot@todo-ai-agents.demo
```

### [ ] Step 9: Prepare Azure DevOps Board View (2 min)
1. Open: `https://dev.azure.com/{your-org}/Todo AI Agents/_boards`
2. Ensure all 3 stories are visible
3. Set view to "Board" view
4. Arrange columns: To Do | In Progress | Done

### [ ] Step 10: Configure TechDebtGPT (5 min)
1. Open TechDebtGPT dashboard
2. Settings → Integrations → Azure DevOps
3. Add connection:
   - Org URL: `https://dev.azure.com/your-org`
   - Project: `Todo AI Agents`
   - PAT: [paste from Step 6]
4. Settings → Integrations → GitHub
5. Add connection:
   - Owner: `your-github-username`
   - Repo: `todo-ai-agents`
   - PAT: [create GitHub PAT with repo scope]
6. Configure agent mapping (see TECHDEBTGPT-INTEGRATION.md)

### [ ] Step 11: Test Full Workflow (10 min)

**Quick test:**
```powershell
# 1. Backend agent implements a small change
.\scripts\switch-agent.ps1 backend
git checkout -b test/priority-field

# 2. Make a small change to any file
echo "// Test change" >> ReactReduxTodo/Program.cs

# 3. Commit with work item link
git add .
git commit -m "feat(api): Test priority field AB#1"

# 4. Push and create PR
git push origin test/priority-field
gh pr create --title "Test: Priority field" --body "Testing AB#1"

# 5. Check Azure DevOps - commit should appear linked to work item #1
```

---

## 🎬 During Demo (Live Demonstration)

### [ ] Demo Script Part 1: Show the Setup (2 min)
1. **Show Azure DevOps Board**
   - "Here we have 3 user stories assigned to different AI agents"
   - Point out agent names in "Assigned To" column

2. **Show GitHub Repository**
   - "Each agent has a unique git identity"
   - Show `.claude/agents/` folder with agent definitions

3. **Show TechDebtGPT Dashboard**
   - "TechDebtGPT tracks all agent activity across both platforms"

### [ ] Demo Script Part 2: Backend Agent Works (5 min)

**Narration:** "Let's watch the Backend Agent implement Story 1..."

```powershell
# Switch to backend agent identity
.\scripts\switch-agent.ps1 backend

# Create feature branch
git checkout develop
git pull
git checkout -b feature/add-priority-backend

# Show the agent's work (already done - you did this earlier)
# Or do live if comfortable

# Show the commit
git log -1 --format="%an <%ae>%n%s"

# Create PR
gh pr create --base develop --title "feat: Add Priority field to Task entity" --body "Implements Story 1: Add Priority to Tasks

## Changes
- Added TaskPriority enum
- Updated TodoTask entity with Priority property
- Created EF Core migration

## Related Work Items
AB#1"

# Show Azure DevOps - work item should now show linked commit
```

### [ ] Demo Script Part 3: Frontend Agent Works (5 min)

**Narration:** "Now the Frontend Agent adds the UI..."

```powershell
# Switch to frontend agent
.\scripts\switch-agent.ps1 frontend

# Show work in ClientApp (pre-done or live)
git checkout -b feature/add-priority-ui

# Commit and PR
git add .
git commit -m "feat(ui): Add priority dropdown to task form AB#2"
gh pr create --base develop --title "feat: Add Priority UI" --body "AB#2"
```

### [ ] Demo Script Part 4: QA Agent Reviews (3 min)

**Narration:** "The QA Agent ensures quality..."

```powershell
# Switch to QA agent
.\scripts\switch-agent.ps1 qa

# Review and approve PRs
gh pr list
gh pr review {pr-number} --approve --body "✅ Tests pass. Code looks good. Merging."
gh pr merge {pr-number} --squash

# Show work item transitions to Done
```

### [ ] Demo Script Part 5: TechDebtGPT Analysis (5 min)

**Narration:** "Now let's see what TechDebtGPT learned..."

1. **Show Commit Attribution:**
   - Each commit tracked to specific agent
   - Commit frequency by agent
   - Lines changed per agent

2. **Show Work Item Metrics:**
   - Cycle time per agent
   - Work items completed
   - Average time to merge PR

3. **Show Agent Health Scores:**
   - Backend Agent: 85/100
   - Frontend Agent: 82/100
   - QA Agent: 90/100
   - Identify any bottlenecks or issues

### [ ] Demo Script Part 6: Agent Health MVP (5 min)

**Narration:** "Finally, our Agent Health MVP analyzes underperformers..."

1. **Show Agent Performance Dashboard**
   - Compare agents side-by-side
   - Highlight lowest performing agent

2. **Show Optimization Recommendations**
   - "Backend Agent is taking too long per task"
   - Recommendation: Break down work items
   - Recommendation: Increase commit frequency

3. **Show Optimization Loop**
   - Meta-agent analyzes recommendations
   - Generates updated agent prompt
   - Show before/after performance improvement

---

## 🎯 Key Demo Talking Points

**Problem Statement:**
"AI coding agents are powerful, but how do we know which ones are performing well? How do we optimize underperforming agents?"

**Solution:**
"We created an agentic workflow where each AI agent has a unique identity tracked across GitHub and Azure DevOps. TechDebtGPT monitors their performance, and our Agent Health MVP optimizes them."

**Key Innovation:**
"The meta-agent can analyze underperforming agents and automatically generate optimized prompts, creating a self-improving system."

**Business Value:**
"Teams can identify which AI agents work best for their projects and continuously improve agent performance based on real metrics."

---

## 🚨 Troubleshooting - Quick Fixes

### Issue: Agent email doesn't work in Azure DevOps
**Quick Fix:** Use your main email but set Display Name to "Backend Agent Bot"

### Issue: Commit not showing in Azure DevOps
**Quick Fix:** Add `AB#1` to commit message and push again

### Issue: TechDebtGPT not connecting
**Quick Fix:** Verify PAT token, check expiration, regenerate if needed

### Issue: Git identity not switching
**Quick Fix:** Run: `git config user.email "backend-agent-bot@todo-ai-agents.demo"`

### Issue: PR creation fails
**Quick Fix:** Push branch first, then use GitHub UI to create PR manually

---

## 📊 Success Metrics to Highlight

- ✅ 5 AI agents with unique identities
- ✅ 100% commit attribution accuracy
- ✅ Real-time work item tracking
- ✅ Automated agent health scoring
- ✅ Meta-agent optimization loop

---

## 📝 Post-Demo Follow-Up

1. Export metrics from TechDebtGPT
2. Document lessons learned
3. Prepare production rollout plan
4. Share recording with stakeholders
5. Schedule follow-up for Agent Health MVP v2

---

## ⏱️ Time Breakdown

| Activity | Time |
|----------|------|
| Setup (tonight) | 45 min |
| Morning prep | 20 min |
| Live demo | 25 min |
| Q&A buffer | 10 min |
| **Total** | **100 min** |

---

**Good luck with your demo! 🚀**

You've got this! The setup is straightforward, and if anything goes wrong, you have backup plans.

**Remember:**
- Don't panic if something breaks - talk through what should happen
- Focus on the story: tracking AI agents and optimizing them
- The innovation is the meta-agent optimization loop

**Final check before you start:**
- [ ] All 5 emails working in Azure DevOps
- [ ] 3 work items created and assigned
- [ ] Git agents switching correctly
- [ ] TechDebtGPT connected
- [ ] Sample PRs ready to demo
