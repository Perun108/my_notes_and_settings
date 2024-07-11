# NeoVim and LunarVim

## Plugins

### Show function signature when you type
https://github.com/ray-x/lsp_signature.nvim


### CamelCase and snake_case motions
https://github.com/bkad/CamelCaseMotion

It's no longer maps CamelCaseMotion to <leader>w/e/b/ge by default. 
You need:

```lua
vim.g.camelcasemotion_key = '<leader>'
vim.keymap.set("n", "<leader>w", "<Plug>CamelCaseMotion_w")
vim.keymap.set("n", "<leader>b", "<Plug>CamelCaseMotion_b")
vim.keymap.set("n", "<leader>e", "<Plug>CamelCaseMotion_e")
vim.keymap.set("n", "<leader>ge", "<Plug>CamelCaseMotion_ge")
```

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

I could not make it to work with Python virtual environments for my project. 

I tried this:

https://stackoverflow.com/a/75176846/10466399

```
python3 -m venv ~/venvs/.nvim-venv && source ~/venvs/.nvim-venv/bin/activate && python3 -m pip install pynvim && which python
```

And then:
```
vim.g.python_host_prog = '~/.venvs/.nvim-venv/bin/python'
vim.g.python3_host_prog = '~/venvs/.nvim-venv/bin/python'
```

But it didn't work until I did this:
but it sucks to hard-code it each time I'm in a certain venv:
https://stackoverflow.com/a/70416303/10466399

```
require("lspconfig").pyright.setup {
  settings = {
    python = {
      analysis = {
        extraPaths = {"path/to/desired/modules"}
      }
    }
  }
}
```

### Chris (LunarVim) keybindings (https://www.youtube.com/watch?v=g4dXZ0RQWdw)

- if you can’t start `lvim` after installing `cargo` with standard methods (`curl https://sh.rustup.rs -sSf | sh` recommended in Rust dosumentation (https://doc.rust-lang.org/cargo/getting-started/installation.html) or with `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` recommended here https://www.rust-lang.org/tools/install), it’s probably because it’s not added to `PATH` in `.zshrc`, so just add this line to `./zshrc`: `export PATH="${HOME}/.cargo/bin:${PATH}"` and then restart shell with `exec $SHELL`.

https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/keybindings.json
