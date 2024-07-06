# NeoVim and LunarVim

## Plugins

### Show function signature when you type
https://github.com/ray-x/lsp_signature.nvim

### Save and open last opened files (buffers)
https://github.com/folke/persistence.nvim)
See also this demo: https://www.youtube.com/watch?v=Qf9gfx7gWEY&t=490s

### Multi-file Search and Replace
https://github.com/nvim-pack/nvim-spectre
https://www.youtube.com/watch?v=YzVmdJ41Xkg&t=194s

## VSCode features that are needed in any NeoVim IDE
- multiple cursors (with option to specify case and whole words + to be able to add/remove occurrences)
- inline git blame displayed with option to go to the commit
- rename file in explorer
- global find & replace in all code

## LunarVim

## Python configs

https://github.com/LunarVim/starter.lvim/blob/python-ide/config.lua

### Chris (LunarVim) keybindings (https://www.youtube.com/watch?v=g4dXZ0RQWdw)

- if you can’t start `lvim` after installing `cargo` with standard methods (`curl https://sh.rustup.rs -sSf | sh` recommended in Rust dosumentation (https://doc.rust-lang.org/cargo/getting-started/installation.html) or with `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` recommended here https://www.rust-lang.org/tools/install), it’s probably because it’s not added to `PATH` in `.zshrc`, so just add this line to `./zshrc`: `export PATH="${HOME}/.cargo/bin:${PATH}"` and then restart shell with `exec $SHELL`.

https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/keybindings.json
