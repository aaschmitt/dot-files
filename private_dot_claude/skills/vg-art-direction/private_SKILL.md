---
name: vg-art-direction
description: Guide users through defining comprehensive art direction for video game development. Transforms rough visual ideas and inspiration into a structured, implementable art direction document covering visual identity, technical specifications, color palettes, character design, environments, animation, and asset organization.
type: anthropic-skill
version: "1.0"
---

# Art Direction SOP

## Overview

This SOP guides you through creating a comprehensive art direction document for video game development. It transforms rough visual ideas, mood references, and design vision into a structured specification that artists and developers can follow consistently.

The workflow separates high-level creative vision (what the game should feel like) from technical specifications (how to achieve that look), ensuring both are clearly defined before asset creation begins.

Use this SOP when:
- Starting a new game project that needs visual direction
- Formalizing an existing game's art style for documentation
- Onboarding artists who need clear visual guidelines
- The user has inspiration references but no structured art direction

## Parameters

- **project_name** (required): The name of the game project (used for document titles and file naming).
- **vision_document** (optional): Path to a design vision document, GDD, or similar artifact describing the game's concept, themes, and player fantasy.
- **target_platform** (optional, default: "PC"): Target platform(s) affecting resolution and performance considerations (PC, mobile, console, web).
- **art_style_preference** (optional): Preferred art style if known (pixel art, vector, 3D low-poly, hand-drawn, etc.).
- **inspiration_references** (optional): Games, movies, art, or other media that inspire the visual direction.

**Constraints for parameter acquisition:**
- You MUST ask for all required parameters upfront in a single prompt rather than one at a time
- You MUST support multiple input methods including:
  - Direct input: Text provided directly in the conversation
  - File path: Path to a local file containing vision documents
  - URL: Link to mood boards, reference images, or inspiration
- You MUST confirm successful acquisition of all parameters before proceeding
- You SHOULD encourage the user to share any existing mood boards, sketches, or reference images

## Output Structure

The art direction document is saved as a single comprehensive file:

```
context/art-direction.md
```

Or, if specified by the user, at their preferred location.

## Steps

### 1. Gather Vision Context

Read and analyze any provided vision documents, design documents, or reference materials to understand the game's core identity.

**Constraints:**
- You MUST read any vision_document provided by the user
- You MUST identify and extract:
  - Game genre and core mechanics
  - Target audience and player fantasy
  - Emotional tone and mood
  - Setting and world context
  - Any existing visual references or preferences
- You SHOULD ask clarifying questions if the vision is unclear
- You MUST NOT proceed without understanding the game's core identity because art direction must serve the game's vision

**Questions to answer:**
- What is the player fantasy?
- What emotions should the visuals evoke?
- What makes this game visually distinct?

---

### 2. Define Visual Identity

Establish the high-level visual identity including theme, mood, and style references.

**Constraints:**
- You MUST define:
  - **Theme**: The visual concept in one sentence (e.g., "A cozy cat cafe run by cats")
  - **Style Reference**: 1-3 existing games/media that capture the desired look
  - **Mood**: The emotional atmosphere (e.g., "Warm, inviting, slightly whimsical")
- You MUST explain why each style reference is relevant
- You SHOULD discuss tradeoffs between different visual approaches with the user
- You MUST NOT copy a style reference exactly; instead, identify what elements to borrow because wholesale copying limits creative identity

**Output format:**
```markdown
## Visual Identity

**Theme:** [One-sentence visual concept]

**Style References:**
- [Reference 1] — [What to borrow from it]
- [Reference 2] — [What to borrow from it]

**Mood:** [Emotional atmosphere description]
```

---

### 3. Technical Specifications

Define the technical constraints and specifications for all visual assets.

**Constraints:**
- You MUST specify:
  - **Base Unit**: The fundamental tile/sprite size (e.g., 16×16, 32×32 pixels)
  - **Character Size**: Player and NPC sprite dimensions
  - **Object Sizes**: Items, machines, environmental objects
  - **Resolution**: Target screen resolution and scaling approach
  - **Outline Style**: How outlines are handled (black, colored, selective, none)
  - **Shading Style**: Flat, cel-shaded, gradient, etc.
- You MUST ensure specifications match the target platform
- You SHOULD provide rationale for each technical choice
- You MUST NOT leave pixel dimensions ambiguous because inconsistent sizes break visual cohesion

**Output format:**
```markdown
## Technical Specifications

| Property | Value |
|----------|-------|
| Base Unit | [size] |
| Character Size | [size] |
| Object Size | [size range] |
| Resolution | [target resolution] |
| Outline Style | [description] |
| Shading Style | [description] |
```

---

### 4. Color Palette

Design and document a complete color palette with specific usage assignments.

**Constraints:**
- You MUST define a limited palette appropriate to the art style:
  - Pixel art: 8-32 colors typically
  - Vector/modern: Can be broader but should have core palette
- You MUST provide hex codes for every color
- You MUST assign primary uses for each color (e.g., "skin tones", "foliage", "UI accents")
- You SHOULD use or reference established palettes when appropriate (e.g., Sweetie 16, PICO-8, Endesga 32)
- You MUST document color assignments for major categories:
  - Characters (skin, hair, clothing)
  - Environment (floors, walls, nature)
  - Objects (items, machines, UI)
- You MUST NOT include colors without defined purposes because unused colors create inconsistency

**Output format:**
```markdown
## Color Palette

### [Palette Name]

| Color | Hex | Primary Use |
|-------|-----|-------------|
| [visual] | `#XXXXXX` | [usage] |

### Color Assignments

**Characters:**
- [element]: `#XXXXXX` ([name])

**Environment:**
- [element]: `#XXXXXX` ([name])
```

---

### 5. Character Design Guidelines

Define proportions, anatomy rules, and variation systems for characters.

**Constraints:**
- You MUST specify character proportions:
  - Head-to-body ratio
  - Key measurements at target resolution
  - Anatomy simplifications for the art style
- You MUST define the protagonist/player character:
  - Identifying features and silhouette
  - Required states (idle, walk, action)
  - Visual personality elements
- You MUST create a variation system for NPCs:
  - Base elements that vary (colors, accessories, features)
  - How many combinations the system allows
- You SHOULD include visual examples or ASCII diagrams where helpful
- You MUST NOT design characters that are unreadable at target resolution because players need to identify characters quickly

**Output format:**
```markdown
## Character Design

### Proportions
- Head-to-body ratio: [ratio]
- [Key measurements]

### Player Character
**Design Elements:**
- [identifying features]

**States:**
- [required animation states]

### NPC Variation System
**Base variations:**
- [variation category]: [options]
```

---

### 6. Environment & Object Design

Define design principles for world elements, interactive objects, and items.

**Constraints:**
- You MUST categorize objects by type:
  - Environmental/decorative
  - Interactive/functional
  - Items/collectibles
  - UI elements
- You MUST define design principles for each category:
  - Shape language (rounded = friendly, angular = dangerous)
  - Visual hierarchy (what draws attention)
  - State indicators (how objects show their state)
- You MUST specify sizes relative to the base unit
- You SHOULD describe how objects communicate interactivity
- You MUST NOT design objects with unclear affordances because players must understand what they can interact with

**Output format:**
```markdown
## Environment & Objects

### [Category Name]

**Design Principles:**
- [principle 1]
- [principle 2]

**Size:** [dimensions]

**States:**
1. [state]: [visual description]
```

---

### 7. Animation Guidelines

Define animation approach, frame counts, and timing principles.

**Constraints:**
- You MUST specify frame counts for common animations:
  - Idle
  - Walk/run cycles
  - Actions/interactions
  - Object state changes
- You MUST define timing guidelines:
  - Frame duration in milliseconds
  - When to use faster/slower timing
- You MUST list animation principles to follow:
  - Squash and stretch (if applicable)
  - Anticipation
  - Follow-through
- You SHOULD provide examples of key animation cycles
- You MUST NOT require excessive frame counts for the art style because over-animation wastes resources and can look wrong

**Output format:**
```markdown
## Animation Guidelines

### Frame Counts

| Animation | Frames | Notes |
|-----------|--------|-------|
| [type] | [count] | [notes] |

### Timing
- Default frame duration: [ms]
- [timing guidelines]

### Principles
1. [principle]: [how to apply]
```

---

### 8. Asset Organization

Define naming conventions, folder structure, and export specifications.

**Constraints:**
- You MUST define a folder structure for all asset types
- You MUST specify naming conventions:
  - Use snake_case or kebab-case consistently
  - Include category and state in filenames
  - Be specific enough to avoid confusion
- You MUST document export specifications:
  - File formats (PNG, SVG, etc.)
  - Scaling requirements
  - Transparency handling
- You SHOULD match engine/framework conventions where applicable
- You MUST NOT allow ambiguous naming because it causes asset management nightmares

**Output format:**
```markdown
## Asset Organization

### Folder Structure
```
assets/
├── sprites/
│   ├── [category]/
```

### Naming Convention
- [pattern]: [example]

### Export Specifications
- Format: [format]
- [other specs]
```

---

### 9. Reference Documentation

Compile all inspiration sources and create a reference section.

**Constraints:**
- You MUST list all referenced games, media, and artists
- You MUST explain what each reference contributes to the direction
- You SHOULD categorize references by what they inform:
  - Character style
  - Environment style
  - Color palette
  - Animation approach
  - UI/UX patterns
- You MAY include links to mood boards or reference images if provided

**Output format:**
```markdown
## References

- **[Reference Name]** — [what it informs]
```

---

### 10. Review & Output

Generate the final art direction document and review with the user.

**Constraints:**
- You MUST compile all sections into a single cohesive document
- You MUST save the document to `context/art-direction.md` or user-specified location
- You MUST present a summary to the user including:
  - Key decisions made
  - Technical specifications summary
  - Palette overview
  - Asset checklist for first implementation phase
- You SHOULD ask if any sections need adjustment
- You MUST verify the document is actionable for artists
- You MUST NOT finalize without user confirmation because art direction requires stakeholder buy-in

**Final document structure:**
```markdown
# [Project Name] - Art Direction

## Visual Identity
## Technical Specifications
## Color Palette
## Character Design
## Environment & Objects
## Animation Guidelines
## Asset Organization
## Asset Checklist: Phase 1
## References
```

---

## Examples

### Example Input

```
project_name: "Brew.io"
vision_document: "context/design-vision.md"
art_style_preference: "Pixel art"
inspiration_references: "Night in the Woods, Stardew Valley, Coffee Talk"
```

### Example Output Summary

```markdown
# Brew.io - Art Direction

## Visual Identity
**Theme:** A cozy cat cafe run by cats, for cats
**Style Reference:** Night in the Woods — expressive anthropomorphic animals
**Mood:** Warm, inviting, slightly whimsical

## Technical Specifications
| Property | Value |
|----------|-------|
| Base Unit | 16×16 pixels |
| Character Size | 16×16 (chibi) |
| Palette | Sweetie 16 |
| Outline Style | Selective (darker shade, not black) |

## Asset Checklist: Phase 1
### Characters
- [ ] Player cat (idle, walk 4-dir, carry item)
- [ ] Customer cat base (1-2 variations)

### Items
- [ ] Coffee beans
- [ ] Ground coffee
- [ ] Black coffee (in cup)
```

---

## Troubleshooting

### No Clear Visual Direction
If the user has no specific vision:
- Ask about games they enjoy visually
- Ask about the emotional tone they want
- Suggest 2-3 contrasting style options and discuss tradeoffs
- Start with a simple, achievable style and iterate

### Conflicting References
If inspiration references have conflicting styles:
- Identify what specifically appeals in each reference
- Find the common thread (mood? color? proportions?)
- Propose a synthesis that takes the best elements
- Document which reference informs which aspect

### Technical Constraints Unclear
If the user doesn't know technical requirements:
- Ask about their engine/framework (Godot, Unity, etc.)
- Ask about target platforms and performance needs
- Recommend standard specifications for their art style
- Start conservative and document how to scale up later

### Scope Too Large
If the art direction scope is overwhelming:
- Focus on Phase 1 assets first
- Define the minimum viable visual set
- Mark "future" sections that can be expanded later
- Prioritize player character, core objects, and one environment
