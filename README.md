# Dotfiles (chezmoi)

Managed with [chezmoi](https://www.chezmoi.io/).

## Layout

Source files use chezmoi's [attribute prefixes](https://www.chezmoi.io/reference/source-state-attributes/):
- `dot_foo`   → `~/.foo`
- `dot_config/foo` → `~/.config/foo`
- `*.tmpl`    → rendered through Go template engine
- `Library/Application Support/...` → mapped verbatim under `~/`

OS scoping lives in `.chezmoiignore`:
- `dot_config/hypr` and `dot_zprofile.tmpl`'s Hyprland block render only on Linux.
- `dot_config/aerospace` and `Library/` (Godot themes) render only on macOS.

## Usage

```sh
# Initial setup (points chezmoi at this repo without moving it)
chezmoi init --source=$HOME/workspace/github.com/aaschmitt/dot-files

# Preview what apply would change
chezmoi diff

# Apply
chezmoi apply -v

# Edit a managed file via chezmoi (opens the source, then apply)
chezmoi edit ~/.zshrc

# Pull live edits back into the source
chezmoi re-add ~/.zshrc
```

## Skills

After the initial `chezmoi apply`, synchronize personal and selected external
Codex skills:

```sh
$HOME/.local/bin/skills-sync
```

The command clones or fast-forwards the private `aaschmitt/skills` repository
and Matt Pocock's public skills repository, then refreshes `~/.agents/skills`.
Only `grill-with-docs` and its required `grilling` and `domain-modeling`
dependencies are selected from Matt's repository.

On later updates, run:

```sh
chezmoi apply -v
skills-sync
```
