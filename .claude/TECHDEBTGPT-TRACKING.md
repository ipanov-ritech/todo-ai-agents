# TechDebtGPT Agent Tracking Setup

This guide explains how your TechDebtGPT app will track the AI agents' activity across GitHub and Azure DevOps.

---

## Overview

**Goal**: Track individual AI agent performance metrics to identify underperforming agents and enable meta-agent optimization.

**How it works**:
1. Each AI agent has a unique email identity (e.g., `techdebtdemo2025be@outlook.com`)
2. Agents make commits using their email identity
3. Agents are assigned work items in Azure DevOps
4. TechDebtGPT monitors both GitHub and Azure DevOps APIs
5. Metrics are aggregated per agent
6. Agent Health MVP analyzes and suggests optimizations

---

## Agent Identities

| Role | Email | GitHub Username | Azure DevOps |
|------|-------|-----------------|--------------|
| PM Agent | techdebtdemo2025po@outlook.com | techdebtdemo2025po | ✅ Active |
| Backend Agent | techdebtdemo2025be@outlook.com | techdebtdemo2025be | ✅ Active |
| Frontend Agent | techdebtdemo2025fe@gmail.com | techdebtdemo2025fe | ✅ Active |
| DevOps Agent | TBD | TBD | ⏳ Pending |
| QA Agent | TBD | TBD | ⏳ Pending |

---

## Data Sources

### 1. GitHub API

**Endpoint**: `https://api.github.com`

**What to track**:
- **Commits**: Filter by author email
- **Pull Requests**: Filter by author username
- **PR Reviews**: Track review participation
- **Code Changes**: Lines added/deleted per commit

**Sample Query**:
```bash
# Get commits by Backend Agent
curl -H "Authorization: token YOUR_GITHUB_PAT" \
  "https://api.github.com/repos/ipanov-ritech/todo-ai-agents/commits?author=techdebtdemo2025be"

# Get PRs by Frontend Agent
curl -H "Authorization: token YOUR_GITHUB_PAT" \
  "https://api.github.com/repos/ipanov-ritech/todo-ai-agents/pulls?state=all&creator=techdebtdemo2025fe"
```

### 2. Azure DevOps API

**Endpoint**: `https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_apis`

**What to track**:
- **Work Items**: Assigned to agent, state changes, cycle time
- **Commits**: Linked to work items via `AB#{number}`
- **Pull Requests**: Linked work items
- **Board Activity**: State transitions, time in each state

**Sample Query**:
```bash
# Get work items assigned to Backend Agent
curl -u :{YOUR_AZURE_DEVOPS_PAT} \
  "https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_apis/wit/wiql?api-version=7.0" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "SELECT [System.Id], [System.Title], [System.State]
              FROM WorkItems
              WHERE [System.AssignedTo] = '\''techdebtdemo2025be@outlook.com'\''
              AND [System.TeamProject] = '\''techdebtgpt-agent-health-mvp'\''"
  }'

# Get commits linked to work item
curl -u :{YOUR_AZURE_DEVOPS_PAT} \
  "https://dev.azure.com/ipanov-ritech/techdebtgpt-agent-health-mvp/_apis/wit/workitems/1?$expand=relations&api-version=7.0"
```

---

## Key Metrics to Track

### Per-Agent Metrics

#### 1. **Velocity Metrics**
- Commits per sprint
- Work items completed per sprint
- Average time to complete work item (cycle time)
- Lines of code changed per commit

#### 2. **Quality Metrics**
- PR review comments received
- Number of bugs created (tagged to agent)
- PR merge rate (% of PRs merged vs. closed)
- Test coverage changes

#### 3. **Collaboration Metrics**
- PR reviews given to other agents
- Time to first PR review
- Comments on other agents' work items
- Merge conflicts encountered

#### 4. **Efficiency Metrics**
- Average commits per work item
- Commit frequency (commits per day)
- Time between work item assignment and first commit
- PR size (lines changed)

---

## TechDebtGPT Integration Code

### Configuration File (config.json)

```json
{
  "github": {
    "owner": "ipanov-ritech",
    "repo": "todo-ai-agents",
    "token": "YOUR_GITHUB_PAT_HERE"
  },
  "azureDevOps": {
    "organization": "ipanov-ritech",
    "project": "techdebtgpt-agent-health-mvp",
    "token": "YOUR_AZURE_DEVOPS_PAT_HERE"
  },
  "agents": [
    {
      "id": "agent-pm",
      "name": "PM Agent",
      "email": "techdebtdemo2025po@outlook.com",
      "githubUsername": "techdebtdemo2025po",
      "role": "ProductManager"
    },
    {
      "id": "agent-backend",
      "name": "Backend Agent",
      "email": "techdebtdemo2025be@outlook.com",
      "githubUsername": "techdebtdemo2025be",
      "role": "BackendDeveloper"
    },
    {
      "id": "agent-frontend",
      "name": "Frontend Agent",
      "email": "techdebtdemo2025fe@gmail.com",
      "githubUsername": "techdebtdemo2025fe",
      "role": "FrontendDeveloper"
    }
  ],
  "tracking": {
    "pollInterval": 300,
    "metricsWindow": "30d",
    "enableRealtime": true
  }
}
```

### Sample Data Fetching (Pseudocode)

```javascript
// Fetch GitHub commits for an agent
async function getAgentCommits(agentEmail, since) {
  const commits = await github.repos.listCommits({
    owner: 'ipanov-ritech',
    repo: 'todo-ai-agents',
    author: agentEmail,
    since: since
  });

  return commits.data.map(commit => ({
    sha: commit.sha,
    message: commit.commit.message,
    date: commit.commit.author.date,
    additions: commit.stats.additions,
    deletions: commit.stats.deletions,
    files: commit.files.length
  }));
}

// Fetch Azure DevOps work items for an agent
async function getAgentWorkItems(agentEmail) {
  const wiql = {
    query: `SELECT [System.Id], [System.Title], [System.State], [System.CreatedDate], [System.ChangedDate]
            FROM WorkItems
            WHERE [System.AssignedTo] = '${agentEmail}'
            AND [System.TeamProject] = 'techdebtgpt-agent-health-mvp'
            ORDER BY [System.ChangedDate] DESC`
  };

  const result = await azureDevOps.wit.queryByWiql(wiql);
  const workItems = await Promise.all(
    result.workItems.map(wi =>
      azureDevOps.wit.getWorkItem(wi.id, { $expand: 'Relations' })
    )
  );

  return workItems.map(wi => ({
    id: wi.id,
    title: wi.fields['System.Title'],
    state: wi.fields['System.State'],
    assignedTo: wi.fields['System.AssignedTo'].uniqueName,
    createdDate: wi.fields['System.CreatedDate'],
    changedDate: wi.fields['System.ChangedDate'],
    cycleTime: calculateCycleTime(wi),
    linkedCommits: getLinkedCommits(wi.relations)
  }));
}

// Calculate agent health score
function calculateAgentHealthScore(agent, metrics) {
  const velocityScore = calculateVelocity(metrics.commits, metrics.workItems);
  const qualityScore = calculateQuality(metrics.bugs, metrics.prComments);
  const collaborationScore = calculateCollaboration(metrics.reviews, metrics.comments);
  const efficiencyScore = calculateEfficiency(metrics.cycleTime, metrics.commitSize);

  return {
    overall: (velocityScore + qualityScore + collaborationScore + efficiencyScore) / 4,
    breakdown: {
      velocity: velocityScore,
      quality: qualityScore,
      collaboration: collaborationScore,
      efficiency: efficiencyScore
    }
  };
}
```

---

## Dashboard Visualizations

### 1. **Agent Performance Dashboard**

Display for each agent:
- Overall health score (0-100)
- Commits this sprint (bar chart)
- Work items completed (line chart over time)
- Average cycle time (comparison across agents)

### 2. **Commit Attribution View**

Timeline showing:
- Each commit as a dot
- Color-coded by agent
- Size of dot = lines changed
- Tooltip shows commit message and work item link

### 3. **Work Item Board View**

Kanban board showing:
- Columns: To Do | In Progress | Review | Done
- Cards color-coded by assigned agent
- Time in each state displayed on card
- Links to GitHub PRs

### 4. **Agent Comparison Matrix**

Table comparing all agents:

| Metric | PM Agent | Backend Agent | Frontend Agent | DevOps Agent | QA Agent |
|--------|----------|---------------|----------------|--------------|----------|
| Commits/Sprint | 5 | 15 | 12 | 8 | 3 |
| Work Items Done | 2 | 3 | 3 | 2 | 4 |
| Avg Cycle Time | 2.5d | 3.2d | 2.8d | 1.5d | 2.0d |
| PR Merge Rate | 90% | 85% | 95% | 100% | 100% |
| Health Score | 88 | 82 | 91 | 95 | 93 |

---

## Agent Health MVP Integration

### Identify Underperforming Agent

```javascript
async function identifyLowestPerformer(agents) {
  const scores = await Promise.all(
    agents.map(async agent => {
      const metrics = await fetchAgentMetrics(agent.email);
      const score = calculateAgentHealthScore(agent, metrics);
      return { agent, score };
    })
  );

  // Sort by overall score
  scores.sort((a, b) => a.score.overall - b.score.overall);

  return scores[0]; // Lowest performing agent
}

async function generateOptimizationRecommendations(agent, metrics) {
  const recommendations = [];

  // Low velocity?
  if (metrics.commits.length < 5) {
    recommendations.push({
      issue: "Low commit frequency",
      suggestion: "Break work into smaller, more frequent commits",
      action: "Update agent prompt to commit after each logical unit of work"
    });
  }

  // Large PRs?
  const avgPrSize = calculateAvgPrSize(metrics.pullRequests);
  if (avgPrSize > 500) {
    recommendations.push({
      issue: "Large pull requests",
      suggestion: "Create smaller, more focused PRs",
      action: "Update agent prompt to limit PR scope to single feature"
    });
  }

  // High cycle time?
  if (metrics.avgCycleTime > 3) {
    recommendations.push({
      issue: "High cycle time (>3 days)",
      suggestion: "Start work sooner after assignment",
      action: "Adjust agent workflow to prioritize assigned work items"
    });
  }

  return recommendations;
}
```

---

## Example: Meta-Agent Optimization Loop

```
1. TechDebtGPT detects Backend Agent has low health score (82/100)

2. Agent Health MVP analyzes root cause:
   - Issue: Large commits (avg 850 lines)
   - Issue: Infrequent commits (1 per work item)
   - Issue: Long cycle time (3.2 days avg)

3. Meta-Agent generates recommendation:
   "Update Backend Agent prompt to:
   - Make commits after each logical unit (e.g., after adding entity, after migration)
   - Target commits under 200 lines
   - Start work within 4 hours of assignment"

4. Updated prompt deployed to Backend Agent

5. Next sprint metrics show improvement:
   - Health score: 82 → 89
   - Commits per work item: 1 → 3.5
   - Avg commit size: 850 → 245 lines
   - Cycle time: 3.2d → 2.1d

6. Success! Meta-agent optimization validated.
```

---

## API Endpoints to Implement

### In TechDebtGPT Backend

```
GET  /api/agents                         - List all agents
GET  /api/agents/:id/metrics             - Get metrics for specific agent
GET  /api/agents/:id/commits             - Get commits by agent
GET  /api/agents/:id/workitems           - Get work items assigned to agent
GET  /api/agents/:id/health              - Get health score for agent
GET  /api/agents/leaderboard             - Get all agents ranked by health score
POST /api/agents/:id/optimize            - Trigger optimization for agent
GET  /api/sprints/:id/summary            - Get sprint summary with agent metrics
```

---

## Security Considerations

1. **PAT Tokens**: Store securely (environment variables, Azure Key Vault)
2. **Rate Limiting**: Respect GitHub and Azure DevOps API rate limits
3. **Data Privacy**: Agent metrics visible only to authorized users
4. **Token Rotation**: Rotate PATs every 90 days
5. **Audit Log**: Track who accesses agent metrics

---

## Testing the Integration

### Test 1: Verify Agent Detection

```bash
# Make a commit as Backend Agent
.\scripts\setup-agent-git.ps1 -Agent backend
git commit -m "test: TechDebtGPT tracking AB#1"
git push

# Check TechDebtGPT dashboard
# Should see: New commit by techdebtdemo2025be@outlook.com
```

### Test 2: Verify Work Item Tracking

```bash
# Update work item in Azure DevOps
# Move from "To Do" to "In Progress"

# Check TechDebtGPT dashboard
# Should see: Work item state change, cycle time started
```

### Test 3: Verify Health Score Calculation

```bash
# In TechDebtGPT, trigger health score calculation
# Should see: Score for each agent based on recent activity
```

---

## Next Steps

1. ✅ Set up agent identities in Azure DevOps (done)
2. ✅ Configure GitHub-Azure Boards integration
3. ⏳ Implement TechDebtGPT data fetching from both APIs
4. ⏳ Build health score calculation algorithm
5. ⏳ Create dashboard visualizations
6. ⏳ Implement meta-agent optimization loop
7. ⏳ Test end-to-end with real agent activity

---

## Resources

- **GitHub REST API**: https://docs.github.com/en/rest
- **Azure DevOps REST API**: https://learn.microsoft.com/en-us/rest/api/azure/devops/
- **Azure Boards Integration**: https://learn.microsoft.com/en-us/azure/devops/boards/github/
- **Agent Specs**: See `.claude/agents/` folder in this repo
