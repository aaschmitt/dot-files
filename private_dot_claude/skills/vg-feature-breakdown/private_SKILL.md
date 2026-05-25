---
name: vg-feature-breakdown
description: This SOP guides you through transforming a rough video game feature idea into fully documented, implementable specifications. It follows a structured documentation flow (Concepts → Mechanics → Requirements → Implementation Plan → Phase Breakdown → Spec Breakdown) that separates game design concerns from technical concerns, ensuring both are properly addressed before implementation begins.
type: anthropic-skill
version: "1.0"
---

# Feature Implementation SOP

## Overview

This SOP guides agents through the process of transforming a rough feature idea into fully documented, implementable specifications for video game development. It follows a structured documentation flow: Concepts → Mechanics → Requirements → Implementation Plan → Phase Breakdown → Spec Breakdown.

The workflow separates game design concerns (what the feature does for players) from technical concerns (how to build it), ensuring both are properly addressed before implementation begins.

Use this SOP when:
- The user has a new feature idea to implement
- An existing feature needs significant expansion
- A rough concept needs to be formalized into implementation-ready specifications

## Technical Design Philosophy

This SOP targets **Godot 4.x** projects using **GDScript**. All implementation planning and specifications MUST adhere to these principles:

### Code Quality Standards
- **Strongly Typed GDScript**: ALL code MUST use explicit type hints for variables, parameters, and return types. No untyped code.
- **Clean & Modular**: Scripts should have single responsibilities. Prefer small, focused scripts over monolithic ones.
- **Reusable by Design**: Write code anticipating reuse. If a pattern appears twice, it should be abstracted.

### Architectural Preferences
- **Data-Driven / Resource-Based Systems**: Favor Godot Resources (.tres) for defining entity types, configurations, items, abilities, and behaviors. Data lives in resources, logic lives in scripts.
- **Composition Over Inheritance**: Build behavior through component nodes and composition rather than deep inheritance hierarchies. Prefer small, focused components that can be mixed and matched. If you're tempted to create a class hierarchy, consider whether components attached to a base node would be more flexible.
- **Unified Systems**: When implementing new features, actively look for opportunities to unify with existing patterns. Avoid one-off solutions when a general system serves better.
- **Godot-Native First**: Leverage built-in Godot features (signals, groups, resources, @export, @onready, built-in nodes) before creating custom solutions.

### Dependency Configuration
- **Editor-Based Dependencies (REQUIRED)**: Configure node references through `@export` and `@onready` with editor assignment. NEVER use hardcoded relative paths.
- **Why This Matters**: Hardcoded paths like `$"../Sibling/Child"` or `get_node("../Path")` break when:
  - Nodes are renamed
  - Scene structure changes
  - Components are reused in different contexts
  - Scenes are instantiated dynamically
- **Acceptable Patterns**:
  - `@export var target: Node2D` - Assign in editor, works across any structure
  - `@onready var _sprite: Sprite2D = $Sprite2D` - Direct children only, owned by this scene
  - `get_tree().get_nodes_in_group("enemies")` - Group-based lookup
  - Signals for loose coupling between unrelated nodes
- **Forbidden Patterns**:
  - `$"../Sibling"` - Relative paths to siblings/parents
  - `get_node("../../Manager/Child")` - Path traversal
  - `get_parent().get_parent().some_method()` - Parent chain walking
  - Any path containing `..`

### Proactive Abstraction
- **Identify Abstraction Opportunities**: During implementation planning, actively identify when:
  - Multiple features share a common pattern that could be generalized
  - A specific implementation is really a special case of a broader system
  - Existing systems could be extended rather than new systems created
  - Code could be structured to enable future extensibility
- **Document Abstractions**: When an abstraction opportunity is identified, document it clearly even if not implemented immediately. Flag it for future consideration.

### Code Patterns to Prefer
```gdscript
# ============================================
# PREFER: Composition, editor-configured, typed
# ============================================
class_name HealthComponent
extends Node

signal died
signal health_changed(new_health: int, max_health: int)

@export var max_health: int = 100
@export var damageable_area: Area2D  # Editor-assigned reference

var _current_health: int

func _ready() -> void:
    _current_health = max_health
    if damageable_area:
        damageable_area.area_entered.connect(_on_area_entered)

func take_damage(amount: int) -> void:
    _current_health = maxi(0, _current_health - amount)
    health_changed.emit(_current_health, max_health)
    if _current_health == 0:
        died.emit()

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("hitboxes"):
        var damage: int = area.get_meta("damage", 10)
        take_damage(damage)


# ============================================
# AVOID: Inheritance-heavy, path-dependent, untyped
# ============================================
class_name Enemy extends CharacterBody2D  # Deep inheritance instead of composition

func take_damage(amount):  # No type hints
    health -= amount
    $"../UI/HealthBar".update_display()  # Hardcoded path - BREAKS EASILY
    get_parent().get_node("GameManager").on_enemy_hit()  # Parent chain walking

    if health <= 0:
        $"../../SpawnManager".enemy_died(self)  # More path dependency
```

## Parameters

- **feature_idea** (required): The initial feature concept or idea to be developed. Can be provided as text, a file path, or a URL.
- **feature_name** (required): A short, descriptive name for the feature (used for folder naming).

**Constraints for parameter acquisition:**
- You MUST ask for all required parameters upfront in a single prompt rather than one at a time
- You MUST support multiple input methods including:
  - Direct input: Text provided directly in the conversation
  - File path: Path to a local file containing the idea
  - URL: Link to a resource describing the feature
- You MUST confirm successful acquisition of all parameters before proceeding
- You MUST use kebab-case for feature_name (e.g., "grid-layout", "auto-transport")

## Output Structure

All outputs for a feature are organized under a single feature folder, except for project-scope files:

```
context/
├── concepts.md                    # Project-scope terminology (updated, not created per feature)
└── features/
    └── {feature-name}/
        ├── rough-idea.md              # Initial idea capture
        ├── mechanics.md               # Gameplay mechanics breakdown
        ├── requirements.md            # Implementation constraints
        ├── implementation.md          # Technical approach and overview
        └── phases/
            ├── phase-1/
            │   ├── phase-1.md         # Phase 1 implementation plan
            │   └── specs/
            │       ├── step-1.spec.md
            │       ├── step-2.spec.md
            │       └── ...
            ├── phase-2/
            │   ├── phase-2.md
            │   └── specs/
            │       └── ...
            └── ...
```

## Steps

### 1. Idea Honing

Capture and refine the feature idea by grounding it in existing project concepts and design principles. The Claude session will bring necessary context files into scope automatically.

**Constraints:**
- You MUST save the initial idea to `context/features/{feature-name}/rough-idea.md`
- You MUST evaluate the idea against these questions:
  - What existing systems does this touch?
  - How does it fit the game's core loop?
  - Does it align with the project's design vision and principles?
  - What existing terminology applies?
- You MUST document any ambiguities or design decisions that need clarification
- You SHOULD ask the user clarifying questions if the idea is underspecified
- You MUST NOT proceed to mechanics until the idea is sufficiently refined because incomplete ideas lead to scope creep and rework

**Output:**
- `context/features/{feature-name}/rough-idea.md` containing:
  - Original idea
  - Refined understanding of the feature scope
  - List of existing systems affected
  - List of questions answered or assumptions made

**Example questions for Brew.io:**
- How does it fit the core loop (BUY → WAVE → RESULTS)?
- Does it align with the design vision (cozy automation, throughput over stress)?

### 2. New Concepts

Identify and define any new terminology introduced by the feature.

**Constraints:**
- You MUST identify any new systems, states, objects, or terms the feature introduces
- You MUST check if each term already exists in `context/concepts.md`
- For new terms, you MUST provide:
  - Clear definition
  - Relationship to existing concepts
  - Examples of usage
- You MUST update `context/concepts.md` with new definitions
- You MUST NOT use ambiguous or overloaded terminology because it causes confusion in later implementation steps
- You MAY create the `context/concepts.md` file if it does not exist

**Output:**
- Updated `context/concepts.md` with new terminology (project-scope file)

### 3. New Mechanics

Define what the feature does from a gameplay perspective.

**Constraints:**
- You MUST describe each new mechanic using this format:

| # | Mechanic | Complexity | Description |
|---|----------|------------|-------------|
| X.X | [Name] | L/M/H | [What it does] |

- You MUST assess complexity as:
  - **L (Low)**: Simple, isolated, minimal dependencies
  - **M (Medium)**: Some integration, moderate complexity
  - **H (High)**: Complex logic, many dependencies, or new patterns
- You MUST describe how new mechanics interact with existing mechanics
- You MUST save output to `context/features/{feature-name}/mechanics.md`
- You SHOULD organize mechanics by sub-feature or system
- You SHOULD include a summary table with complexity breakdown

**Output:**
- `context/features/{feature-name}/mechanics.md`

### 4. Requirements

Specify constraints and rules the implementation must follow.

**Constraints:**
- You MUST document:
  - Functional requirements (what it MUST do)
  - Edge cases and validation rules
  - Integration requirements with existing systems
  - Performance considerations (if applicable)
- You MUST use RFC2119 keywords (MUST, SHOULD, MAY) for clarity
- You MUST save output to `context/features/{feature-name}/requirements.md`
- You SHOULD organize requirements by mechanic or system
- You MUST NOT leave requirements ambiguous because ambiguity leads to implementation bugs and rework

**Output:**
- `context/features/{feature-name}/requirements.md`

### 5. Implementation Planning

Define the technical approach, architecture, and dependencies following the Technical Design Philosophy.

**Constraints:**
- You MUST document:
  - Files to create (with proposed paths)
  - Files to modify (with description of changes)
  - Dependencies between components
  - Parallelization opportunities
  - Critical decision points
- You MUST consider existing project patterns and conventions
- You MUST identify any new autoloads, resources, or scenes needed
- You MUST save output to `context/features/{feature-name}/implementation.md`
- You SHOULD include a dependency graph showing relationships between components
- You SHOULD identify which steps can be parallelized for efficiency

**Architecture Analysis (REQUIRED):**
- You MUST perform a **Resource Pattern Analysis**:
  - Identify all data that should be defined in Resources (.tres files)
  - Define Resource class structures (properties, types)
  - Explain how resources will be referenced and loaded
- You MUST perform an **Abstraction Opportunity Analysis**:
  - Review existing codebase for patterns this feature could extend
  - Identify if this feature introduces a pattern that should be generalized
  - Flag any "code smell" where a one-off solution could be a reusable system
  - Document abstraction opportunities even if deferred to future work
- You MUST perform a **System Unification Check**:
  - List existing systems this feature touches
  - Evaluate: Can this feature use/extend existing systems rather than creating new ones?
  - If creating new systems, explain why existing systems don't fit
- You MUST verify **Godot-Native Usage**:
  - List Godot built-in features that will be leveraged (signals, groups, built-in nodes, etc.)
  - Justify any custom solutions over built-in alternatives

**Output:**
- `context/features/{feature-name}/implementation.md` containing:
  - File manifest (creates/modifies)
  - Resource definitions (all Resource classes with typed properties)
  - Abstraction opportunities (identified and documented)
  - System integration notes
  - Dependency graph
  - Phase overview

### 6. Phase Breakdown

Split the implementation into logical phases if the feature is large.

If the feature is small (fewer than 10 steps), create a single phase. Otherwise, group into multiple phases.

**Constraints:**
- You MUST group related steps into phases
- Each phase MUST be independently testable
- You MUST order phases by dependency (foundational first)
- You MUST create a folder for each phase: `context/features/{feature-name}/phases/phase-N/`
- You MUST create a phase plan file: `context/features/{feature-name}/phases/phase-N/phase-N.md`
- You SHOULD aim for 3-5 phases for large features
- You SHOULD name phases descriptively (e.g., "Phase 1: Core Grid System")
- You MUST NOT create phases with circular dependencies because this makes implementation impossible

**Output:**
- `context/features/{feature-name}/phases/phase-1/phase-1.md`
- `context/features/{feature-name}/phases/phase-2/phase-2.md` (if applicable)
- etc.

### 7. Spec Breakdown

Create detailed specifications for each implementation step within each phase. These specs are designed for low-level agent work and MUST enforce the Technical Design Philosophy.

**Constraints:**
- You MUST create a specs folder for each phase: `context/features/{feature-name}/phases/phase-N/specs/`
- You MUST create one spec file per step: `context/features/{feature-name}/phases/phase-N/specs/step-N.spec.md`
- Each spec MUST include:
  - **Creates**: Files created in this step
  - **Updates**: Files modified in this step
  - **Dependencies**: Previous steps this depends on
  - **Description**: What the step accomplishes
  - **Code Structure**: Key classes, methods, signals
  - **Verification**: How to verify the step is complete
- You MUST ensure steps are small enough to complete in one session
- You MUST ensure steps are large enough to be meaningful
- You SHOULD include code snippets or pseudocode for complex logic
- You MUST NOT include implementation details that belong in a different step because this causes confusion about what to implement when

**Code Quality Requirements (MANDATORY for all specs):**
- All code structures MUST show **fully typed signatures**:
  ```gdscript
  # REQUIRED format for method signatures
  func method_name(param: Type, param2: Type = default) -> ReturnType:

  # REQUIRED format for variables
  var my_var: Type = value
  @export var config: ResourceType
  ```
- All specs MUST specify:
  - **Signals** with typed parameters: `signal my_signal(data: Type)`
  - **Exported properties** with types: `@export var speed: float = 100.0`
  - **Resource references** with explicit types: `@export var item_data: ItemResource`
- When creating new scripts, specs MUST include:
  - `class_name` declaration
  - `extends` declaration
  - All public method signatures (fully typed)
  - All signals with typed parameters
  - All exported properties with types and defaults
- When defining Resource classes, specs MUST include:
  - Complete property list with types
  - Any custom methods with signatures
  - Example .tres structure showing expected data

**Modularity Requirements:**
- Specs MUST identify if the step creates **reusable components** vs **feature-specific code**
- Reusable components MUST be placed in appropriate shared directories (e.g., `scripts/components/`)
- Specs SHOULD note when code could be generalized in a future refactor

**Composition & Dependency Requirements:**
- Specs MUST favor **composition over inheritance**:
  - Default to components attached to nodes, not class hierarchies
  - If inheritance is used, justify why composition wouldn't work
  - Inheritance depth should rarely exceed 2 levels (Base -> Specific)
- Specs MUST use **editor-based dependency configuration**:
  - All external node references via `@export var ref: NodeType`
  - Direct children only via `@onready var child: Type = $ChildName`
  - Cross-scene communication via signals or groups
- Specs MUST NOT contain:
  - Any `$".."` paths (parent/sibling traversal)
  - Any `get_node()` with paths containing `..`
  - Any `get_parent().get_parent()` chains
  - Any assumptions about scene tree structure outside owned nodes

**Spec file format:**
```markdown
# Phase {N} - Step {M}: {Step Name}

## Overview
{Brief description of what this step accomplishes}

## Scope
- [ ] Reusable Component (place in shared directory)
- [ ] Feature-Specific Code

## Creates
- `{file_path}` - {description}

## Updates
- `{file_path}` - {description of changes}

## Dependencies
- Step {M-1}: {dependency description}

## Implementation Details

### Code Structure

#### {ClassName} (`path/to/script.gd`)
```gdscript
class_name ClassName
extends BaseClass

signal something_happened(data: DataType)

@export var config: ConfigResource
@export var speed: float = 100.0

var _internal_state: StateType

func public_method(param: ParamType) -> ReturnType:
    pass

func _private_helper() -> void:
    pass
```

### Resource Definitions (if applicable)

#### {ResourceName} (`path/to/resource.gd`)
```gdscript
class_name ResourceName
extends Resource

@export var property_one: String = ""
@export var property_two: int = 0
@export var nested_data: Array[OtherResource] = []
```

Example `.tres`:
```
[gd_resource type="Resource" script_ext_type="ResourceName"]
[resource]
property_one = "example"
property_two = 42
```

## Godot-Native Features Used
- {List signals, groups, built-in nodes, etc. leveraged in this step}

## Abstraction Notes
- {Any opportunities for future generalization identified during this step}

## Verification
- [ ] {Testable verification criterion}
- [ ] All code is strongly typed (no untyped variables or parameters)
- [ ] No hardcoded paths (no `$".."`, no `get_node("..")`, no parent chain walking)
- [ ] Dependencies configured via @export or direct children only
- [ ] Composition used over inheritance where applicable
- [ ] {Another criterion}
```

**Output:**
- `context/features/{feature-name}/phases/phase-N/specs/step-1.spec.md`
- `context/features/{feature-name}/phases/phase-N/specs/step-2.spec.md`
- etc.

### 8. Final Review

Review all generated documentation for completeness and consistency.

**Constraints:**
- You MUST verify all files were created successfully
- You MUST check for consistency across documents:
  - Terminology matches concepts.md
  - Mechanic numbers are consistent
  - Dependencies are correctly specified
- You MUST present a summary to the user including:
  - Files created
  - Total mechanics count and complexity breakdown
  - Number of phases and steps
  - Any open questions or decisions needed
- You SHOULD ask the user if any adjustments are needed before implementation begins

**Output:**
- Summary report presented to user

## Examples

### Example Input

```
feature_idea: "I want to add a garbage can that lets players throw away items they're carrying"
feature_name: "garbage-can"
```

### Example Output Structure

```
context/
├── concepts.md                         # Updated with "garbage can" definition
└── features/
    └── garbage-can/
        ├── rough-idea.md                   # Initial idea capture
        ├── mechanics.md                    # Mechanics breakdown
        ├── requirements.md                 # Implementation constraints
        ├── implementation.md               # Technical overview
        └── phases/
            └── phase-1/
                ├── phase-1.md              # Phase plan
                └── specs/
                    ├── step-1.spec.md      # Block Resource
                    ├── step-2.spec.md      # Garbage Can Scene
                    └── step-3.spec.md      # Integration
```

### Example Mechanics Output

```markdown
# Garbage Can - Mechanics Breakdown

## Feature: Item Disposal

| # | Mechanic | Complexity | Description |
|---|----------|------------|-------------|
| 15.1 | Garbage Can Block | L | Floor item that can be placed on empty floor tiles |
| 15.2 | Item Disposal | L | Player interacts with garbage can while carrying item to destroy it |
| 15.3 | Disposal Confirmation | L | Optional confirmation before destroying valuable items |

## Summary

| Feature | Count | Complexity Breakdown |
|---------|-------|---------------------|
| Item Disposal | 3 | 3L |
```

## Troubleshooting

### Unclear Feature Scope
If the feature idea is too vague to proceed, ask specific questions:
- "What problem does this solve for the player?"
- "When in the game loop does this happen?"
- "What existing features does this interact with?"

### Conflicting Requirements
If requirements conflict with design principles, flag the conflict and ask the user to decide:
- Document both options
- Explain the tradeoffs
- Recommend the option that best aligns with design vision

### Large Feature Overwhelm
If a feature seems too large:
- Consider splitting into multiple independent features
- Identify a minimal viable version for the first implementation
- Defer "nice to have" mechanics to future iterations
