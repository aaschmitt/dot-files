---
name: vg-bug-fix
description: This SOP guides you through diagnosing and fixing bugs in a Godot game codebase. It performs comprehensive code analysis before proposing fixes, explains the root cause to the user, and offers multiple Godot-native fix options when available. Emphasizes GDScript best practices and Godot engine patterns.
type: anthropic-skill
version: "1.0"
---

# Godot Bug Fix SOP

## Overview

This SOP guides agents through the process of diagnosing and fixing bugs in a Godot game project. It emphasizes thorough analysis before proposing solutions, ensuring the root cause is understood and fixes use Godot-native patterns and best practices.

**This SOP is diagnostic and methodical.** It prioritizes understanding over speed, ensuring fixes address root causes rather than symptoms. The agent MUST analyze all relevant implementation code before proposing any fixes.

The workflow focuses on:
- Gathering complete bug context
- Systematically analyzing all related GDScript, scenes, and resources
- Identifying the root cause with evidence
- Explaining WHY the bug occurs in plain language
- Offering multiple Godot-native fix options with tradeoffs
- Implementing the user's chosen fix using Godot best practices

Use this SOP when:
- The user reports a bug or unexpected behavior in their Godot game
- Something that previously worked is now broken
- The game behaves differently than intended
- An error, warning, or crash is occurring
- A feature isn't working as specified
- Godot is producing unexpected console output

## Parameters

- **bug_report** (required): Description of the bug. Can be provided as:
  - Direct text description
  - Error message, warning, or stack trace from Godot console
  - File path to a bug report
  - Reference to a GitHub issue
  - Screenshot or video description
- **affected_area** (optional): Hint about which system or feature is affected (e.g., "player movement", "inventory UI", "save system", "physics")
- **reproduction_steps** (optional): Steps to reproduce the bug in the editor or game

**Constraints for parameter acquisition:**
- You MUST ask for the bug_report if not provided
- You SHOULD ask for reproduction steps if not obvious from the report
- You SHOULD ask for the full Godot console output if an error is involved
- You MAY ask about affected_area if the bug description is vague
- You MUST confirm you understand the bug before proceeding to analysis
- You MUST NOT start analyzing code until the bug is clearly understood because premature analysis wastes time on irrelevant code

## Output Structure

Bug fix analysis is documented inline during conversation, with optional summary:

```
context/
└── bugs/
    └── {bug-name}/
        └── analysis.md    # Optional: detailed analysis for complex bugs
```

## Steps

### 1. Bug Report Intake

Gather complete information about the bug before any code analysis.

**Constraints:**
- You MUST obtain a clear description of:
  - What behavior is expected
  - What behavior is actually occurring
  - When/where the bug manifests (game state, player action, timing)
- You MUST ask for reproduction steps if not provided
- You MUST ask for Godot console output, including:
  - Error messages (red)
  - Warnings (yellow)
  - Script errors with line numbers
  - Stack traces
- You SHOULD ask when the bug first appeared (after what change, if known)
- You SHOULD ask if the bug is consistent or intermittent
- You SHOULD ask which Godot version is being used
- You MUST summarize your understanding of the bug back to the user
- You MUST get confirmation that your understanding is correct before proceeding
- You MUST NOT proceed to code analysis until the bug is clearly defined because analyzing code without understanding the bug leads to wasted effort

**Godot-specific questions to ask:**
- "What does the Godot console show when this happens?"
- "Does this happen in the editor, exported build, or both?"
- "Are there any warnings (yellow) appearing in the console?"
- "What Godot version are you using?"
- "Does this happen in specific scenes or everywhere?"
- "Is this related to _ready(), _process(), or _physics_process()?"

**Output:**
- Clear understanding of expected vs actual behavior
- Reproduction steps (if available)
- Complete Godot console output

### 2. Scope Identification

Identify which Godot systems and files are potentially involved in the bug.

**Constraints:**
- You MUST identify the primary system(s) related to the bug
- You MUST map out the Godot-specific dependency chain:
  - Scene tree hierarchy (parent/child relationships)
  - Autoloads involved
  - Signal connections
  - Resource dependencies (.tres, .res files)
  - Inherited scenes (scene inheritance)
  - Class dependencies (class_name references)
- You MUST check for relevant documentation:
  - `context/concepts.md` for terminology
  - `context/features/` for feature specifications
  - Project architecture documents
- You MUST identify ALL files that could be involved:
  - `.gd` scripts
  - `.tscn` scene files
  - `.tres` resource files
  - `project.godot` settings
  - Input maps in project settings
  - Autoload configuration
- You SHOULD present your scope analysis to the user before deep analysis
- You MUST NOT limit your search to only the files the user mentions because bugs often originate in unexpected places

**Godot scope mapping process:**
1. Start with the symptom location (node/scene where bug appears)
2. Check the script attached to that node
3. Trace parent nodes up the scene tree
4. Check autoloads that the script references
5. Check signals connected to/from this node
6. Examine resources loaded by the scene
7. Check inherited scenes if using scene inheritance
8. Review project.godot for relevant settings

**Common Godot bug sources:**
- Autoload initialization order
- Node ready order (_ready called before children are ready)
- Signal connection timing
- Resource preloading vs loading
- Export variable initialization
- Tool scripts affecting editor
- Physics layers and masks
- Input action configuration

**Output:**
- List of Godot systems potentially involved
- List of files to analyze (scripts, scenes, resources)
- Scene tree hierarchy map if relevant
- Signal connection diagram if relevant

### 3. Comprehensive Code Analysis

Analyze ALL relevant GDScript, scenes, and resources before proposing any fix.

**Constraints:**
- You MUST read every file identified in scope
- You MUST trace the execution flow from trigger to symptom
- You MUST examine Godot-specific patterns:
  - Node lifecycle methods (_init, _ready, _enter_tree, _exit_tree)
  - Process methods (_process, _physics_process, _input, _unhandled_input)
  - Signal declarations and connections (both code and editor-connected)
  - Export variables and their initialization
  - Onready variables and their timing
  - Preload vs load usage
  - Resource instance vs shared reference issues
  - await usage and coroutine flow
  - Type hints and static typing
- You MUST look for common GDScript issues:
  - Accessing nodes before _ready() completes
  - Using $ paths to nodes that don't exist
  - Signal connected to non-existent method
  - Wrong signal parameter count
  - Null reference from get_node() failure
  - Incorrect await usage (await without signal/coroutine)
  - Type mismatches with static typing
  - Resource path typos
  - Circular dependencies
  - Missing call to super._ready() in inherited scripts
  - Incorrect use of call_deferred vs direct calls
  - Physics vs idle process confusion
  - Input action name mismatches
- You MUST check scene files for:
  - Missing node references
  - Broken external resources
  - Inherited scene conflicts
  - Incorrect node types
  - Missing script attachments
  - Signal connections in the editor
- You MUST NOT propose fixes during this phase because premature solutions often miss the root cause
- You MUST document your findings as you analyze

**Analysis checklist:**
- [ ] Read all potentially affected .gd scripts
- [ ] Examined all relevant .tscn scene files
- [ ] Checked .tres resource files
- [ ] Traced execution flow from _ready() through bug
- [ ] Verified signal connections (code and editor)
- [ ] Checked autoload dependencies
- [ ] Examined node lifecycle timing
- [ ] Looked for common GDScript pitfalls
- [ ] Reviewed project.godot settings

**Output:**
- Detailed notes on each analyzed file
- Execution flow trace through Godot lifecycle
- List of suspicious code sections

### 4. Root Cause Identification

Determine the exact cause of the bug based on analysis.

**Constraints:**
- You MUST identify the specific line(s) of code causing the issue
- You MUST explain the chain of causation in Godot terms:
  - What game state or player action triggers the bug
  - What Godot lifecycle stage is involved
  - Why the current code produces incorrect behavior
- You MUST distinguish between:
  - Root cause (the fundamental issue)
  - Symptoms (observable effects)
  - Contributing factors (conditions that enable the bug)
- You MUST be able to explain WHY the bug happens using Godot concepts
- You MUST provide evidence from the code to support your diagnosis
- You SHOULD consider if there are multiple contributing causes
- You MUST NOT guess - if you're uncertain, note what additional information would help

**Common Godot root cause categories:**

- **Lifecycle Timing Error**:
  - Accessing @onready vars in _init()
  - Assuming children exist before _ready()
  - Signal connected before node is ready
  - Using await incorrectly with node lifecycle

- **Scene Tree Error**:
  - Node path incorrect or node renamed
  - get_node() returning null
  - Node not in tree when accessed
  - Freed node still referenced

- **Signal Error**:
  - Signal connected to wrong method
  - Signal parameter mismatch
  - Signal not connected
  - Signal emitted at wrong time

- **Resource Error**:
  - Resource not preloaded (causes stutter)
  - Shared resource modified (affects all instances)
  - Resource path incorrect
  - Resource type mismatch

- **Physics Error**:
  - Using _process() instead of _physics_process()
  - Physics layers/masks misconfigured
  - move_and_slide() issues
  - Collision shape errors

- **Input Error**:
  - Input action not in project settings
  - Input action name typo
  - Input processed in wrong method
  - is_action_pressed vs is_action_just_pressed confusion

- **Type Error**:
  - Null reference (untyped variable)
  - Wrong type from get_node()
  - Array/Dictionary type issues
  - Static typing violation

**Output:**
- Specific identification of the root cause in Godot terms
- Evidence from code analysis
- Explanation of the causal chain through Godot's systems

### 5. User Explanation

Explain the bug to the user in clear, understandable terms using Godot concepts.

**Constraints:**
- You MUST explain the bug in plain language before showing code
- You MUST structure your explanation as:
  1. **What's happening**: The immediate cause of the symptom
  2. **Why it's happening**: The root cause in Godot terms
  3. **Where it's happening**: The specific location in code
- You MUST explain Godot concepts if the user might not know them:
  - Node lifecycle and _ready() order
  - Signal system
  - Scene tree structure
  - Resource vs instance distinction
- You MUST show the relevant code snippet with the problem highlighted
- You MUST NOT use jargon without explanation
- You SHOULD use Godot documentation references when helpful
- You SHOULD explain the "Godot way" of solving this type of problem

**Explanation template:**
```
## What's Causing the Bug

[Plain language explanation of the immediate cause]

## Why This Happens (Godot Context)

[Root cause explanation with Godot-specific context about how the engine works]

## Where in the Code

[Code snippet with problem area highlighted and explanation]
```

**Output:**
- Clear, user-friendly explanation of the bug
- Godot-specific context
- Code snippets with annotations
- User confirmation they understand the issue

### 6. Fix Options Generation

Generate multiple Godot-native fix options with different tradeoffs.

**Constraints:**
- You MUST provide at least 2 fix options when possible
- You MUST prefer Godot-native solutions over workarounds
- Each fix option MUST include:
  - **Name**: A short descriptive name
  - **Approach**: What the fix does (using Godot patterns)
  - **Code Changes**: Specific GDScript changes required
  - **Pros**: Benefits of this approach
  - **Cons**: Drawbacks or risks
  - **Complexity**: Low/Medium/High
  - **Risk Level**: Low/Medium/High
  - **Godot Best Practice**: Whether this follows Godot conventions
- You MUST order options from simplest to most comprehensive
- You SHOULD include:
  - A minimal fix (smallest change that fixes the bug)
  - A Godot-idiomatic fix (follows engine best practices)
  - A robust fix (adds safeguards against similar bugs)
- You MUST use Godot-native patterns:
  - Signals over direct references where appropriate
  - @onready over get_node() in _ready()
  - Type hints for safety
  - call_deferred() for timing issues
  - await for proper coroutine handling
  - Groups for loose coupling
  - Resources for shared data
- You MUST NOT recommend anti-patterns:
  - Polling when signals would work
  - Global state when signals/resources would work
  - String paths when NodePaths or exports would work
  - Hard-coded values when exports would work
- You SHOULD note if a fix is a "band-aid" vs a proper Godot solution

**Godot-native fix patterns:**
- **Use signals**: Decouple systems, proper event handling
- **Use @onready**: Ensure node references are valid
- **Use @export**: Make dependencies explicit and editor-configurable
- **Use call_deferred()**: Fix timing issues properly
- **Use await signals**: Handle async operations correctly
- **Use type hints**: Catch errors at runtime/editor time
- **Use groups**: Find nodes without hard-coded paths
- **Use resources**: Share data properly between instances
- **Use is_instance_valid()**: Check freed nodes safely

**Output:**
- Multiple Godot-native fix options with full details
- Clear recommendation with reasoning
- Note on which option best follows Godot conventions

### 7. Fix Selection and Planning

Help the user choose the appropriate fix.

**Constraints:**
- You MUST present all options clearly and let the user decide
- You MUST make a recommendation with clear reasoning
- You MUST explain which option best follows Godot best practices
- You SHOULD ask questions to help the user decide:
  - "How critical is this bug?"
  - "Do you want the quick fix or the Godot-idiomatic fix?"
  - "Is this area of code likely to be modified soon?"
- You MUST NOT implement a fix without user approval
- You MUST confirm the user's choice before proceeding
- You SHOULD offer to implement the fix or just provide the code

**Decision factors to discuss:**
- Urgency (is the game unplayable?)
- Godot best practices (is it worth refactoring?)
- Time available (quick patch vs proper solution?)
- Learning opportunity (does user want to understand the pattern?)

**Output:**
- User's selected fix option
- Confirmation to proceed with implementation

### 8. Fix Implementation

Implement the chosen fix using Godot best practices.

**Constraints:**
- You MUST implement exactly the fix that was approved
- You MUST follow GDScript style conventions:
  - snake_case for variables and functions
  - PascalCase for classes and nodes
  - SCREAMING_CASE for constants
  - Proper indentation with tabs
  - Type hints where appropriate
- You MUST use Godot-native patterns:
  - @onready for node references
  - @export for configurable values
  - Signals for events
  - await for coroutines
- You MUST make minimal changes beyond what's needed for the fix
- You MUST NOT refactor unrelated code while fixing the bug because this increases risk and makes review harder
- You MUST add comments explaining the fix if the issue was subtle
- You SHOULD add defensive code using Godot patterns:
  - is_instance_valid() checks
  - Type hints
  - Null checks with is_same() or != null
- You MUST verify the fix by:
  - Checking for GDScript syntax errors
  - Walking through the execution path mentally
  - Confirming the fix addresses the root cause
- You SHOULD suggest how the user can test the fix in Godot
- You MUST present all changes for user review before considering done

**Implementation checklist:**
- [ ] Made only the approved changes
- [ ] Follows GDScript style conventions
- [ ] Uses Godot-native patterns
- [ ] No syntax errors
- [ ] Added explanatory comments if needed
- [ ] Verified logic addresses root cause
- [ ] No unintended side effects

**Output:**
- Implemented fix with all changes shown
- Instructions for testing in Godot
- Request for user verification

### 9. Verification and Closure

Confirm the fix works and document if needed.

**Constraints:**
- You MUST ask the user to test the fix in Godot
- You MUST ask them to check:
  - The bug is resolved
  - No new errors in the console
  - No new warnings introduced
  - Game still runs correctly
- If the bug persists:
  - You MUST return to Step 3 (Code Analysis) with new information
  - You MUST NOT abandon the process because partial fixes often reveal deeper issues
- If the fix introduced new issues:
  - You MUST address them before closing
  - You MAY suggest reverting if the new issues are severe
- You SHOULD offer to document the bug and fix for future reference
- You MAY create `context/bugs/{bug-name}/analysis.md` for complex bugs

**If bug is fixed:**
- Confirm with user
- Offer to document the fix
- Suggest any preventive Godot patterns for similar bugs

**If bug persists:**
- Gather new Godot console output
- Return to analysis phase
- Consider alternative hypotheses

**Output:**
- Confirmation that bug is fixed
- Optional documentation
- Closure of bug fix process

## Examples

### Example 1: Node Lifecycle Bug

**User Input:**
```
bug_report: "Getting 'Invalid get index 'position' (on base: 'null instance')' when the player spawns"
```

**Process:**

1. **Intake** clarifies:
   - Expected: Player spawns at spawn point
   - Actual: Crash with null error
   - Console shows error in player.gd line 15
   - Happens every time on scene load

2. **Scope Identification** finds:
   - player.gd
   - player.tscn
   - level.tscn (parent scene)
   - spawn_point node

3. **Code Analysis** discovers:
   ```gdscript
   # player.gd
   @onready var spawn_point = get_parent().get_node("SpawnPoint")

   func _init():
       position = spawn_point.position  # Line 15 - ERROR HERE
   ```

4. **Root Cause**:
   - `_init()` runs before the node is in the scene tree
   - `@onready` vars aren't set until `_ready()`
   - Accessing `spawn_point` in `_init()` returns null

5. **User Explanation**:
   ```
   ## What's Causing the Bug

   You're trying to use `spawn_point` in `_init()`, but it hasn't been set yet.

   ## Why This Happens (Godot Context)

   In Godot, there's a specific order to when things happen:
   1. `_init()` - Object is created, but NOT in the scene tree yet
   2. Node is added to tree
   3. `@onready` variables are set
   4. `_ready()` is called

   Your `@onready var spawn_point` doesn't have a value during `_init()` because
   the node isn't even in the scene tree yet. It's null.

   ## Where in the Code

   player.gd, line 15:
   ```gdscript
   func _init():
       position = spawn_point.position  # spawn_point is null here!
   ```
   ```

6. **Fix Options**:

   **Option A: Move to _ready() (Recommended)**
   - Approach: Set position in _ready() where @onready vars are valid
   - Code:
     ```gdscript
     func _ready():
         position = spawn_point.position
     ```
   - Pros: Follows Godot lifecycle, simple fix
   - Cons: None
   - Complexity: Low
   - Risk: Low
   - Godot Best Practice: Yes

   **Option B: Use @export and set in editor**
   - Approach: Export spawn position, set in editor
   - Code:
     ```gdscript
     @export var spawn_position: Vector2

     func _ready():
         position = spawn_position
     ```
   - Pros: More flexible, editor-configurable
   - Cons: Requires updating scene
   - Complexity: Low
   - Risk: Low
   - Godot Best Practice: Yes

7. User chooses **Option A**

8. **Implementation**:
   ```gdscript
   # player.gd
   @onready var spawn_point = get_parent().get_node("SpawnPoint")

   func _ready():
       position = spawn_point.position
   ```

9. **Verification**: User tests, player spawns correctly.

### Example 2: Signal Connection Bug

**User Input:**
```
bug_report: "Enemy death doesn't update the score. No errors in console."
```

**Process:**

1. **Intake** reveals:
   - Expected: Killing enemy adds to score
   - Actual: Score stays at 0
   - No console errors or warnings
   - Used to work before refactoring

2. **Scope** maps:
   - enemy.gd (emits death signal)
   - game_manager.gd (autoload, tracks score)
   - hud.gd (displays score)

3. **Code Analysis** finds:
   ```gdscript
   # enemy.gd
   signal died(points)

   func take_damage(amount):
       health -= amount
       if health <= 0:
           died.emit(point_value)  # Signal emitted correctly
           queue_free()
   ```

   ```gdscript
   # game_manager.gd (autoload)
   var score: int = 0

   func _on_enemy_died(points):  # Method exists
       score += points
   ```

   But no signal connection found! The old code had:
   ```gdscript
   # Was in enemy.gd _ready(), now missing
   # died.connect(GameManager._on_enemy_died)
   ```

4. **Root Cause**:
   - Signal `died` is never connected to `GameManager._on_enemy_died`
   - The connection line was removed during refactoring
   - Signals don't error when emitted with no connections

5. **User Explanation** shows signal flow diagram and explains silent failure.

6. **Fix Options**:

   **Option A: Connect in enemy _ready()**
   - Code: `died.connect(GameManager._on_enemy_died)`
   - Pros: Quick fix
   - Cons: Enemy knows about GameManager (coupling)
   - Godot Best Practice: Acceptable but not ideal

   **Option B: Use groups (Recommended)**
   - GameManager finds all enemies and connects on spawn
   - Or enemy uses group signal pattern
   - Pros: Loose coupling, Godot-native pattern
   - Cons: More code
   - Godot Best Practice: Yes

   **Option C: Use child_entered_tree signal**
   - GameManager listens for new enemies and auto-connects
   - Pros: Automatic, handles spawned enemies
   - Cons: More complex
   - Godot Best Practice: Yes

7. User chooses **Option B** with group pattern.

8. **Implementation**: Enemy calls `get_tree().call_group("score_managers", "add_score", point_value)`

9. **Verification**: Score updates on enemy death.

## Troubleshooting

### Can't Reproduce the Bug
If the bug can't be reproduced:
- Check if it's specific to exported builds vs editor
- Check if it's specific to certain Godot versions
- Add `print()` statements to trace execution
- Use Godot's debugger to step through code
- Check if it's related to scene loading order

### Bug Only in Exported Build
If the bug only appears in exports:
- Check for case-sensitive file paths (Linux exports)
- Verify all resources are included in export
- Check for debug-only code (`if OS.is_debug_build()`)
- Look for editor-only tool scripts

### Intermittent Bugs
If the bug is inconsistent:
- Likely a timing/race condition
- Check for `await` usage issues
- Look for physics vs process frame issues
- Check signal connection timing
- Consider using `call_deferred()`

### Console Shows Warnings but No Errors
If there are only warnings:
- Warnings often indicate the root cause
- Check for orphan nodes (memory leaks)
- Look for deprecated API usage
- Check for missing resources

### Bug is in Godot Engine
If you suspect an engine bug:
- Check Godot GitHub issues
- Test with minimal reproduction project
- Document workaround in code
- Note Godot version for future reference
