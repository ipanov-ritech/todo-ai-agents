# Test Feature Request: Task Categories

## User Story
**As a** user
**I want to** organize my tasks into categories (Work, Personal, Shopping, etc.)
**So that** I can better manage different areas of my life

## Acceptance Criteria
- Users can create custom categories
- Each task can be assigned to one category
- Tasks can be filtered by category
- Categories have custom colors for visual distinction
- Default categories provided: Work, Personal, Shopping, Health

## Expected Implementation

### Backend Requirements
- Category entity with name and color fields
- Task-Category relationship (foreign key)
- REST API endpoints for CRUD operations on categories
- API endpoint to filter tasks by category
- Database migration
- Default categories seeded on first run

### Frontend Requirements
- Category management UI (create, edit, delete categories)
- Category selector dropdown in task form
- Category badge display on each task
- Category filter dropdown in task list
- Color picker for category customization

### Testing Requirements
- Integration tests for category API
- Unit tests for category repository
- E2E tests for category UI workflows
- Test default category seeding

### DevOps Requirements
- Ensure migrations run in CI/CD pipeline
- Update deployment documentation

## Technical Notes

### Database Schema
```sql
CREATE TABLE Categories (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Color NVARCHAR(7) NOT NULL, -- Hex color code
    CreatedDate DATETIME2 NOT NULL
);

ALTER TABLE Tasks ADD CategoryId INT NULL;
ALTER TABLE Tasks ADD CONSTRAINT FK_Tasks_Categories
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id);
```

### API Endpoints
```
GET    /api/categories           - List all categories
GET    /api/categories/{id}      - Get category by ID
POST   /api/categories           - Create new category
PUT    /api/categories/{id}      - Update category
DELETE /api/categories/{id}      - Delete category
GET    /api/tasks?categoryId=1   - Filter tasks by category
```

### Redux State
```javascript
{
  categories: [
    { id: 1, name: 'Work', color: '#3498db' },
    { id: 2, name: 'Personal', color: '#2ecc71' }
  ],
  tasks: [
    { id: 1, title: 'Task', categoryId: 1, category: {...} }
  ],
  filters: {
    category: null // or categoryId
  }
}
```

## Success Metrics
- All API endpoints functional and tested
- UI allows full category management
- Users can filter tasks by category
- All tests passing (backend + frontend + E2E)
- Feature deployed and documented

---

**PM Agent**: Please break this feature down into parallelizable tasks and create work items in Azure DevOps!
