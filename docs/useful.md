```
nix why-depends --derivation .#devShells.x86_64-linux.default nixpkgs#gcc
```
## Claude Code plugins

Local plugins live in `modules/programs/ai/claude-code/plugins/<name>`. `CLAUDE_CODE_PLUGIN_DIRS` points to a generated directory of the enabled ones; gate a plugin in the `plugins` attrset of `modules/programs/ai/claude-code/default.nix`.

`nvim-review` is enabled together with review.nvim. `:Review export` (or closing the review) writes `.review/inbox/<timestamp>.md` at the git root, Claude Code picks it up within ~1.5s and starts a turn with it, and `/nvim-review` sends the next waiting review immediately. Both sides resolve the git root of their working directory, so Neovim and Claude Code must run inside the same repo; past reviews stay in `.review/done/`.
