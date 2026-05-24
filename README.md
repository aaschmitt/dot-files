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
chezmoi init --source=$HOME/Documents/Repos/dot-files

# Preview what apply would change
chezmoi diff

# Apply
chezmoi apply -v

# Edit a managed file via chezmoi (opens the source, then apply)
chezmoi edit ~/.zshrc

# Pull live edits back into the source
chezmoi re-add ~/.zshrc
```
