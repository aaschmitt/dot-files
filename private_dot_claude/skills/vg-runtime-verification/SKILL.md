---
name: vg-runtime-verification
description: This SOP guides you through verifying that an implemented feature runs correctly in Godot. It validates scene loading, script compilation, and runtime behavior by running headless tests and analyzing output for errors, warnings, and test failures. Use after completing implementation from vg-feature-breakdown.
type: anthropic-skill
version: "1.0"
---

# Runtime Verification SOP

## Overview

This SOP guides agents through the process of verifying that a newly implemented feature works correctly at runtime. It uses **isolated test scenes** to validate behavior independently from the main game, ensuring reliable and reproducible verification.

It validates that:

1. All scripts compile without errors
2. Test scenes load successfully in isolation
3. Runtime tests pass (properties, signals, state)
4. No warnings indicate potential issues

Use this SOP when:
- A feature implementation from vg-feature-breakdown is complete (verifies all phases automatically)
- You need to verify scripts compile and scenes run
- You want to validate runtime behavior matches specifications
- Debugging runtime failures after implementation

## Test Scene Architecture

This SOP uses **dedicated test scenes** rather than testing features in their production locations. This provides:

| Benefit | Why It Matters |
|---------|----------------|
| **Isolation** | Tests only what the spec describes, no interference from unrelated systems |
| **Reproducibility** | Controlled initial state, predictable behavior |
| **Manual Debugging** | Developers can open test scenes in editor to inspect behavior visually |
| **Stability** | Tests don't break when production scenes are reorganized |
| **Spec-Driven** | Scene structure mirrors exactly what the spec says should exist |

### Test Scene Location

All test scenes are stored in: `res://test-scenes/{feature-name}/`

```
res://test-scenes/
├── player-health/
│   ├── test_health_system.tscn      # Tests health component in isolation
│   └── test_damage_interactions.tscn
├── inventory-system/
│   ├── test_inventory_basic.tscn
│   └── test_item_stacking.tscn
└── grid-movement/
    └── test_grid_navigation.tscn
```

### Test Scene Structure

A test scene contains:
1. **Subject Under Test** - The component/node being verified (instanced or configured)
2. **Minimal Dependencies** - Only what's required for the component to function
3. **Known Initial State** - Properties set to spec-defined defaults
4. **Optional Test Harness** - UI elements for manual testing (labels showing state, buttons to trigger actions)

Example test scene structure:
```
TestPlayerHealth.tscn (Node2D)
├── Player (instanced from res://scenes/player/player.tscn)
├── TestHarness (Control) [optional, for manual runs]
│   ├── HealthLabel
│   ├── DamageButton
│   └── HealButton
└── TestConfig (Node) [optional, stores test parameters]
```

## Runtime Testing Context

This SOP uses the `runtime_test` addon for Godot. All test commands follow this pattern:

```bash
# Basic structure
{godot_path} --path {project_path} --headless {scene_path} -- {runtime_test_flags}
```

The `godot_path` and `project_path` values are defined in the project's CLAUDE.md file under "Running the Game" or "Runtime Testing" sections.

### Runtime Test Quick Reference

**Injection Commands:**
```bash
--set:Path:prop=value        # Set property
--call:Path:method:arg1      # Call method
--emit:Path:signal:arg1      # Emit signal
```

**Observation Commands:**
```bash
--print:Path:prop            # Print property once
--listen:Path:signal         # Capture signal emissions
--watchprop:Path:prop        # Print on property change
```

**Assertion Commands:**
```bash
--expect:Path:prop=value     # Assert property equals value
--expect-signal:Path:sig     # Assert signal was emitted
--expect-signal:Path:sig:a:b # Assert signal with specific args
--expect-no-signal:Path:sig  # Assert signal NOT emitted
```

**Control Commands:**
```bash
--wait:500                   # Wait 500ms
--wait-frames:10             # Wait 10 frames
--watch                      # Keep running, Q to quit
```

**Path Conventions:**
- `.` = scene root
- `Player` = direct child node
- `Player/Health` = nested path

**Output Markers:**
| Marker | Meaning |
|--------|---------|
| `[RT:OK]` | Operation succeeded |
| `[RT:ERR]` | Operation failed |
| `[RT:PASS]` | Assertion passed |
| `[RT:FAIL]` | Assertion failed |
| `[RT:SIGNAL]` | Signal captured |
| `[RT:RESULTS]` | Summary line |

**Exit Codes:**
- `0` = All assertions passed
- `1` = One or more assertions failed

## Parameters

- **feature_path** (required): Path to the feature's context folder (e.g., `context/features/grid-layout/`)

**Constraints for parameter acquisition:**
- You MUST infer `project_path` and `godot_path` from the project's CLAUDE.md file or current session context
- You MUST confirm successful acquisition of the feature_path before proceeding
- You MUST verify the feature_path exists and contains implementation specs
- You MUST automatically discover all phases in `{feature_path}/phases/` and verify each one

## Steps

### 1. Gather Implementation Context

Discover all phases and load implementation documentation to understand what was built.

**Constraints:**
- You MUST discover all phase directories in `{feature_path}/phases/`
- For each phase found, You MUST read:
  - The phase plan file: `{feature_path}/phases/phase-{N}/phase-{N}.md`
  - All spec files in: `{feature_path}/phases/phase-{N}/specs/`
- You MUST identify from specs across ALL phases:
  - All scenes created or modified
  - All scripts created or modified
  - Expected signals and their parameters
  - Verification criteria from each spec
- You MUST create a verification checklist from the spec verification sections
- You MUST process phases in order (phase-1 before phase-2, etc.) because later phases may depend on earlier ones
- You MUST NOT proceed without understanding what was implemented because blind testing wastes time and misses issues

**Output:**
- List of phases discovered
- Internal checklist per phase of:
  - Scenes to test
  - Scripts to verify compilation
  - Properties and signals to validate
  - Expected behaviors from specs

### 2. Acquire or Generate Test Scene

Search for existing test scenes or generate new ones for isolated verification.

**Constraints:**
- You MUST first search for existing test scenes in `res://test-scenes/{feature-name}/`
- You MUST derive `{feature-name}` from the feature_path (e.g., `context/features/player-health/` → `player-health`)
- If matching test scenes exist, You MUST reuse them rather than regenerating
- If no test scenes exist, You MUST generate them based on the specs

**Search Process:**
```bash
# Check if test-scenes directory exists for this feature
ls -la {project_path}/test-scenes/{feature-name}/ 2>/dev/null

# List any existing test scenes
find {project_path}/test-scenes/{feature-name}/ -name "*.tscn" 2>/dev/null
```

**When Reusing Existing Test Scenes:**
- You MUST verify the test scene still matches current spec requirements
- You MUST check that instanced components point to current production paths
- You SHOULD update test scenes if specs have changed significantly
- You MUST document which existing test scenes will be used

**When Generating New Test Scenes:**
- You MUST create the directory: `res://test-scenes/{feature-name}/`
- You MUST generate one test scene per major verification area from specs
- You MUST name test scenes descriptively: `test_{component}_{aspect}.tscn`
- You MUST include only minimal dependencies required for the component

**Test Scene Generation Template:**
```gdscript
# Generated test scene structure (as .tscn file)
[gd_scene load_steps=2 format=3]

[ext_resource type="PackedScene" path="res://path/to/component.tscn" id="1"]

[node name="TestRoot" type="Node2D"]

[node name="SubjectUnderTest" parent="." instance=ExtResource("1")]
# Set initial properties from spec defaults here

[node name="TestHarness" type="Control" parent="."]
# Optional: UI for manual testing
```

**Test Scene Requirements:**
1. **Subject Under Test**: Instance or recreate the component being verified
2. **Isolation**: No autoloads or managers unless explicitly required by spec
3. **Initial State**: Configure properties to match spec-defined defaults
4. **Accessibility**: All nodes that need testing must be accessible via node paths

**Naming Convention:**
| Spec Focus | Test Scene Name |
|------------|-----------------|
| Health component | `test_health_system.tscn` |
| Damage interactions | `test_damage_interactions.tscn` |
| Signal emissions | `test_{component}_signals.tscn` |
| State transitions | `test_{component}_states.tscn` |

**Output:**
- List of test scenes (existing or newly generated)
- Path to each test scene: `res://test-scenes/{feature-name}/{scene-name}.tscn`
- Confirmation that test scenes match current specs

### 3. Script Compilation Check

Verify all scripts compile without errors by running Godot in headless mode.

**Constraints:**
- You MUST run the project in headless mode to trigger script compilation:
  ```bash
  {godot_path} --path {project_path} --headless --quit 2>&1
  ```
- You MUST capture and analyze stderr output for:
  - `ERROR:` lines indicating compilation failures
  - `SCRIPT ERROR:` lines indicating GDScript errors
  - `Cannot load` errors indicating missing dependencies
  - Parse errors with line numbers
- You MUST categorize issues found:
  - **Blocking**: Compilation errors that prevent running
  - **Warning**: Non-fatal issues that should be addressed
- If blocking errors exist, You MUST stop and report them before proceeding because scenes cannot run with compilation errors
- You SHOULD grep for `error` case-insensitively to catch all error variants
- You MUST NOT ignore warnings because they often indicate bugs that manifest at runtime

**Example Commands:**
```bash
# Run compilation check
{godot_path} --path {project_path} --headless --quit 2>&1 | head -100

# Filter for errors specifically
{godot_path} --path {project_path} --headless --quit 2>&1 | grep -i "error\|cannot load\|failed"
```

**Output:**
- List of compilation errors (if any)
- List of warnings (if any)
- Pass/Fail status for compilation check

### 4. Test Scene Load Verification

Verify each test scene loads without runtime errors.

**Constraints:**
- For each test scene from Step 2, You MUST run:
  ```bash
  {godot_path} --path {project_path} --headless {test_scene_path} -- --wait:100 2>&1
  ```
- You MUST check output for:
  - `[RT:ERR]` markers from RuntimeTest
  - `ERROR:` lines from Godot
  - `Attempt to call` errors (method not found)
  - `Invalid get index` errors (property not found)
  - `Null instance` errors (missing node references)
- You MUST test scenes in dependency order (base test scenes before dependent ones)
- You MUST record which test scenes load successfully and which fail
- You MUST NOT skip test scenes even if they seem simple because simple scenes can have subtle issues
- If a test scene fails to load, check that instanced components exist at their expected paths

**Example Commands:**
```bash
# Load test scene and wait briefly
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- --wait:100 2>&1

# Filter runtime test output
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- --wait:100 2>&1 | grep "\[RT:"
```

**Output:**
- Per-test-scene load status (pass/fail)
- Error details for failed scenes

### 5. Property Verification

Verify exported properties and initial state match specifications.

**Constraints:**
- For each test scene, You MUST verify key properties from specs:
  ```bash
  {godot_path} --path {project_path} --headless {test_scene_path} -- \
    --print:SubjectUnderTest:property_name \
    --print:SubjectUnderTest/ChildNode:property_name
  ```
- You MUST compare printed values against spec expectations
- You MUST verify @export properties have expected default values
- You SHOULD test property setters work correctly:
  ```bash
  --set:SubjectUnderTest:property=value --expect:SubjectUnderTest:property=value
  ```
- You MUST NOT assume properties are correct without verification because specs may have been misimplemented
- Note: Use the node path within the test scene (e.g., `SubjectUnderTest` or whatever name was given to the instanced component)

**Example Commands:**
```bash
# Verify initial health property in test scene
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --print:Player:max_health \
  --print:Player:current_health \
  --expect:Player:current_health=100

# Verify property setter
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --set:Player:health=50 \
  --expect:Player:health=50
```

**Output:**
- Property verification results (expected vs actual)
- List of property mismatches

### 6. Signal Verification

Verify signals are emitted correctly when expected actions occur.

**Constraints:**
- You MUST listen for signals BEFORE triggering actions:
  ```bash
  --listen:SubjectUnderTest:signal_name --call:SubjectUnderTest:method --expect-signal:SubjectUnderTest:signal_name
  ```
- You MUST verify signal parameters match specifications
- You MUST test negative cases (signals that should NOT emit):
  ```bash
  --listen:Player:died --set:Player:health=100 --call:Player:take_damage:10 --expect-no-signal:Player:died
  ```
- You MUST wait appropriately for async signals:
  ```bash
  --listen:Player:animation_finished --call:Player:play_animation --wait:500 --expect-signal:Player:animation_finished
  ```
- Order matters: You MUST structure tests as: listen -> trigger -> wait (if needed) -> assert
- You MUST NOT trigger actions before listening because signals emitted before listening are not captured

**Example Commands:**
```bash
# Verify health_changed signal in test scene
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --listen:Player:health_changed \
  --call:Player:take_damage:30 \
  --expect-signal:Player:health_changed

# Verify death signal with lethal damage
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --listen:Player:died \
  --set:Player:health=50 \
  --call:Player:take_damage:100 \
  --expect-signal:Player:died
```

**Output:**
- Signal verification results
- List of signals that failed to emit as expected

### 7. Behavioral Verification

Run comprehensive tests based on spec verification criteria.

**Constraints:**
- You MUST create tests for each verification criterion in the specs
- You MUST test state transitions and method behaviors
- You MUST test edge cases identified in requirements:
  - Boundary values (0, max, negative)
  - Invalid inputs (null, wrong type)
  - Rapid repeated calls
- You SHOULD combine multiple assertions in single test runs for efficiency
- You MUST check exit codes to determine overall pass/fail:
  ```bash
  {godot_path} ... -- {tests} && echo "PASS" || echo "FAIL"
  ```
- You MUST NOT skip edge case testing because edge cases are where bugs hide
- Test scenes provide isolation, so edge cases can be tested without affecting other systems

**Example Commands:**
```bash
# Test damage system comprehensively in isolated test scene
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --listen:Player:health_changed \
  --listen:Player:died \
  --set:Player:max_health=100 \
  --set:Player:health=100 \
  --call:Player:take_damage:30 \
  --expect:Player:health=70 \
  --expect-signal:Player:health_changed \
  --call:Player:take_damage:100 \
  --expect:Player:health=0 \
  --expect-signal:Player:died

# Check exit code
echo "Exit code: $?"
```

**Output:**
- Comprehensive test results
- Pass/fail for each verification criterion

### 8. Error Resolution

Address any errors or failures discovered during verification.

**Constraints:**
- You MUST categorize issues by severity:
  - **Critical**: Compilation errors, test scene won't load
  - **Major**: Test assertions failing, incorrect behavior
  - **Minor**: Warnings, potential issues
- For each issue, You MUST:
  - Identify the root cause (read the relevant script/scene)
  - Propose a fix that adheres to project coding standards
  - Apply the fix
  - Re-run the failed test to verify
- You MUST NOT modify code without understanding the root cause because blind fixes often introduce new bugs
- You MUST re-run ALL tests after fixes, not just the failing one, because fixes can cause regressions
- You SHOULD commit fixes in logical groups (one issue = one commit concept)
- If the issue is in the test scene itself (not the component), fix the test scene first

**Resolution Workflow:**
1. Read error output carefully
2. Determine if issue is in production code or test scene
3. Read the offending script/scene
4. Understand what went wrong
5. Fix the issue following project standards
6. Re-run the specific failing test
7. Re-run full verification suite

**Output:**
- List of issues found
- Fixes applied
- Re-verification results

### 9. Verification Report

Generate a summary report of the verification process.

**Constraints:**
- You MUST produce a report containing:
  - **Phases verified**: List of all phases tested
  - **Test scenes used**: List of test scenes (reused or generated)
  - **Compilation status**: Pass/Fail with error count
  - **Test results**: Summary table of all tests run across all phases
  - **Issues found**: List of issues and their resolutions
  - **Outstanding items**: Any issues not yet resolved
- You MUST present results in a clear, scannable format
- You MUST indicate overall verification status: PASS or FAIL
- You SHOULD save the report to: `{feature_path}/verification-report.md`
- You MUST NOT report PASS if any critical or major issues remain unresolved because this misrepresents the implementation state

**Report Format:**
```markdown
# Verification Report: {Feature Name}

## Summary
- **Status**: PASS / FAIL
- **Date**: {timestamp}
- **Phases Verified**: {count}
- **Test Scenes Used**: {count}
- **Tests Run**: {count}
- **Tests Passed**: {count}
- **Tests Failed**: {count}

## Test Scenes
| Scene | Source | Status |
|-------|--------|--------|
| res://test-scenes/{feature}/test_*.tscn | Reused / Generated | PASS/FAIL |

## Compilation Check
- Status: PASS / FAIL
- Errors: {count}
- Warnings: {count}

## Phase Results

### Phase 1: {Phase Name}
| Test Scene | Component Tested | Status | Notes |
|------------|------------------|--------|-------|
| test_health_system.tscn | Player health | PASS/FAIL | {details} |

### Phase 2: {Phase Name}
| Test Scene | Component Tested | Status | Notes |
|------------|------------------|--------|-------|
| test_damage_interactions.tscn | Damage system | PASS/FAIL | {details} |

## Test Results
| Phase | Test | Test Scene | Result | Details |
|-------|------|------------|--------|---------|
| 1 | Property: health | test_health_system.tscn | PASS | Expected 100, got 100 |
| 1 | Signal: died | test_health_system.tscn | FAIL | Signal not emitted |

## Issues Resolved
1. {Issue description} - {Resolution}

## Outstanding Issues
1. {Issue description} - {Recommended action}

## Test Scene Artifacts
- Test scenes saved to: `res://test-scenes/{feature-name}/`
- These scenes can be manually run in the editor for debugging

## Next Steps
- {Recommended next action}
```

**Output:**
- Verification report (displayed and optionally saved)

## Examples

### Example: Verifying a Player Health System

```bash
# Step 2: Search for existing test scenes
ls -la {project_path}/test-scenes/player-health/ 2>/dev/null
# If not found, generate test scene (see Step 2 for generation template)

# Step 3: Compilation check
{godot_path} --path {project_path} --headless --quit 2>&1 | grep -i error

# Step 4: Load test scene
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- --wait:100 2>&1

# Step 5: Verify properties
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --print:Player:max_health \
  --expect:Player:max_health=100

# Step 6: Verify signals
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --listen:Player:health_changed \
  --listen:Player:died \
  --call:Player:take_damage:150 \
  --expect-signal:Player:health_changed \
  --expect-signal:Player:died

# Step 7: Full behavioral test
{godot_path} --path {project_path} --headless res://test-scenes/player-health/test_health_system.tscn -- \
  --listen:Player:health_changed \
  --set:Player:health=100 \
  --call:Player:take_damage:30 \
  --expect:Player:health=70 \
  --expect-signal:Player:health_changed \
  --call:Player:heal:20 \
  --expect:Player:health=90
```

### Example: Generated Test Scene

When no test scene exists, generate one like this:

```
# res://test-scenes/player-health/test_health_system.tscn
[gd_scene load_steps=2 format=3 uid="uid://test_health"]

[ext_resource type="PackedScene" uid="uid://player" path="res://scenes/player/player.tscn" id="1_player"]

[node name="TestRoot" type="Node2D"]

[node name="Player" parent="." instance=ExtResource("1_player")]
position = Vector2(400, 300)
```

This test scene:
- Instances the Player from its production location
- Places it at a known position
- Contains no other dependencies
- Can be opened in editor to manually test the Player in isolation

### Example Output Interpretation

```
[RT:OK] set Player:health = 100
[RT:OK] listen Player:health_changed
[RT:SIGNAL] Player:health_changed([100, 70])
[RT:OK] call Player:take_damage([30])
[RT:PASS] Player:health = 70
[RT:PASS] signal Player:health_changed was emitted (1 times)
[RT:RESULTS] Done: 2 OK, 0 ERR, 2 PASS, 0 FAIL
```

- `[RT:OK]` = Operations succeeded
- `[RT:SIGNAL]` = Signal was captured with args [100, 70]
- `[RT:PASS]` = Assertions passed
- `[RT:RESULTS]` = Summary showing 0 failures

## Troubleshooting

### Test Scene Won't Load
If a test scene fails to load:
1. Check that the instanced component path is correct (production scene may have moved)
2. Verify the test scene path is correct (res://test-scenes/...)
3. Check for missing dependencies in the instanced component
4. Look for circular dependencies in scripts
5. Regenerate the test scene if the production component structure changed

### Component Not Found in Test Scene
If runtime_test can't find a node:
1. Verify the node name matches (e.g., `Player` not `player`)
2. Check the test scene structure - component should be direct child of root
3. Open test scene in editor to verify node hierarchy
4. Use correct path: `Player` for root's child, `Player/Health` for nested

### Signal Not Captured
If `--expect-signal` fails:
1. Ensure `--listen` comes BEFORE the action that emits
2. Check signal name spelling matches exactly
3. Verify the signal is actually connected and emitted
4. Add `--wait:500` if the signal is async
5. In test scenes, prefix with node name: `--listen:Player:health_changed`

### Property Not Found
If `--print` or `--set` fails:
1. Check property name spelling
2. Verify property is declared in the script
3. Check node path within test scene (e.g., `Player:health` not `.:health`)
4. Ensure property is not private (underscore prefix may hide it)

### Type Coercion Warnings
If you see `(coerced from X)`:
1. Check the property type in the script
2. Ensure test value matches expected type
3. Use appropriate format (true/false for bool, integers for int)

### Test Scene Out of Sync
If tests pass in test scene but fail in production:
1. Verify test scene instances the current version of component
2. Check if production scene has additional dependencies not in test scene
3. Consider if autoloads/managers affect behavior in production
4. Update test scene to include necessary dependencies
