---
name: vg-vision
description: This SOP guides you through crafting a vision document for a video game. It challenges you to think critically about your game's merit, player motivation, and commercial viability while defining what kind of game to build, how players should feel, and what experience to craft. Takes a business-critical eye to game ideas.
type: anthropic-skill
version: "2.0"
---

# Game Vision Document SOP

## Overview

This SOP guides agents through the process of crafting a vision document for a video game project. The vision document serves as a north star - a guiding reference point for all future feature and mechanic decisions.

**This SOP takes a critical, commercially-minded approach.** It will challenge the user to defend their ideas, examine player motivation honestly, and confront uncomfortable questions about whether the game is worth building. Great vision documents emerge from rigorous questioning, not comfortable agreement.

The workflow focuses on high-level direction:
- What kind of game is this?
- How should players feel?
- What experience are we creating?
- What principles guide our decisions?
- **Why would anyone play this? (Be honest.)**
- **What's the real motivation to keep playing?**
- **Where will players quit, and why?**

Use this SOP when:
- Starting a new game project
- A project lacks a clear guiding vision
- The team needs alignment on game direction
- You want to establish criteria for evaluating new features
- **You need an honest, critical assessment of a game idea's viability**

## Parameters

- **game_idea** (required): The initial game concept or idea. Can be as rough as a genre and vibe, or a more detailed pitch.
- **project_name** (required): A short name for the game project (used for file naming).

**Constraints for parameter acquisition:**
- You MUST ask for all required parameters upfront in a single prompt rather than one at a time
- You MUST support multiple input methods including:
  - Direct input: Text provided directly in the conversation
  - File path: Path to a local file containing the idea
  - URL: Link to a resource describing the concept
- You MUST confirm successful acquisition of all parameters before proceeding
- You MUST use kebab-case for project_name if used in file paths (e.g., "cozy-cafe", "space-roguelike")

## Output Structure

The vision document is saved as a single file at the project planning root:

```
context/
└── vision.md    # The complete vision document
```

## Steps

### 1. Game Identity

Establish the foundational identity of the game through conversation with the user. **Challenge derivative or oversaturated ideas early.**

**Constraints:**
- You MUST ask the user about:
  - What kind of game is this? (genre, format, platform considerations)
  - What are the primary influences or inspirations?
  - What makes this game unique or different from its inspirations?
- You MUST document the answers clearly
- You SHOULD ask follow-up questions to clarify vague responses
- You MUST NOT define specific mechanics or systems at this stage because the vision is about direction, not implementation details
- You MAY suggest genre combinations or framings if the user is uncertain
- You MUST challenge ideas that sound derivative or lack clear differentiation because the market is saturated and "like X but slightly different" rarely succeeds
- You SHOULD ask about market awareness: "What games already exist in this space? Have you played them?"
- You MUST push back on vague uniqueness claims because "it's more polished" or "better art" are not real differentiators

**Questions to explore:**
- "Is this a [genre]? What draws you to that?"
- "What games inspire this idea? What do you love about them?"
- "What would make someone choose your game over similar ones?"

**Critical challenge questions:**
- "I can name 5 games like this on Steam right now. Why would yours succeed where they didn't?"
- "What if someone is already building this exact thing with more resources? What's your unfair advantage?"
- "Is this idea actually novel, or does it just feel novel because you haven't researched the market?"
- "What's the ONE thing that makes this undeniably different? If you can't answer in one sentence, that's a red flag."

### 2. Player Emotions

Define the emotional experience the game should create.

**Constraints:**
- You MUST ask the user about:
  - How should players feel moment-to-moment during gameplay?
  - What emotional journey should a play session create?
  - What feelings do we explicitly want to avoid?
- You MUST capture both positive target emotions and emotions to avoid
- You SHOULD use concrete emotional language (e.g., "cozy and accomplished" not just "good")
- You MUST NOT confuse mechanics with emotions because "fun combat" is a mechanic preference, not an emotion
- You SHOULD help the user distinguish between emotions and features if they conflate them

**Questions to explore:**
- "When someone puts down the controller, how should they feel?"
- "What's the emotional texture of moment-to-moment play? Tense? Relaxed? Curious?"
- "What feelings would betray the game's identity? What should it never feel like?"

### 3. Player Motivation & Commercial Viability

**This is the critical challenge step.** Force an honest examination of whether the game idea has merit beyond the creator's enthusiasm. Many game ideas feel compelling to their creators but lack the hooks needed to attract and retain players.

**Constraints:**
- You MUST ask the user to articulate:
  - What is the player's motivation to start playing? (The hook)
  - What is the player's motivation to keep playing? (The loop)
  - What is the player's motivation to come back tomorrow? (Retention)
- You MUST examine friction points:
  - Where will players get frustrated?
  - Where will players quit? Be brutally honest.
  - Is the friction intentional (challenge) or accidental (bad design)?
- You MUST challenge engagement assumptions:
  - Is the core loop genuinely engaging, or just familiar from other games?
  - Can you describe why this is fun without referencing other games?
  - What creates replayability? Or is this a one-and-done experience?
- You MUST explore commercial viability:
  - Why would someone pay money for this?
  - What's the 30-second hook that makes someone download/buy?
  - Who is the competition, and why would players choose this over them?
- You MUST NOT accept "it's just fun" as sufficient motivation because that's not an answer, it's avoidance
- You MUST NOT accept "players who like [genre] will like this" because that describes an audience, not a motivation
- You SHOULD suggest alternative approaches if the motivation is weak
- You SHOULD propose pivots if the core idea seems commercially unviable
- You MUST be willing to say "I don't think this idea works yet" and explain why

**Questions to explore:**
- "Why would someone play this instead of [specific competitor]? Be specific."
- "What's the 30-second elevator pitch that makes someone say 'I need to play that'?"
- "Describe the moment a player gets hooked. What happens? Why does it work?"
- "Where will players get frustrated and quit? Don't say 'nowhere' - every game has drop-off points."
- "Is this engagement loop proven in the market, or are you hoping it works?"
- "What would make this a commercial failure? Be honest about the risks."
- "If you saw this in a game store with no context, would YOU buy it? Why or why not?"
- "What's the minimum viable version of this that's still fun? If you can't answer, the idea might be too complex."

**Challenge prompts to use:**
- "I'm not convinced yet. Sell me on why this is worth building."
- "That sounds like [existing game]. What makes yours worth existing alongside it?"
- "You've described features, but not motivation. Why does the player CARE?"
- "Let's stress-test this: what if a player does X instead of Y? Does the game still work?"
- "This sounds like it could get boring after 2 hours. What prevents that?"

**If the idea seems weak:**
- Suggest specific pivots: "What if instead of X, you tried Y?"
- Identify the strongest kernel: "The most compelling part is Z - what if you built around that?"
- Recommend narrowing scope: "This is trying to do too much. What's the ONE thing it needs to nail?"
- Be direct: "I don't think this idea works in its current form. Here's why, and here's what might help."

### 4. Core Experience

Define the player fantasy and target audience.

**Constraints:**
- You MUST ask the user about:
  - What fantasy or experience is the game fulfilling?
  - What is the "dream scenario" of playing this game?
  - Who is the target player? (not demographics, but psychographics/preferences)
- You MUST articulate the core fantasy in a single, clear statement
- You SHOULD help the user think beyond surface-level descriptions
- You MUST NOT narrow the target audience to demographics because psychographics (what players enjoy) matter more than age or gender

**Questions to explore:**
- "What fantasy does this game let players live out?"
- "Describe the perfect 30 minutes with your game - what happens?"
- "Who is this game for? Not age/gender, but what kind of player?"

### 5. Design Tenets

Establish 3-5 opinionated guiding principles that will inform all future decisions. **Tenets must survive commercial scrutiny.**

**Constraints:**
- You MUST help the user articulate 3-5 design tenets
- Each tenet MUST be:
  - Opinionated (takes a clear stance)
  - Actionable (can be used to evaluate features)
  - Memorable (easy to recall and reference)
  - **Commercially defensible** (a real player would value this)
- Tenets MAY use various formats:
  - "[Value] over [Alternative]" (e.g., "Cozy over stressful")
  - Imperative statements (e.g., "Always reward curiosity")
  - Principles (e.g., "Failure should teach, not punish")
- You MUST NOT create generic tenets that any game could claim because "Fun gameplay" is not a useful tenet
- You SHOULD test each tenet by asking: "Would this help us decide between two feature options?"
- You SHOULD help the user refine vague tenets into specific ones
- You MUST test each tenet against commercial reality: "Would a player pay for a game that prioritizes this?"
- You SHOULD challenge tenets that sound good but don't translate to player value

**Questions to explore:**
- "When two features conflict, what principle decides the winner?"
- "What would you sacrifice to preserve the game's identity?"
- "Complete this: 'Other games do X, but we always do Y because...'"

**Commercial reality test for tenets:**
- "This tenet sounds nice, but would a player notice or care?"
- "If you removed this tenet, would the game still sell? If yes, is it actually core?"
- "Does this tenet serve the player, or does it serve your artistic vision? Both are valid, but be honest."
- "Can you point to a successful game that embodies this tenet? If not, you're taking a risk - is it worth it?"

**Example tenets:**
- "Throughput over stress" - Players optimize for efficiency, not survival
- "Discovery over direction" - Let players find things rather than marking them
- "Meaningful choice over optimal path" - Multiple viable strategies, no single meta
- "Cozy consequences" - Failure sets you back, never punishes
- "Earned mastery" - Skill matters more than stats or gear

### 6. Vision Synthesis

Compile all discoveries into a cohesive vision document. **Include an honest assessment of risks and challenges.**

**Constraints:**
- You MUST create `context/vision.md` containing:
  - **Elevator Pitch**: 2-3 sentence summary of the game
  - **Game Identity**: Genre, influences, unique angle
  - **Emotional Goals**: Target feelings and feelings to avoid
  - **Player Motivation**: The hook, the loop, and the retention driver
  - **Core Fantasy**: The experience being fulfilled
  - **Target Player**: Who this game is for
  - **Design Tenets**: The 3-5 guiding principles
  - **Honest Assessment**: Risks, challenges, and potential failure points (NEW - required)
  - **Feature Evaluation Checklist**: Quick-reference questions for evaluating new ideas
- You MUST write the document in a tone that matches the game's identity
- You MUST include an "Honest Assessment" section that documents:
  - Known risks and challenges identified during the process
  - Where the idea is weakest
  - What could cause this game to fail
  - Unanswered questions that need resolution
  - Competitors and how this game differentiates
- You MUST include a feature evaluation checklist with questions like:
  - "Does this align with our core fantasy?"
  - "Does this support our emotional goals?"
  - "Does this honor our design tenets?"
  - **"Does this strengthen player motivation, or add friction?"** (NEW)
  - **"Would a player pay for this feature? Would they notice if it was missing?"** (NEW)
  - **"Does this help us compete, or is it self-indulgent scope creep?"** (NEW)
- You SHOULD keep the document scannable (use headers, bullets, bold text)
- You MUST present the final document to the user for review
- You SHOULD ask if any adjustments are needed
- You MUST NOT sugarcoat the honest assessment because false optimism leads to failed projects

**Output:**
- `context/vision.md`

## Examples

### Example Input

```
game_idea: "A cozy cafe management game where you brew coffee and serve magical customers"
project_name: "brew-magic"
```

### Example Vision Document Structure

```markdown
# Brew Magic - Vision Document

## Elevator Pitch
Brew Magic is a cozy cafe management game where you craft magical beverages for fantastical customers. It's about the satisfaction of perfecting recipes and building relationships, not stress or time pressure.

## Game Identity
- **Genre**: Cozy management / brewing sim
- **Influences**: Coffee Talk, Stardew Valley, Potion Craft
- **Unique Angle**: Focus on the craft of brewing rather than business metrics
- **Key Differentiator**: Unlike Coffee Talk (visual novel) or Potion Craft (alchemy puzzle), this centers on the ritual of brewing as meditation

## Emotional Goals
**Target Feelings:**
- Cozy and relaxed
- Satisfied when perfecting a recipe
- Curious about new ingredients
- Connected to regular customers

**Feelings to Avoid:**
- Stressed or overwhelmed
- Punished for experimentation
- Rushed or time-pressured

## Player Motivation
- **The Hook**: "What happens when I combine these ingredients?" - immediate curiosity about the brewing system
- **The Loop**: Perfect a recipe → unlock new ingredient → discover new combination → serve to customer → see their story progress
- **Retention**: Regular customers with unfolding stories that only progress when you serve them; seasonal ingredients that rotate

**Why players keep playing:**
Players return to see what happens next with their favorite regulars. The brewing mastery provides short-term satisfaction; character relationships provide long-term investment.

## Core Fantasy
"I run a magical cafe where every customer has a story and every drink is a small act of care."

## Target Player
Players who love cozy games, enjoy optimization without pressure, and value atmosphere and character over challenge and competition.

## Design Tenets

1. **Craft over commerce** - The joy is in making drinks, not maximizing profit
2. **Curious experimentation** - Trying new things should always feel rewarding, even when it fails
3. **Regulars over rush** - Deep relationships with few customers beats shallow interactions with many
4. **Cozy consequences** - Mistakes create opportunities, never punishments
5. **Atmosphere is gameplay** - The vibe matters as much as the mechanics

## Honest Assessment

**Risks & Challenges:**
- The cozy game market is crowded; differentiation must be crystal clear in marketing
- "Brewing as meditation" is unproven - needs prototyping to validate it's actually fun
- Character writing quality will make or break retention; this is a content-heavy game

**Weakest Points:**
- Long-term engagement unclear beyond "more characters, more recipes"
- No clear endgame or completion state defined yet

**Potential Failure Modes:**
- Brewing mechanic feels shallow after 2 hours
- Players don't connect with characters (writing quality risk)
- Gets lost in Steam's sea of cozy games

**Open Questions:**
- How many characters/recipes needed for launch?
- What's the monetization model? (Premium, DLC characters, etc.)
- How do we communicate "brewing as meditation" in a trailer?

**Competitive Positioning:**
- vs. Coffee Talk: More gameplay depth, less visual novel
- vs. Potion Craft: More character-focused, less puzzle-focused
- vs. Stardew: Narrower scope, deeper on one activity

## Feature Evaluation Checklist

When considering a new feature, ask:
- [ ] Does this support the "magical cafe owner" fantasy?
- [ ] Does this feel cozy, or does it add stress?
- [ ] Does this honor "craft over commerce"?
- [ ] Would our target player enjoy this?
- [ ] Does this fit the atmosphere we're creating?
- [ ] Does this strengthen player motivation (hook/loop/retention)?
- [ ] Would a player pay for this? Would they notice if missing?
- [ ] Does this help us compete, or is it scope creep?
```

## Troubleshooting

### User Struggles to Articulate Emotions
If the user has trouble describing emotions, offer concrete examples:
- "Would you describe moment-to-moment play as more like a puzzle (satisfying clicks) or more like gardening (patient growth)?"
- "Think of your favorite game in this genre - how does it make you feel? What would you change?"

### Tenets Are Too Generic
If tenets sound like they could apply to any game, push for specificity:
- "Every game wants to be 'fun' - what specific kind of fun?"
- "If another game in your genre does the opposite of this tenet, who are they? What's their approach?"

### User Wants to Define Mechanics
If the user keeps jumping to specific mechanics, gently redirect:
- "That's a great mechanic idea - let's capture it for later. For now, what feeling does that mechanic create?"
- "We'll get to the 'how' soon. Right now, let's nail down the 'why' and 'what feeling'."

### Vision Feels Scattered
If the vision elements don't cohere, look for the throughline:
- "I'm hearing [X] and [Y] - what connects these for you?"
- "If you had to pick one word that captures the whole game, what would it be?"

### User Gets Defensive About Criticism
If the user pushes back against critical questions, stay firm but constructive:
- "I'm not trying to kill your idea - I'm trying to make it bulletproof. These are questions investors/players will ask."
- "Being defensive now means being blindsided later. Let's find the answers together."
- "I'd rather we find the weaknesses now than after 6 months of development."
- If they remain resistant: "I'll note your confidence here, but I want to flag this as a risk in the honest assessment."

### Idea Lacks Clear Differentiation
If the user can't articulate what makes their game unique:
- "Let's try this: if your game didn't exist, what would players play instead? Now, why should they switch?"
- "What's the ONE thing you do better than anyone? Not five things - one."
- "Sometimes the best ideas come from constraint. What if you had to describe this game without mentioning [genre] or [main influence]?"
- Suggest: "Maybe the differentiation isn't the concept, but the execution. What specific execution choice sets you apart?"

### Core Loop Seems Weak
If the engagement loop doesn't seem compelling:
- "Walk me through 30 minutes of play. Where's the dopamine hit? Where's the 'one more turn' moment?"
- "What's the verb? What is the player DOING that's fun? If you can't name it, that's a problem."
- "Is this loop proven in other games, or are you inventing something new? New isn't bad, but it's risky."
- Suggest: "What if we simplified? What's the minimum loop that's still satisfying?"

### User Can't Articulate Player Motivation
If the user struggles to explain why players would play:
- "Forget features. Why would someone CHOOSE to spend their evening with your game instead of Netflix?"
- "What itch does this scratch? Completionism? Mastery? Escapism? Social connection?"
- "Think about your own gaming. What makes YOU keep playing a game? Does your idea have that?"
- Try reframing: "What problem does this game solve for the player? Boredom? Stress? Need for challenge?"

### Idea Seems Commercially Unviable
If you genuinely believe the idea won't work:
- Be direct but constructive: "I want to be honest - I have concerns about this idea's viability. Here's why..."
- Offer alternatives: "What if we kept [strongest element] but changed [weakest element]?"
- Find the kernel: "There's something interesting in [specific aspect]. What if that became the center?"
- Reality check: "Are you building this to ship, or to learn? Both are valid, but the answer changes my feedback."
- If they want to proceed anyway: "I've noted my concerns. Let's build the best version of this we can, and I'll document the risks clearly."
