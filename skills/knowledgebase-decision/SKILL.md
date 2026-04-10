---
name: knowledgebase-decision
description: Document architectural decisions (ADRs) AFTER code is written, capturing the "why" behind trade-offs. Generic for any Go repository.
---

# Skill: Knowledgebase Decision (ADR)

Document architectural decisions AFTER code is written, capturing the "why" behind trade-offs.

## When to Write a Decision

- Chose between 2+ implementation approaches
- Added a new database table, index, or query pattern
- Changed a data flow (message queue topology, consumer pipeline, processing order)
- Added infrastructure (new service, cache layer, external dependency)
- Chose a storage pattern (where to store data, how to deduplicate, partitioning strategy)
- Made an API design choice (endpoint structure, response format, versioning)
- Chose a runtime strategy (in-memory vs external service vs DB, sync vs async)
- Changed a migration strategy or deployment approach

## Workflow

1. **Scan git diff** on the current branch to understand what changed: `git diff master...HEAD --stat`
2. **Determine docs directory**: use `docs/decisions/` (or the project's convention from CLAUDE.md)
3. **Find next decision number**: `ls docs/decisions/` — take max NNN + 1. If directory doesn't exist, create it and start at 001.
4. **Create decision file**: `docs/decisions/NNN-slug.md`

## Decision Template

```markdown
---
type: decision
date: YYYY-MM-DD
task: [TASK-ID or link]
---

# [Decision Title]

## Context

[What problem existed? What was there before? What constraints applied?]

## Decision

[What was decided and why. 1-3 paragraphs.]

## Alternatives

| Option | Why Not |
|--------|---------|
| ... | ... |

## Consequences

**Benefits:**
- ...

**Costs / Trade-offs:**
- ...
```

## Guidelines

- Write decisions in past tense — they document what WAS decided, not proposals
- The Context section should explain the problem clearly enough that someone unfamiliar can understand why a decision was needed
- The Alternatives table is the most valuable part — it explains "why not X?" which is what future engineers will ask
- Keep it concise: 1 page, not 5. If you need more, the decision is probably multiple decisions
- Use the slug format: `NNN-lowercase-with-dashes.md` (e.g., `008-session-id-storage.md`)
- Link to the task/issue that triggered the decision in the frontmatter
