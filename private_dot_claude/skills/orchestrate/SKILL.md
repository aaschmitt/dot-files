---
name: orchestrate
description: Orchestrates a full feature implementation pipeline for Godot game projects. Runs specialized sub-agents in sequence to analyze the codebase, design the player experience, research industry examples, research Godot implementation approaches, evaluate options, plan, and build. Also handles ad-hoc tasks that skip the full pipeline. Use when the user wants to add a new feature, refactor an existing system, make significant changes, or do smaller ad-hoc work on their Godot game.
---

# Godot Feature Pipeline SOP

## Overview

This SOP orchestrates feature work for a Godot game project. It supports two modes:

- **Full pipeline**: A structured 7-stage process for features that need research, design, and planning before building.
- **Ad-hoc**: A lightweight path for small or obvious tasks that just need to get done.

Each invocation creates a project directory under `agent-pipeline/`. A `status.md` file tracks progress so the pipeline can be resumed after `/clear`.

Use this SOP when:
- The user wants to add a new feature to their Godot game
- The user wants to refactor or significantly change an existing system
- The user has a small task or quick fix that needs doing
- The user describes work of any size and needs help getting it done

## Parameters

- **feature_ask** (required): What the user wants to do. Gathered through conversation.
- **project_name** (required): A kebab-case name for this project. Used as the subdirectory name under `agent-pipeline/`.

**Constraints for parameter acquisition:**
- You MUST NOT ask for parameters immediately because the startup step comes first
- You MUST gather parameters only after determining whether to resume, start new, or go ad-hoc

## Steps

### 1. Startup

Scan for existing projects and determine what the user wants to do.

**Constraints:**
- You MUST check if `agent-pipeline/` exists and scan for subdirectories containing `status.md` files
- If incomplete projects exist, you MUST list them with their current stage and feature ask
- You MUST ask the user what they want to do. Present the options naturally:
  - Resume an existing project (if any exist)
  - Start a new feature (full pipeline)
  - Do an ad-hoc task (quick, no full pipeline)
- You MUST NOT assume what the user wants because they may be returning to resume, starting fresh, or just need something small done
- If no `agent-pipeline/` directory exists, skip the scan and ask what they want to build

### 2. Setup

Collect the feature ask and project name, create the project directory.

**Constraints:**
- You MUST ask: "What do you want to build, add, or change?" if not already provided
- You MUST ask for a short project name in kebab-case (e.g., `customer-queue`, `fix-score-ui`)
- You MUST create `agent-pipeline/{project_name}/`
- You MUST write the initial `status.md` with the feature ask, mode (full or ad-hoc), and current stage
- You MUST NOT proceed until the directory and status file exist because all agents depend on this location

### 3. Route: Full Pipeline or Ad-Hoc

Decide which path to take based on the user's choice from Startup.

**Constraints:**
- If the user chose **ad-hoc**, skip to Step 11 (Ad-Hoc Execution)
- If the user chose **full pipeline**, proceed to Step 4
- If the user chose **resume**, read `status.md` from the existing project, tell the user where it left off, and resume from the next incomplete stage
- You MUST NOT run the full pipeline for work the user identified as ad-hoc because it wastes their time

---

## Full Pipeline Path

### 4. Stage 1 — Codebase Analysis

Spawn the `godot-codebase-analyzer` sub-agent to understand the current project.

**Constraints:**
- You MUST spawn the `godot-codebase-analyzer` sub-agent with a task prompt containing:
  - The feature_ask
  - The output_path: `agent-pipeline/{project_name}/01-project-analysis.md`
- You MUST wait for the agent to complete
- You MUST read the output file and present a brief summary of key findings to the user
- You MUST update `status.md` to mark Stage 1 complete
- You MUST tell the user: **"Progress saved. It's safe to `/clear` if you need to free up context. Run `/orchestrate` to resume."**
- You MUST NOT dump the entire analysis because the user only needs the highlights

### 5. Stage 2 — Experience Design

Spawn the `godot-experience-designer` sub-agent in the foreground to collaborate with the user.

**Constraints:**
- You MUST spawn the `godot-experience-designer` sub-agent **in the foreground** with a task prompt containing:
  - The feature_ask
  - The project_analysis_path: `agent-pipeline/{project_name}/01-project-analysis.md`
  - The output_path: `agent-pipeline/{project_name}/02-experience-design.md`
- You MUST spawn this agent in the foreground because it requires interactive conversation with the user
- You MUST wait for the agent to complete
- You MUST read the output file

**Approval Gate:**
- You MUST present a summary of the chosen experience direction
- You MUST ask: "Are you happy with this experience direction? Should we proceed to researching how to build it?"
- You MUST NOT proceed until the user explicitly confirms because all remaining stages depend on the experience design
- After approval, you MUST update `status.md` and tell the user it is safe to `/clear`

### 6. Stage 3 — Industry Research

Spawn the `godot-industry-researcher` sub-agent to research how similar games handle this type of feature.

**Constraints:**
- You MUST spawn the `godot-industry-researcher` sub-agent with a task prompt containing:
  - The feature_ask
  - The project_analysis_path: `agent-pipeline/{project_name}/01-project-analysis.md`
  - The experience_design_path: `agent-pipeline/{project_name}/02-experience-design.md`
  - The output_path: `agent-pipeline/{project_name}/03-industry-research.md`
- You MUST wait for the agent to complete
- You MUST read the output file and present a brief summary of key findings: which games were studied, the most relevant design patterns discovered, and any open design questions raised
- You MUST update `status.md` to mark Stage 3 complete
- You MUST tell the user: **"Progress saved. It's safe to `/clear` if you need to free up context. Run `/orchestrate` to resume."**
- You MUST NOT dump the entire research document because the user only needs the highlights

### 7. Stage 4 — Godot Implementation Research

Spawn the `godot-impl-researcher` sub-agent to find implementation approaches.

**Constraints:**
- You MUST spawn the `godot-impl-researcher` sub-agent with a task prompt containing:
  - The project_analysis_path: `agent-pipeline/{project_name}/01-project-analysis.md`
  - The experience_design_path: `agent-pipeline/{project_name}/02-experience-design.md`
  - The industry_research_path: `agent-pipeline/{project_name}/03-industry-research.md`
  - The output_path: `agent-pipeline/{project_name}/04-research-options.md`
- You MUST wait for the agent to complete
- You MUST read the output file and present a brief summary of approaches found
- You MUST update `status.md` and tell the user it is safe to `/clear`

### 8. Stage 5 — Approach Evaluation

Spawn the `godot-approach-evaluator` sub-agent to rank the approaches.

**Constraints:**
- You MUST spawn the `godot-approach-evaluator` sub-agent with a task prompt containing:
  - The project_analysis_path: `agent-pipeline/{project_name}/01-project-analysis.md`
  - The experience_design_path: `agent-pipeline/{project_name}/02-experience-design.md`
  - The industry_research_path: `agent-pipeline/{project_name}/03-industry-research.md`
  - The research_options_path: `agent-pipeline/{project_name}/04-research-options.md`
  - The output_path: `agent-pipeline/{project_name}/05-evaluation-ranking.md`
- You MUST wait for the agent to complete
- You MUST read the output file

**Approval Gate:**
- You MUST present the recommended approach and a brief comparison of the top 2-3 options
- You MUST ask: "The evaluator recommends [approach]. Do you agree, or would you prefer a different option?"
- You MUST NOT proceed until the user explicitly selects an approach because the planner and builder need a confirmed direction
- After approval, you MUST update `status.md` with the chosen approach and tell the user it is safe to `/clear`

### 9. Stage 6 — Implementation Planning

Spawn the `godot-impl-planner` sub-agent to create a lightweight build plan.

**Constraints:**
- You MUST spawn the `godot-impl-planner` sub-agent with a task prompt containing:
  - The chosen_approach
  - The project_analysis_path: `agent-pipeline/{project_name}/01-project-analysis.md`
  - The experience_design_path: `agent-pipeline/{project_name}/02-experience-design.md`
  - The industry_research_path: `agent-pipeline/{project_name}/03-industry-research.md`
  - The research_options_path: `agent-pipeline/{project_name}/04-research-options.md`
  - The evaluation_ranking_path: `agent-pipeline/{project_name}/05-evaluation-ranking.md`
  - The output_path: `agent-pipeline/{project_name}/06-implementation-plan.md`
- You MUST wait for the agent to complete
- You MUST read the output file

**Approval Gate:**
- You MUST present the plan to the user
- You MUST ask: "Here's the implementation plan. Ready to build, or do you want to adjust anything?"
- You MUST NOT proceed until the user approves because the builder executes exactly what the plan says
- After approval, you MUST update `status.md` and tell the user it is safe to `/clear`

### 10. Stage 7 — Build

Spawn the `godot-impl-builder` sub-agent in the foreground to implement the feature.

**Constraints:**
- You MUST spawn the `godot-impl-builder` sub-agent **in the foreground** with a task prompt containing:
  - The pipeline_dir: `agent-pipeline/{project_name}/`
  - The plan_path: `agent-pipeline/{project_name}/06-implementation-plan.md`
- You MUST spawn this agent in the foreground because it may need to interact with the user during implementation
- You MUST wait for the agent to complete
- After completion, you MUST update `status.md` to mark the pipeline as complete
- You MUST summarize what was built, what to test, and remind the user about `/vg-bug-fix`

---

## Ad-Hoc Path

### 11. Ad-Hoc Execution

For small or obvious tasks, go directly to building. Use your judgment on whether codebase analysis is needed.

**Constraints:**
- You MUST assess whether the task needs codebase analysis:
  - If the task touches existing systems, integrates with other code, or the user seems unsure where things live, you SHOULD run the `godot-codebase-analyzer` first and write output to `agent-pipeline/{project_name}/01-project-analysis.md`
  - If the task is self-contained, obvious, or the user clearly knows what they want, skip the analyzer and go straight to the builder
- You MUST spawn the `godot-impl-builder` sub-agent **in the foreground** with a task prompt containing:
  - The feature_ask (what to build)
  - The pipeline_dir: `agent-pipeline/{project_name}/`
  - The project analysis path (if the analyzer was run)
  - Clear instructions on what to do since there is no implementation plan for ad-hoc tasks
- You MUST wait for the agent to complete
- After completion, you MUST update `status.md` to mark the task as complete
- You MUST summarize what was done and remind the user about `/vg-bug-fix`
- You MUST NOT run experience design, industry research, Godot implementation research, evaluation, or planning stages for ad-hoc tasks because the whole point of ad-hoc is to skip that overhead

---

## Status Tracking

**Constraints:**
- You MUST create `agent-pipeline/{project_name}/status.md` during Setup
- You MUST update it after each stage completes and each gate is approved
- The status file MUST contain:
  - **Feature Ask**: The user's original request
  - **Mode**: Full pipeline or ad-hoc
  - **Project Directory**: The full path
  - **Current Stage**: Which stage is next (or "Done")
  - **Chosen Approach**: The selected approach (once decided at Stage 5)
  - **Stage Log**: Which stages are complete
- After every `status.md` update, you MUST tell the user it is safe to `/clear` and how to resume

## Examples

### Example Startup With Existing Projects

```
User: /orchestrate

Claude: Found 2 existing projects in agent-pipeline/:

  1. customer-queue — Stage 5 (Approach Evaluation) — "Add customer queueing system"
  2. score-fix — Done — "Fix score display bug"

Want to resume customer-queue, start a new project, or do a quick ad-hoc task?
```

### Example Ad-Hoc Task

```
User: /orchestrate

Claude: No existing projects found. What would you like to do — start a new feature (full pipeline) or a quick ad-hoc task?

User: Ad-hoc. Just add a mute button to the settings menu.

Claude: Got it. Give me a short project name:

User: mute-button

Claude: Created agent-pipeline/mute-button/. This is straightforward — going straight to build.
[spawns builder]
```

### Example Context Clearing

```
Claude: Stage 4 complete — research found 4 viable approaches. [summary]

Progress saved. It's safe to /clear if you need to free up context.
Run /orchestrate to resume.
```

### Example Status File

```markdown
# Pipeline Status: customer-queue

## Feature Ask
Add a system where customers queue up and wait for their order.

## Mode
Full pipeline

## Project Directory
agent-pipeline/customer-queue/

## Current Stage
6 — Implementation Planning

## Chosen Approach
Signal-based queue with Resource customer data

## Stage Log
- [x] Stage 1 — Codebase Analysis
- [x] Stage 2 — Experience Design — approved
- [x] Stage 3 — Industry Research
- [x] Stage 4 — Godot Implementation Research
- [x] Stage 5 — Approach Evaluation — approved: Signal-based queue
- [ ] Stage 6 — Implementation Planning
- [ ] Stage 7 — Build
```

## Troubleshooting

### A Sub-Agent Produces Poor Output
If a sub-agent's output is incomplete, off-target, or low quality, tell the user and offer to re-run that stage. You MUST NOT silently proceed with bad output because every downstream stage depends on upstream quality.

### User Wants to Skip Stages
If the user wants to skip ahead, explain what they would miss and the risks. If they still want to skip, respect the decision and note skipped stages in `status.md`.

### User Changes Their Mind Mid-Pipeline
If the user wants to revisit an earlier decision, go back to the relevant stage and re-run from there. You MUST NOT re-run only the changed stage because downstream artifacts become stale. Update `status.md` to reflect the rollback.

### Pipeline Directory Exists Without status.md
If `agent-pipeline/{project_name}/` exists but has no `status.md`, treat it as a fresh start. Create the status file and begin from Stage 1 (or ad-hoc).

### User Isn't Sure Which Mode to Pick
If the user doesn't know whether they need the full pipeline or ad-hoc, ask them to describe the task. If it touches multiple systems, needs design decisions, or is ambiguous, recommend full pipeline. If it's a single clear change, recommend ad-hoc.
