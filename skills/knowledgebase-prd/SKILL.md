---
name: knowledgebase-prd
description: Translate a task description into a PRD document with git diff as deliverable. Describes WHAT to build and WHY. Generic for any Go repository.
---

# Skill: Knowledgebase PRD

Translate a task into a PRD (Product Requirements Document), then produce a git diff of the changes. The PRD describes WHAT to build and WHY. The git diff becomes the input for implementation planning.

## Core Concept

```
Task description → create/update PRD in docs/ → git diff = the deliverable
```

The PRD describes the **target state** of the system. Write it as if the feature is already done. The git diff naturally shows what changed — that diff is what the implementer reads.

**CRITICAL: Describe target state, not changes.**
- WRONG: "Remove column X, add column Y"
- RIGHT: Show the schema WITH column Y and WITHOUT column X. The diff shows the delta.

## Workflow

1. **Resolve task context**:
   - Extract task ID from skill arguments, user message, or current branch:
     ```bash
     TASK_ID=$(git branch --show-current | grep -oE '[A-Z]+-[0-9]+' | head -1)
     ```
   - If on `master`/`main`, create a feature branch:
     ```bash
     git checkout -b "feat/$TASK_ID"
     ```
   - If a Jira/issue tracker MCP tool is available, read the task and its parent for full context. Parents often have the "why" and broader acceptance criteria that subtasks lack.

2. **Determine scope** from task context — which area of the system is affected

3. **Search existing docs**: look in `docs/` (or project's docs directory from CLAUDE.md) for related files

4. **Update existing docs to target state** — modify descriptions, add new sections, remove obsolete parts. The doc should read as if the feature is already done.

5. **Only create a new file** if the feature is genuinely new and no existing doc covers it

6. **Produce git diff**: run `git diff` at the end — this diff IS the deliverable

## PRD Template

```markdown
# PRD: [Feature Name]

## Product overview
[What this gives the user, 2-3 sentences]

## Background
[Problem context, why this matters now]

## Goals
[Numbered list of outcomes]

## Scope
**In scope:** ...
**Out of scope (v1):** ...

## User personas
| Persona | Description |
|---------|-------------|

## User journey
```text
[ASCII diagram or step-by-step flow]
```

## Changes
[High-level description of WHAT needs to change and WHY. No code. No diffs. Just areas and reasoning.]

### [Change Area 1]
[Which layer/component is affected, what needs to be added/modified, and the approach]

## Acceptance criteria
| # | Area | AC |
|---|------|-----------|
[Numbered, testable criteria]

## Reference implementation
[Point to existing code that implements a similar pattern. Include specific file paths and line ranges so the implementer can study how it was done before.]

**Example format:**
- **Pattern**: [what pattern to follow]
- **Files**: `internal/path/to/file.go:86-95` — [what this code does]
- **How to extend**: [brief note on what to add/change by analogy]

## Dependencies
[What this depends on, what depends on this]
```

## Format Guidelines

- **Update existing docs to target state** — if the task changes a schema, update the schema doc. If it adds a field, add the field to the existing doc. NEVER create a separate file that describes the delta when an existing doc already covers that area.
- **No code snippets in the PRD body** — file path references are OK (e.g., `internal/repo/foo.go:86-95`), but no SQL blocks, no Go blocks. The doc describes the system at product level.
- **The git diff of the updated docs IS the deliverable** — after updating, run `git diff` to show exactly what changed.
- **Backend features**: use the template as-is — product overview, goals, user journey with ASCII diagrams, changes described at high level
- **UI-heavy features**: use numbered REQ-NNN sections under "Functional Requirements", each with Goal/How It Works/Scenario/Acceptance Criteria
- Keep acceptance criteria testable: each row should be verifiable by a QA engineer
- Use ASCII diagrams for data flows — they render well in any viewer
- **Always include a "Reference implementation" section** — point to existing code that implements the same pattern. Concrete file paths, line ranges, and how to extend by analogy. Without this, the PRD is just a wish list.

## Next Step: Planning

After the PRD is complete (git diff exists), the next step is **structured planning**:

1. **Invoke `superpowers:brainstorming`** — explore the PRD, create design spec:
   ```
   Skill: superpowers:brainstorming
   Args: "Context: PRD in docs/ (run git diff master...HEAD -- docs/). See CLAUDE.md for stack and conventions."
   ```
2. Brainstorming auto-invokes **`superpowers:writing-plans`** — creates a plan with micro-tasks (TDD, exact file paths)
3. Plan feeds into `/team-lead` for implementation

```
/knowledgebase-prd → superpowers:brainstorming → superpowers:writing-plans → /team-lead
```