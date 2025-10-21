# How to Test Parallel AI Agents

This guide explains how to test the parallel AI agent workflow system.

## Overview

You now have:
1. **PM Agent** - Coordinates sprint planning and task assignment
2. **Backend Agent** - Implements backend features
3. **Frontend Agent** - Implements frontend features  
4. **Parallel workflow** - Agents work simultaneously on different tasks

## Quick Test

### Step 1: Switch to PM Agent

```powershell
.\scripts\setup-agent-git.ps1 -Agent pm
```

### Step 2: Read the Feature Request

The test feature is already defined in `.claude/TEST-FEATURE-REQUEST.md`

**Feature**: Task Categories
- Users can organize tasks into categories (Work, Personal, Shopping, etc.)
- Requires backend API, frontend UI, and testing

### Step 3: Have PM Agent Break Down the Feature

In Claude Code, ask the PM Agent:

```
I'm the PM Agent. Please read .claude/TEST-FEATURE-REQUEST.md and break down 
this feature into parallelizable tasks. Create work items in Azure DevOps 
assigned to the appropriate agents (Backend, Frontend, QA).
```

The PM Agent will:
1. Analyze the feature requirements
2. Define the API contract for categories
3. Break down into 5 tasks:
   - Task 1: Backend - Category Entity (Parallel)
   - Task 2: Backend - Category API (Sequential, after Task 1)
   - Task 3: Frontend - Category Manager UI (Parallel)
   - Task 4: Frontend - Task Filtering (Sequential, after Task 3)
   - Task 5: QA - Integration Tests (Sequential, after all)
4. Create work items in Azure DevOps
5. Assign each to the appropriate agent email

### Step 4: Backend Agent Implements (Parallel Stream 1)

```powershell
.\scripts\setup-agent-git.ps1 -Agent backend
```

In Claude Code, as Backend Agent:

```
I'm the Backend Agent. Check my assigned work items in Azure DevOps 
(techdebtdemo2025be@outlook.com). Implement the Category entity and API 
endpoints. Create a PR when done.
```

The Backend Agent will:
1. Create `Category` entity
2. Create database migration
3. Create `CategoriesController` with REST endpoints
4. Write unit tests
5. Commit with message: `feat(api): Add task categories AB#X`
6. Create PR assigned to QA Agent

### Step 5: Frontend Agent Implements (Parallel Stream 2)

**At the same time**, switch to Frontend Agent:

```powershell
.\scripts\setup-agent-git.ps1 -Agent frontend
```

In Claude Code, as Frontend Agent:

```
I'm the Frontend Agent. Check my assigned work items in Azure DevOps 
(techdebtdemo2025fe@gmail.com). Implement the Category management UI 
and task filtering. Create a PR when done.
```

The Frontend Agent will:
1. Create `CategoryManager` component
2. Create Redux actions/reducers for categories
3. Add category selector to task form
4. Add category filter dropdown
5. Commit with message: `feat(ui): Add category management AB#Y`
6. Create PR assigned to QA Agent

### Step 6: QA Agent Tests (Sequential)

After both Backend and Frontend PRs are created:

```powershell
.\scripts\setup-agent-git.ps1 -Agent qa
```

In Claude Code, as QA Agent:

```
I'm the QA Agent. Review the PRs from Backend and Frontend agents. 
Run tests, verify functionality, and approve/merge if passing.
```

The QA Agent will:
1. Review backend PR
2. Review frontend PR
3. Run integration tests
4. Run E2E tests
5. Approve and merge both PRs
6. Update work items to Done

## Expected Outcome

After testing, you should see:

**In Azure DevOps:**
- 5 work items created by PM Agent
- Work items assigned to correct agent emails
- Work items linked with dependencies
- All work items transitioned to "Done"
- Commits linked to work items via `AB#` tags

**In GitHub:**
- 2 PRs created (backend + frontend)
- PRs assigned to QA Agent for review
- PRs merged to develop branch
- Commits attributed to correct agent emails

**In TechDebtGPT:**
- Metrics showing parallel execution
- Commit attribution to each agent
- Work item cycle time per agent
- Agent health scores calculated

## Demonstration Script

Run the visual demonstration:

```powershell
.\scripts\run-parallel-agents.ps1 -FeatureFile ".claude/TEST-FEATURE-REQUEST.md"
```

This script simulates the entire workflow with colored output showing:
- PM Agent planning phase
- Backend & Frontend agents working in parallel
- QA Agent testing and merging
- Final summary with metrics

## Key Metrics to Observe

| Metric | Expected Value |
|--------|----------------|
| Total tasks | 5 |
| Parallel tasks | 4 (80%) |
| Sequential tasks | 1 (20%) |
| Time saved | ~40% vs sequential |
| Agents involved | 3 (PM, Backend, Frontend) |

## Next Steps After Testing

1. ✅ Verify all agents can create work items
2. ✅ Confirm parallel execution works
3. ✅ Check TechDebtGPT tracking
4. ⏳ Implement actual feature (optional)
5. ⏳ Run agent health analysis
6. ⏳ Test meta-agent optimization

## Troubleshooting

**Issue**: Azure DevOps MCP fails to create work items
**Solution**: Check MCP configuration in `.claude/AZURE-DEVOPS-MCP-CONFIG.md`

**Issue**: Work items not linking to commits
**Solution**: Use format `AB#{number}` in commit messages

**Issue**: Agents not switching correctly
**Solution**: Run `git config user.email` to verify current agent

**Issue**: PR creation fails
**Solution**: Ensure branch is pushed first: `git push origin {branch}`

## Success Criteria

✓ PM Agent successfully breaks down feature
✓ Work items created in Azure DevOps
✓ Backend and Frontend agents work in parallel
✓ QA Agent reviews and merges
✓ All commits attributed correctly
✓ TechDebtGPT shows metrics for each agent

---

**You're ready to test!** Start with the PM Agent and follow the steps above.
