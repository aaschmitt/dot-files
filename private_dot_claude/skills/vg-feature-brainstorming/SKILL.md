---
name: vg-feature-brainstorming
description: This SOP guides you through brainstorming new feature ideas for an existing video game project. It analyzes the current implementation, vision, and design principles to generate creative feature ideas that align with the game's direction. Takes a rough idea (or no idea at all) and outputs a refined rough-idea.md ready for the feature breakdown pipeline.
type: anthropic-skill
version: "1.0"
---

# Feature Brainstorming SOP

## Overview

This SOP guides agents through the process of brainstorming new feature ideas for an existing video game project. It helps users discover meaningful additions to their game by analyzing what exists, identifying gaps and opportunities, and generating ideas that align with the game's vision and design principles.

**This SOP is generative and exploratory.** It's designed to spark creativity while keeping ideas grounded in the project's reality. The output feeds directly into the feature breakdown pipeline.

The workflow focuses on:
- Understanding what the game currently is
- Identifying what's missing or could be enhanced
- Generating ideas that fit the game's identity
- Refining a rough idea into something concrete enough to develop

Use this SOP when:
- The user has a vague feature idea they want to explore
- The user wants to brainstorm with no specific idea in mind
- The team needs fresh ideas that align with the vision
- An existing system feels incomplete and needs enhancement ideas
- The user is stuck and needs creative prompting

## Parameters

- **seed_idea** (optional): A rough starting point for brainstorming. Can be as vague as "something with combat" or "make the shop more interesting." If not provided, the SOP will conduct open-ended brainstorming.
- **feature_name** (required after brainstorming): A short, descriptive name for the final feature idea (used for folder naming). This is determined during the process, not upfront.

**Constraints for parameter acquisition:**
- You MUST NOT require all parameters upfront because feature_name emerges from the brainstorming process
- You SHOULD ask if the user has a seed idea to start with, but accept "no" as valid
- You MUST support multiple input methods for seed_idea:
  - Direct input: Text provided directly in the conversation
  - File path: Path to a local file containing thoughts or notes
  - URL: Link to a resource that inspired the idea
  - Reference to existing feature: "Something like [feature] but different"
- You MUST confirm the feature_name with the user before creating output files
- You MUST use kebab-case for feature_name (e.g., "weather-system", "npc-relationships")

## Output Structure

The brainstorming output is a single file that becomes the starting point for feature breakdown:

```
context/
└── features/
    └── {feature-name}/
        └── rough-idea.md    # The brainstormed and refined feature idea
```

## Steps

### 1. Context Gathering

Before brainstorming, understand the current state of the game project.

**Constraints:**
- You MUST locate and read the project's vision document (`context/vision.md`) if it exists
- You MUST scan for existing features in `context/features/` to understand what's already implemented or planned
- You MUST identify the project's:
  - Core loop (what players do repeatedly)
  - Design tenets (guiding principles)
  - Target emotions (how it should feel)
  - Player fantasy (what experience it fulfills)
- You SHOULD read `context/concepts.md` if it exists to understand existing terminology
- You MUST NOT proceed without understanding the game's identity because disconnected features harm the game
- You MAY ask the user to describe the game if no vision document exists
- You SHOULD note any gaps, incomplete systems, or mentioned-but-unimplemented ideas

**Questions to explore:**
- "What does the player do in your game? Walk me through a play session."
- "What's working well that you want to build on?"
- "What feels incomplete or underdeveloped?"
- "Are there any features you've thought about but haven't explored?"

**Output:**
- Internal understanding (not saved to file) of:
  - Game identity and vision
  - Existing systems and features
  - Design constraints and principles
  - Potential opportunity areas

### 2. Opportunity Identification

Identify areas where new features could enhance the game.

**Constraints:**
- You MUST analyze the game for opportunities in these categories:
  - **Core Loop Enhancement**: Ways to deepen or enrich the main gameplay loop
  - **Player Expression**: Ways for players to make meaningful choices or express themselves
  - **Progression & Reward**: Ways to create satisfying advancement or accomplishment
  - **Quality of Life**: Ways to reduce friction or improve usability
  - **Content Expansion**: Ways to add variety without changing core systems
  - **Emotional Resonance**: Ways to strengthen the target emotional experience
- You MUST filter opportunities through the design tenets because features that violate tenets will create internal conflict
- You SHOULD identify 3-5 opportunity areas even if the user has a seed idea
- You MUST present opportunity areas to the user for discussion
- You SHOULD ask which areas resonate most with the user

**Questions to explore:**
- "I see your core loop is [X]. What would make that loop more satisfying?"
- "Your design tenets emphasize [Y]. What features could reinforce that?"
- "What do players ask for? What do they complain about?"
- "What would surprise and delight a player who already loves your game?"

**If the user has a seed idea:**
- Map the seed idea to relevant opportunity categories
- Explore whether the idea addresses the right opportunity
- Suggest alternative angles if the seed doesn't fit cleanly

**If the user has no seed idea:**
- Present opportunity areas with brief examples for each
- Ask which resonates most strongly
- Use user response to focus brainstorming

### 3. Idea Generation

Generate multiple feature ideas within the selected opportunity area(s).

**Constraints:**
- You MUST generate at least 3 distinct feature ideas
- Each idea MUST include:
  - A working title
  - A one-sentence pitch
  - How it connects to the core loop
  - Which design tenets it supports
  - Potential complexity (Low/Medium/High)
- You MUST vary ideas in scope and ambition (include at least one smaller and one larger option)
- You MUST NOT self-censor "wild" ideas too early because sometimes the best ideas sound crazy at first
- You SHOULD include at least one unexpected or non-obvious idea
- You SHOULD ask the user which ideas resonate and why
- You MAY combine elements from multiple ideas if the user likes aspects of several

**Idea generation prompts to use:**
- "What if [existing system] could also [new capability]?"
- "What's the opposite of what you'd expect here?"
- "What would make a player say 'I can't believe I can do this'?"
- "What's the cozy/chaotic/strategic/expressive version of this?"
- "What would a player who's mastered the game want next?"
- "What would make someone recommend this game to a friend?"

**Questions to explore:**
- "Which of these ideas excites you most? What draws you to it?"
- "Does anything feel missing from these options?"
- "What if we combined [idea A] with [idea B]?"
- "Is there an idea here that scares you a little? That might be the most interesting one."

### 4. Idea Refinement

Deepen the chosen idea into a concrete feature concept.

**Constraints:**
- You MUST work with the user to select one idea to develop
- You MUST explore the idea through these lenses:
  - **Player Motivation**: Why would a player engage with this? What's the pull?
  - **Core Interaction**: What is the player actually DOING? What's the verb?
  - **Integration**: How does this connect to existing systems?
  - **Emotional Payoff**: What feeling does this create?
  - **Scope Boundaries**: What is explicitly NOT part of this feature?
  - **Technical Fit** (Godot-specific): Early identification of implementation patterns:
    - Is this a good candidate for a **Resource-based/data-driven** approach? (Items, configurations, entity types, behaviors defined in .tres files)
    - Does this introduce patterns that could **unify with existing systems**? (e.g., "this interactable behaves like other interactables")
    - Are there **abstraction opportunities**? (e.g., "this is really a special case of a more general system")
    - What **Godot-native features** could this leverage? (Signals, groups, resources, composition, built-in nodes)
    - Is this a **composition candidate**? (Reusable behavior components that could attach to different node types)
- You MUST identify potential challenges or risks
- You MUST ensure the idea has a clear "hook" - the compelling core that makes it interesting
- You SHOULD suggest variations or tweaks during refinement
- You MUST NOT let the idea become vague or scope-creep during refinement
- You SHOULD ask "Is this still exciting?" after refinement to check for over-engineering

**Questions to explore:**
- "In one sentence, what makes this feature compelling?"
- "What's the first thing a player would notice or try?"
- "What existing system does this depend on most?"
- "What would a minimal version of this look like? What about a full version?"
- "What's the risk that makes you nervous about this idea?"

### 5. Vision Alignment Check

Verify the refined idea aligns with the game's vision and principles.

**Constraints:**
- You MUST check the idea against each design tenet
- You MUST verify the idea supports (or at least doesn't undermine) the target emotions
- You MUST confirm the idea fits the player fantasy
- You MUST ask the user:
  - "Does this feel like it belongs in YOUR game?"
  - "Does this honor what makes your game special?"
- If alignment issues are found:
  - You MUST flag them clearly
  - You SHOULD suggest modifications that improve alignment
  - You MAY recommend abandoning the idea if it fundamentally conflicts
- You MUST NOT proceed if the idea violates core design tenets unless the user explicitly acknowledges the tradeoff

**Alignment checklist:**
- [ ] Supports the core loop (enhances, doesn't distract)
- [ ] Honors design tenets (doesn't violate any)
- [ ] Creates target emotions (or compatible emotions)
- [ ] Fits the player fantasy (feels like it belongs)
- [ ] Respects existing systems (integrates, doesn't conflict)

### 6. Documentation

Create the rough-idea.md file for the feature breakdown pipeline.

**Constraints:**
- You MUST ask the user to confirm a feature_name in kebab-case
- You MUST create the directory `context/features/{feature-name}/` if it doesn't exist
- You MUST create `context/features/{feature-name}/rough-idea.md` containing:
  - **Feature Title**: The working name
  - **One-Line Pitch**: The compelling summary
  - **Origin**: How this idea emerged (seed idea, opportunity area, brainstorming)
  - **The Hook**: What makes this compelling - the core appeal
  - **Player Motivation**: Why players would engage
  - **Core Interaction**: What the player does (the verbs)
  - **Integration Points**: Existing systems this touches
  - **Emotional Goal**: What feeling this creates
  - **Scope Notes**: What's in and explicitly what's out
  - **Risks & Challenges**: Known concerns to address
  - **Vision Alignment**: How this supports the game's identity
  - **Technical Notes**: Early observations about implementation approach:
    - Candidate patterns (Resource-based? Component-based? Signal-driven?)
    - Potential abstractions or unification opportunities
    - Godot-native features to leverage
    - Existing systems that could be extended vs. new systems needed
  - **Open Questions**: Things to resolve during breakdown
- You MUST keep the document concise but complete
- You SHOULD use the game's voice/tone in the document
- You MUST present the final document to the user for approval
- You SHOULD inform the user this is ready for the feature breakdown pipeline

**Output:**
- `context/features/{feature-name}/rough-idea.md`

## Examples

### Example 1: Brainstorming with a Seed Idea

**User Input:**
```
seed_idea: "I want something that makes the overnight phase more interesting"
```

**Brainstorming Flow:**

1. **Context Gathering** reveals:
   - Game: Cozy cafe management
   - Core loop: Day phase (serve customers) -> Night phase (upgrade, prepare)
   - Tenets: "Craft over commerce", "Cozy consequences"
   - Night phase currently just has menu selection

2. **Opportunity Identification** maps seed to:
   - Core Loop Enhancement (night phase feels thin)
   - Player Expression (choices during night could express player style)

3. **Idea Generation** produces:
   - "Dream Brewing" - Experiment with recipes in a dream kitchen, no consequences
   - "Night Visitors" - Mysterious customers with special requests only at night
   - "Shop Decorating" - Arrange and customize the cafe aesthetics
   - "Ingredient Foraging" - Explore magical locations to gather rare ingredients

4. **Idea Refinement** (user picks Night Visitors):
   - Hook: Mysterious regulars with deeper stories, only available at night
   - Interaction: Serve special drinks, learn their secrets
   - Integration: Uses existing brewing system, new character writing
   - Emotion: Intrigue and intimacy - cozy mystery

5. **Vision Alignment** confirms:
   - Supports "Craft over commerce" (special drinks, not profit)
   - Creates cozy mystery feeling (compatible with target emotions)
   - Deepens character relationships (supports player fantasy)

### Example 2: Open Brainstorming (No Seed Idea)

**User Input:**
```
seed_idea: none / "I don't know, I just feel like the game needs something"
```

**Brainstorming Flow:**

1. **Context Gathering** reveals:
   - Game: Factory automation puzzle
   - Core loop: Design -> Build -> Optimize
   - Tenets: "Elegant solutions", "Every part matters"
   - Existing: Conveyor belts, machines, resources

2. **Opportunity Identification** presents:
   - "Your optimization loop is strong, but I notice no way for players to share solutions. That's an Expression opportunity."
   - "The factory feels isolated. Environmental interaction could add variety."
   - "Long-term goals seem unclear. Progression might need work."

3. User resonates with "factory feels isolated"

4. **Idea Generation** for environmental interaction:
   - "Weather Effects" - Rain, wind affect exposed machinery
   - "Wildlife Integration" - Animals interact with factory, can be helpful or disruptive
   - "Terrain Challenges" - Build on different terrain types with unique constraints
   - "Day/Night Cycle" - Some machines work differently at night, power considerations

5. User likes Wildlife but worried about "disruptive" violating tenets

6. **Idea Refinement** adjusts:
   - Hook: Wildlife as helpers, not pests - they can be integrated into production
   - "What if animals could be trained to transport items?"
   - Keeps "Every part matters" - animals are parts too

### Example Output: rough-idea.md

```markdown
# Night Visitors

## One-Line Pitch
Mysterious regulars visit the cafe after hours, bringing deeper stories and special requests that reward your brewing mastery.

## Origin
Seed idea: "Make overnight phase more interesting" -> Opportunity: Core Loop Enhancement -> Selected from 4 generated ideas

## The Hook
The cafe has secrets. Some customers only come when the regular crowd is gone, and they're not looking for a quick coffee - they're looking for someone who'll listen.

## Player Motivation
- **Discovery**: Who are these people? What are their stories?
- **Mastery**: Special requests test brewing skills in new ways
- **Connection**: Build deeper relationships than daytime allows
- **Mystery**: Uncover the cafe's hidden history

## Core Interaction
- Choose whether to open the cafe at night (costs energy/resources)
- Serve drinks using existing brewing system
- Make dialogue choices that deepen relationships
- Unlock special recipes and story content

## Integration Points
- **Brewing System**: Uses existing recipes, introduces night-only ingredients
- **Customer Relationships**: Extends relationship system to new characters
- **Day/Night Cycle**: Adds meaningful choice to existing time system
- **Economy**: Night visitors pay differently (rare items, not coins?)

## Emotional Goal
**Cozy mystery** - Intimate late-night conversations with intriguing strangers. The feeling of being trusted with secrets. Wonder at the magical world beyond the cafe.

## Scope Notes
**In Scope:**
- 3-5 night visitor characters with story arcs
- Night-only ingredients (2-3)
- Special drink requests
- Dialogue system for night scenes

**Explicitly Out of Scope:**
- Combat or danger
- Time pressure or fail states
- Changes to core daytime loop
- Procedural/random visitors (all are hand-crafted)

## Risks & Challenges
- **Writing Quality**: Characters must be compelling; this is content-heavy
- **Balance**: Night opening must feel optional, not mandatory for progression
- **Scope Creep**: Easy to keep adding "one more character"
- **Integration**: Needs to feel like part of the game, not a separate mode

## Vision Alignment
- **"Craft over commerce"**: Night visitors care about the drink, not the price
- **"Regulars over rush"**: Deep relationships with few characters
- **"Cozy consequences"**: Missing a night has no punishment, just missed opportunity
- **Core Fantasy**: "My cafe has secrets and magic I'm still discovering"

## Technical Notes
- **Candidate Pattern**: Resource-based character definitions (NightVisitorData.gd) for each visitor's preferences, dialogue, story state
- **Abstraction Opportunity**: Night visitors could extend a base "Customer" pattern - same brewing interaction, different data
- **Godot-Native**: Use Godot's dialogue system patterns; visitor state can be saved via Resource export
- **Unification**: Consider whether night drink requests can use the existing recipe/order system with night-only flags

## Open Questions
- How many nights until a visitor's story completes?
- What do night visitors give as rewards?
- Should night be every night, or certain nights only?
- How do we introduce the first night visitor?
```

## Troubleshooting

### User Can't Articulate What's Missing
If the user feels "something is missing" but can't say what:
- Walk through the core loop step by step: "Tell me what happens from the moment you start playing"
- Ask about friction points: "Where do you get bored or frustrated?"
- Ask about comparisons: "What do similar games have that yours doesn't? Do you want that?"
- Suggest playing the game together: "Walk me through a session and tell me what you're feeling"

### All Ideas Feel Generic
If brainstormed ideas feel uninspired:
- Look at what makes THIS game unique, not just the genre
- Combine unexpected systems: "What if [unrelated thing] affected [core system]?"
- Invert assumptions: "What if the player couldn't do [expected action]? What would they do instead?"
- Ask about personal interests: "What are you excited about outside of game dev? How could that show up here?"

### User Keeps Expanding Scope
If the idea keeps getting bigger during refinement:
- Ask: "What's the ONE thing this feature absolutely must do?"
- Suggest: "Let's define the minimal version first, then list the 'nice to haves'"
- Reality check: "If you had to ship this in [timeframe], what would you cut?"
- Separate ideas: "I'm hearing two features here. Should we pick one?"

### Idea Violates Design Tenets
If a compelling idea conflicts with the game's principles:
- Name the conflict explicitly: "This is exciting, but it seems to conflict with [tenet]. Let's talk about that."
- Explore modifications: "What if we changed [aspect] to honor [tenet]?"
- Question the tenet: "Is this tenet still serving you? Should it evolve?"
- Accept the tradeoff: "If you proceed, know that this changes what your game is. Is that intentional?"

### User Is Attached to a Bad Idea
If the seed idea has fundamental problems:
- Validate the underlying desire: "I hear that you want [underlying goal]. The specific approach has challenges, but the goal is valid."
- Reframe: "What if we achieved that same feeling through [alternative approach]?"
- Be direct but kind: "I want to be honest - I see some issues with this idea. Can we explore them?"
- Find the kernel: "What's the part of this idea you love most? Let's build from there."

### No Vision Document Exists
If there's no vision.md to reference:
- Ask the user to describe the game's identity verbally
- Capture key points during conversation
- Suggest running the vision SOP first if brainstorming feels ungrounded
- Proceed with caution, noting that ideas may need revision once vision is formalized

### User Wants to Skip Straight to Implementation
If the user is impatient with brainstorming:
- Explain the value: "Spending time here prevents wasted implementation effort"
- Speed up: Focus on the most relevant questions, skip optional exploration
- Compromise: "Let's do a quick version - 15 minutes to validate the core idea"
- Trust their instincts: If they're confident, document what they have and flag open questions for later
