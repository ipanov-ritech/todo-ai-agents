# ============================================================================
# Parallel AI Agent Workflow Orchestrator
# ============================================================================
# This script demonstrates how multiple AI agents work in parallel on a feature
# coordinated by the PM Agent through Azure DevOps work items.
#
# Usage:
#   .\scripts\run-parallel-agents.ps1 -FeatureFile ".claude/TEST-FEATURE-REQUEST.md"
# ============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$FeatureFile,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

# ============================================================================
# Configuration
# ============================================================================

$AzureDevOpsOrg = "ipanov-ritech"
$AzureDevOpsProject = "techdebtgpt-agent-health-mvp"
$GitHubRepo = "ipanov-ritech/todo-ai-agents"

$Agents = @{
    PM = @{
        Name = "PM Agent"
        Email = "techdebtdemo2025po@outlook.com"
        Username = "techdebtdemo2025po"
        Role = "ProductManager"
    }
    Backend = @{
        Name = "Backend Agent"
        Email = "techdebtdemo2025be@outlook.com"
        Username = "techdebtdemo2025be"
        Role = "BackendDeveloper"
    }
    Frontend = @{
        Name = "Frontend Agent"
        Email = "techdebtdemo2025fe@gmail.com"
        Username = "techdebtdemo2025fe"
        Role = "FrontendDeveloper"
    }
}

# ============================================================================
# Helper Functions
# ============================================================================

function Write-Step {
    param([string]$Message, [string]$Color = "Cyan")
    Write-Host "`n===========================================================" -ForegroundColor $Color
    Write-Host $Message -ForegroundColor $Color
    Write-Host "===========================================================" -ForegroundColor $Color
}

function Write-AgentAction {
    param([string]$Agent, [string]$Action, [string]$Color = "Yellow")
    Write-Host "`n[$Agent] $Action" -ForegroundColor $Color
}

function Wait-ForUserConfirmation {
    param([string]$Message = "Press Enter to continue...")
    Write-Host "`n$Message" -ForegroundColor Gray
    if (-not $DryRun) {
        Read-Host
    }
}

# ============================================================================
# Main Workflow
# ============================================================================

Write-Host @"

╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║          Parallel AI Agent Workflow Demonstration               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Check if feature file exists
if (-not (Test-Path $FeatureFile)) {
    Write-Host "✗ Feature file not found: $FeatureFile" -ForegroundColor Red
    exit 1
}

Write-Host "Feature Request: " -NoNewline
Write-Host (Split-Path $FeatureFile -Leaf) -ForegroundColor Green
Write-Host "Azure DevOps: " -NoNewline
Write-Host "https://dev.azure.com/$AzureDevOpsOrg/$AzureDevOpsProject" -ForegroundColor Green
Write-Host "GitHub Repo: " -NoNewline
Write-Host "https://github.com/$GitHubRepo" -ForegroundColor Green

if ($DryRun) {
    Write-Host "`n⚠ DRY RUN MODE - No actual work items will be created" -ForegroundColor Yellow
}

# ============================================================================
# Phase 1: PM Agent - Sprint Planning
# ============================================================================

Write-Step "PHASE 1: PM Agent - Feature Breakdown & Sprint Planning" "Magenta"

Write-AgentAction "PM Agent" "Reading feature request..." "Cyan"
Write-Host "  File: $FeatureFile"

Write-AgentAction "PM Agent" "Analyzing requirements..." "Cyan"
Write-Host "  Identifying work streams..."
Write-Host "  - Backend API & Database"
Write-Host "  - Frontend UI Components"
Write-Host "  - Integration Testing"
Write-Host "  - CI/CD Updates"

Write-AgentAction "PM Agent" "Creating API contract..." "Cyan"
Write-Host "  Defining Category API endpoints"
Write-Host "  Documenting request/response schemas"

Write-AgentAction "PM Agent" "Breaking down into tasks..." "Cyan"
Write-Host ""
Write-Host "  Task Breakdown:" -ForegroundColor White
Write-Host "  ┌─────────────────────────────────────────────────────────┐"
Write-Host "  │ 1. Backend: Category Entity & Repository (PARALLEL)    │" -ForegroundColor Green
Write-Host "  │    Assigned to: Backend Agent                           │"
Write-Host "  │    Can start: Immediately                               │"
Write-Host "  │                                                         │"
Write-Host "  │ 2. Backend: Category API Endpoints (PARALLEL)          │" -ForegroundColor Green
Write-Host "  │    Assigned to: Backend Agent                           │"
Write-Host "  │    Can start: After Task 1                              │"
Write-Host "  │                                                         │"
Write-Host "  │ 3. Frontend: Category Manager UI (PARALLEL)            │" -ForegroundColor Green
Write-Host "  │    Assigned to: Frontend Agent                          │"
Write-Host "  │    Can start: Immediately (uses API contract)           │"
Write-Host "  │                                                         │"
Write-Host "  │ 4. Frontend: Task Filter UI (PARALLEL)                 │" -ForegroundColor Green
Write-Host "  │    Assigned to: Frontend Agent                          │"
Write-Host "  │    Can start: After Task 3                              │"
Write-Host "  │                                                         │"
Write-Host "  │ 5. QA: Integration Tests (SEQUENTIAL)                  │" -ForegroundColor Yellow
Write-Host "  │    Assigned to: QA Agent                                │"
Write-Host "  │    Can start: After Tasks 1-4 complete                  │"
Write-Host "  └─────────────────────────────────────────────────────────┘"

Write-AgentAction "PM Agent" "Creating work items in Azure DevOps..." "Cyan"
Write-Host "  Creating Issue #1: Backend - Category Entity"
Write-Host "  Creating Issue #2: Backend - Category API"
Write-Host "  Creating Issue #3: Frontend - Category Manager"
Write-Host "  Creating Issue #4: Frontend - Task Filtering"
Write-Host "  Creating Issue #5: QA - Integration Tests"

Write-Host "`n✓ PM Agent completed sprint planning" -ForegroundColor Green
Write-Host "  Total work items: 5"
Write-Host "  Parallel tasks: 2 (Backend + Frontend can start simultaneously)"
Write-Host "  Critical path: Backend → Frontend → QA"

Wait-ForUserConfirmation "Press Enter to start parallel agent execution..."

# ============================================================================
# Phase 2: Parallel Execution - Backend & Frontend
# ============================================================================

Write-Step "PHASE 2: Parallel Execution - Backend & Frontend Agents" "Magenta"

Write-Host "`nStarting parallel work streams..." -ForegroundColor White

# Backend Agent (Stream 1)
Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Blue
Write-Host "│  STREAM 1: BACKEND AGENT           │" -ForegroundColor Blue
Write-Host "└─────────────────────────────────────┘" -ForegroundColor Blue

Write-AgentAction "Backend Agent" "Checking out branch: feature/task-categories-backend" "Blue"
Write-AgentAction "Backend Agent" "Creating Category entity..." "Blue"
Write-Host "  File: ReactReduxTodo/Entities/Category.cs"
Write-AgentAction "Backend Agent" "Creating database migration..." "Blue"
Write-Host "  Command: dotnet ef migrations add AddCategories"
Write-AgentAction "Backend Agent" "Creating CategoryRepository..." "Blue"
Write-Host "  File: ReactReduxTodo/Repositories/CategoryRepository.cs"
Write-AgentAction "Backend Agent" "Committing: 'feat(api): Add Category entity and repository AB#1'" "Blue"

# Frontend Agent (Stream 2) - Running in parallel!
Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│  STREAM 2: FRONTEND AGENT          │" -ForegroundColor Cyan
Write-Host "└─────────────────────────────────────┘" -ForegroundColor Cyan

Write-AgentAction "Frontend Agent" "Checking out branch: feature/task-categories-frontend" "Cyan"
Write-AgentAction "Frontend Agent" "Creating CategoryManager component..." "Cyan"
Write-Host "  File: ClientApp/src/components/CategoryManager.jsx"
Write-AgentAction "Frontend Agent" "Creating Redux actions for categories..." "Cyan"
Write-Host "  File: ClientApp/src/features/categories/actions.js"
Write-AgentAction "Frontend Agent" "Adding category color picker..." "Cyan"
Write-Host "  Component: ColorPicker.jsx"
Write-AgentAction "Frontend Agent" "Committing: 'feat(ui): Add category management UI AB#3'" "Cyan"

Write-Host "`n✓ Backend and Frontend agents working in parallel!" -ForegroundColor Green

Wait-ForUserConfirmation "Press Enter to continue to API integration..."

# ============================================================================
# Phase 3: Backend API + Frontend Integration
# ============================================================================

Write-Step "PHASE 3: API Integration - Backend API & Frontend UI Update" "Magenta"

Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Blue
Write-Host "│  BACKEND AGENT (Continuing)        │" -ForegroundColor Blue
Write-Host "└─────────────────────────────────────┘" -ForegroundColor Blue

Write-AgentAction "Backend Agent" "Creating CategoriesController..." "Blue"
Write-Host "  Endpoints: GET, POST, PUT, DELETE /api/categories"
Write-AgentAction "Backend Agent" "Adding category filter to TasksController..." "Blue"
Write-Host "  Endpoint: GET /api/tasks?categoryId={id}"
Write-AgentAction "Backend Agent" "Committing: 'feat(api): Add Category REST endpoints AB#2'" "Blue"
Write-AgentAction "Backend Agent" "Creating PR #1 → develop" "Blue"
Write-Host "  PR Title: 'feat: Add task categories (Backend)'"
Write-Host "  Reviewers: Frontend Agent, QA Agent"

Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│  FRONTEND AGENT (Continuing)       │" -ForegroundColor Cyan
Write-Host "└─────────────────────────────────────┘" -ForegroundColor Cyan

Write-AgentAction "Frontend Agent" "Integrating with category API..." "Cyan"
Write-Host "  Service: ClientApp/src/services/categoryService.js"
Write-AgentAction "Frontend Agent" "Adding category filter dropdown..." "Cyan"
Write-Host "  Component: TaskList with CategoryFilter"
Write-AgentAction "Frontend Agent" "Updating task form with category selector..." "Cyan"
Write-Host "  Component: TaskForm with CategoryDropdown"
Write-AgentAction "Frontend Agent" "Committing: 'feat(ui): Add category filtering UI AB#4'" "Cyan"
Write-AgentAction "Frontend Agent" "Creating PR #2 → develop" "Cyan"
Write-Host "  PR Title: 'feat: Add task categories (Frontend)'"
Write-Host "  Reviewers: Backend Agent, QA Agent"

Write-Host "`n✓ Backend and Frontend PRs created!" -ForegroundColor Green

Wait-ForUserConfirmation "Press Enter to start QA testing..."

# ============================================================================
# Phase 4: QA Agent - Testing
# ============================================================================

Write-Step "PHASE 4: QA Agent - Integration & E2E Testing" "Magenta"

Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Green
Write-Host "│  QA AGENT                           │" -ForegroundColor Green
Write-Host "└─────────────────────────────────────┘" -ForegroundColor Green

Write-AgentAction "QA Agent" "Reviewing Backend PR #1..." "Green"
Write-Host "  ✓ Code review: LGTM"
Write-Host "  ✓ Unit tests pass"
Write-Host "  ✓ Migration verified"

Write-AgentAction "QA Agent" "Reviewing Frontend PR #2..." "Green"
Write-Host "  ✓ Code review: LGTM"
Write-Host "  ✓ Component tests pass"
Write-Host "  ✓ UI/UX verified"

Write-AgentAction "QA Agent" "Creating integration tests..." "Green"
Write-Host "  File: ReactReduxTodo.Tests/CategoryControllerTests.cs"
Write-Host "  Tests: Create, Read, Update, Delete categories"
Write-Host "  Tests: Filter tasks by category"

Write-AgentAction "QA Agent" "Creating E2E tests..." "Green"
Write-Host "  File: ClientApp/tests/e2e/categories.spec.js"
Write-Host "  Tests: User can create category"
Write-Host "  Tests: User can assign task to category"
Write-Host "  Tests: User can filter tasks by category"

Write-AgentAction "QA Agent" "Running full test suite..." "Green"
Write-Host "  Backend integration tests: " -NoNewline
Write-Host "✓ PASS (15/15)" -ForegroundColor Green
Write-Host "  Frontend component tests: " -NoNewline
Write-Host "✓ PASS (8/8)" -ForegroundColor Green
Write-Host "  E2E tests: " -NoNewline
Write-Host "✓ PASS (5/5)" -ForegroundColor Green

Write-AgentAction "QA Agent" "Approving PRs..." "Green"
Write-Host "  PR #1 (Backend): APPROVED ✓"
Write-Host "  PR #2 (Frontend): APPROVED ✓"

Write-AgentAction "QA Agent" "Merging to develop..." "Green"
Write-Host "  Squash merge PR #1"
Write-Host "  Squash merge PR #2"

Write-Host "`n✓ All tests passed! Feature complete." -ForegroundColor Green

Wait-ForUserConfirmation "Press Enter to see final summary..."

# ============================================================================
# Summary
# ============================================================================

Write-Step "WORKFLOW COMPLETE - Summary" "Green"

Write-Host @"

Feature: Task Categories
Status: ✓ COMPLETE

Work Item Summary:
┌────────┬─────────────────────────────────────┬──────────────┬──────────┐
│ ID     │ Task                                │ Agent        │ Status   │
├────────┼─────────────────────────────────────┼──────────────┼──────────┤
│ AB#1   │ Backend - Category Entity           │ Backend      │ ✓ Done   │
│ AB#2   │ Backend - Category API              │ Backend      │ ✓ Done   │
│ AB#3   │ Frontend - Category Manager UI      │ Frontend     │ ✓ Done   │
│ AB#4   │ Frontend - Task Filtering           │ Frontend     │ ✓ Done   │
│ AB#5   │ QA - Integration Tests              │ QA           │ ✓ Done   │
└────────┴─────────────────────────────────────┴──────────────┴──────────┘

Parallel Execution Achieved:
- Backend Agent & Frontend Agent worked simultaneously
- Zero idle time for frontend (API contract defined upfront)
- QA started test planning during development

Performance Metrics:
- Total tasks: 5
- Parallel tasks: 4 (80% parallelization)
- Sequential tasks: 1 (20%)
- Estimated time saved: ~40% (vs sequential execution)

Pull Requests:
- PR #1 (Backend): Merged to develop
- PR #2 (Frontend): Merged to develop

Next Steps:
1. Deploy to staging environment
2. Run smoke tests
3. Update documentation
4. TechDebtGPT tracks agent metrics

"@ -ForegroundColor White

Write-Host "✓ Parallel agent workflow demonstration complete!`n" -ForegroundColor Green

# ============================================================================
# TechDebtGPT Integration Note
# ============================================================================

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "TechDebtGPT Integration" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "TechDebtGPT is now tracking:" -ForegroundColor White
Write-Host "  ✓ Commits by each agent (attribution)" -ForegroundColor Green
Write-Host "  ✓ Work items completed per agent" -ForegroundColor Green
Write-Host "  ✓ Cycle time for each task" -ForegroundColor Green
Write-Host "  ✓ Code quality metrics (tests, reviews)" -ForegroundColor Green
Write-Host ""
Write-Host "Agent Health Scores will be calculated based on:" -ForegroundColor White
Write-Host "  - Velocity (commits/sprint, work items/sprint)" -ForegroundColor Gray
Write-Host "  - Quality (test coverage, PR comments)" -ForegroundColor Gray
Write-Host "  - Collaboration (reviews given, merge conflicts)" -ForegroundColor Gray
Write-Host "  - Efficiency (cycle time, PR size)" -ForegroundColor Gray
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
