# Sprint 2: Task Categories Feature

**PM Agent**: Product Manager AI (techdebtdemo2025po@outlook.com)
**Created**: 2025-10-21
**Feature**: Task Categories - Allow users to organize tasks into custom categories

---

## API Contract (Enables Parallel Development)

### Category Model
```json
{
  "id": 1,
  "name": "Work",
  "color": "#3498db",
  "createdDate": "2025-01-20T10:00:00Z"
}
```

### Endpoints

#### GET /api/categories
**Response**: `Category[]`
```json
[
  { "id": 1, "name": "Work", "color": "#3498db", "createdDate": "..." },
  { "id": 2, "name": "Personal", "color": "#2ecc71", "createdDate": "..." }
]
```

#### GET /api/categories/{id}
**Response**: `Category`

#### POST /api/categories
**Request**:
```json
{
  "name": "Work",
  "color": "#3498db"
}
```
**Response**: `Category` (with generated id and createdDate)

#### PUT /api/categories/{id}
**Request**:
```json
{
  "name": "Updated Name",
  "color": "#e74c3c"
}
```
**Response**: `Category`

#### DELETE /api/categories/{id}
**Response**: `204 No Content`

#### GET /api/tasks?categoryId={id}
**Response**: `Task[]` (filtered by category)

---

## Work Item Breakdown

### Work Item #1: Backend - Category Entity & Repository ⚡ PARALLEL

**Title**: Backend: Create Category Entity and Repository

**Assigned To**: Backend Agent (techdebtdemo2025be@outlook.com)

**Description**:
Create the Category entity and repository to enable category storage and retrieval.

**Acceptance Criteria**:
- [ ] Category entity created (Id, Name, Color, CreatedDate)
- [ ] CategoryRepository with CRUD methods
- [ ] Database migration: `dotnet ef migrations add AddCategories`
- [ ] TodoTask entity updated with CategoryId foreign key
- [ ] Default categories seeded on startup (Work, Personal, Shopping, Health)
- [ ] Unit tests for CategoryRepository

**Technical Notes**:
```csharp
// ReactReduxTodo/Entities/Category.cs
public class Category
{
    public int Id { get; set; }
    [Required, MaxLength(100)]
    public string Name { get; set; }
    [Required, MaxLength(7)] // Hex color
    public string Color { get; set; }
    public DateTime CreatedDate { get; set; }
    public ICollection<TodoTask> Tasks { get; set; }
}

// Update TodoTask.cs
public class TodoTask
{
    // ... existing fields
    public int? CategoryId { get; set; }
    public Category Category { get; set; }
}
```

**Can Start**: Immediately
**Estimated Effort**: 3-4 hours
**Tags**: backend, database, entity, sprint-2

---

### Work Item #2: Backend - Category API Endpoints 🔗 SEQUENTIAL

**Title**: Backend: Create Category REST API Endpoints

**Assigned To**: Backend Agent (techdebtdemo2025be@outlook.com)

**Description**:
Create REST API endpoints for CRUD operations on categories.

**Acceptance Criteria**:
- [ ] CategoriesController created
- [ ] GET /api/categories - List all categories
- [ ] GET /api/categories/{id} - Get category by ID
- [ ] POST /api/categories - Create new category
- [ ] PUT /api/categories/{id} - Update category
- [ ] DELETE /api/categories/{id} - Delete category
- [ ] TasksController updated: GET /api/tasks?categoryId={id}
- [ ] Integration tests for all endpoints

**Depends On**: Work Item #1 (Category entity must exist)

**Can Start**: After Work Item #1 completes
**Estimated Effort**: 3-4 hours
**Tags**: backend, api, rest, sprint-2

---

### Work Item #3: Frontend - Category Management UI ⚡ PARALLEL

**Title**: Frontend: Create Category Management UI

**Assigned To**: Frontend Agent (techdebtdemo2025fe@gmail.com)

**Description**:
Create UI components for managing categories (create, edit, delete).

**Acceptance Criteria**:
- [ ] CategoryManager component created
- [ ] Category list display with edit/delete buttons
- [ ] Add category form with name and color picker
- [ ] Edit category modal/form
- [ ] Delete category confirmation dialog
- [ ] Redux actions/reducers for categories
- [ ] Redux saga for async category API calls
- [ ] Component tests for CategoryManager

**Technical Notes**:
```javascript
// ClientApp/src/components/CategoryManager.jsx
// ClientApp/src/features/categories/actions.js
// ClientApp/src/features/categories/reducer.js
// ClientApp/src/features/categories/sagas.js
// ClientApp/src/services/categoryService.js
```

**Can Start**: Immediately (uses API contract above)
**Estimated Effort**: 4-5 hours
**Tags**: frontend, ui, react, redux, sprint-2

---

### Work Item #4: Frontend - Task Category Integration 🔗 SEQUENTIAL

**Title**: Frontend: Add Category Selector and Filtering to Tasks

**Assigned To**: Frontend Agent (techdebtdemo2025fe@gmail.com)

**Description**:
Integrate categories into task creation/editing and add filtering capabilities.

**Acceptance Criteria**:
- [ ] Category dropdown added to TaskForm component
- [ ] Task list displays category badge on each task
- [ ] Category badge color-coded based on category.color
- [ ] Category filter dropdown in task list header
- [ ] Filter state managed in Redux
- [ ] "All Categories" option to show unfiltered tasks
- [ ] Component tests for category integration

**Depends On**: Work Item #3 (CategoryManager component)

**Can Start**: After Work Item #3 completes
**Estimated Effort**: 3-4 hours
**Tags**: frontend, ui, react, filtering, sprint-2

---

### Work Item #5: QA - Integration & E2E Tests 🔗 SEQUENTIAL

**Title**: QA: Category Feature Integration and E2E Tests

**Assigned To**: QA Agent (TBD - need email)

**Description**:
Comprehensive testing of the category feature end-to-end.

**Acceptance Criteria**:
- [ ] Backend integration tests: CategoryController CRUD operations
- [ ] Backend integration tests: Task filtering by category
- [ ] Backend integration tests: Default categories seeded
- [ ] Frontend E2E test: User creates a new category
- [ ] Frontend E2E test: User assigns task to category
- [ ] Frontend E2E test: User filters tasks by category
- [ ] Frontend E2E test: User edits category color
- [ ] Frontend E2E test: User deletes category
- [ ] All tests passing in CI/CD pipeline

**Depends On**: Work Items #1, #2, #3, #4 (all development complete)

**Can Start**: After all development tasks complete
**Estimated Effort**: 4-5 hours
**Tags**: qa, testing, integration, e2e, sprint-2

---

## Parallel Execution Strategy

```
START
  │
  ├─→ Work Item #1 (Backend Entity)     ⚡ PARALLEL
  │   └─→ Work Item #2 (Backend API)    🔗 Sequential
  │
  ├─→ Work Item #3 (Frontend UI)        ⚡ PARALLEL
  │   └─→ Work Item #4 (Frontend Filter) 🔗 Sequential
  │
  └─────────────┬──────────────────────
                ↓
        Work Item #5 (QA Tests)         🔗 Sequential
                ↓
              DONE
```

**Parallelization**:
- 2 parallel work streams (Backend + Frontend)
- Backend and Frontend can start simultaneously
- 60% of tasks can run in parallel (3 out of 5)
- Estimated time savings: ~35% vs sequential execution

---

## Sprint Metrics

| Metric | Value |
|--------|-------|
| Total Work Items | 5 |
| Parallel Tasks | 2 |
| Sequential Tasks | 3 |
| Agents Involved | 3 (Backend, Frontend, QA) |
| Total Estimated Effort | 17-22 hours |
| Parallel Estimated Effort | 11-14 hours |
| Time Savings | ~35% |

---

## Azure DevOps Work Items

**These work items should be created in Azure DevOps:**

1. Issue #N: Backend - Category Entity & Repository
   - Assigned to: techdebtdemo2025be@outlook.com
   - Tags: backend, database, entity, sprint-2

2. Issue #N+1: Backend - Category API Endpoints
   - Assigned to: techdebtdemo2025be@outlook.com
   - Tags: backend, api, rest, sprint-2
   - Links: Depends On → Issue #N

3. Issue #N+2: Frontend - Category Management UI
   - Assigned to: techdebtdemo2025fe@gmail.com
   - Tags: frontend, ui, react, redux, sprint-2

4. Issue #N+3: Frontend - Task Category Integration
   - Assigned to: techdebtdemo2025fe@gmail.com
   - Tags: frontend, ui, react, filtering, sprint-2
   - Links: Depends On → Issue #N+2

5. Issue #N+4: QA - Integration & E2E Tests
   - Assigned to: QA Agent (email TBD)
   - Tags: qa, testing, integration, e2e, sprint-2
   - Links: Depends On → Issues #N, #N+1, #N+2, #N+3

---

## Next Steps

### For Manual Work Item Creation:

1. Go to https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_workitems
2. Click "New Work Item" → "Issue"
3. Copy the title and description from each work item above
4. Assign to the appropriate agent email
5. Add tags
6. Link dependencies

### For Automated Creation:

Once Azure DevOps MCP is configured:
```bash
# PM Agent will create all 5 work items automatically
# using mcp__azuredevops-mcp__createWorkItem
```

---

**PM Agent Sprint Planning Complete** ✓

Sprint ready for execution. Backend and Frontend agents can start working in parallel immediately.
