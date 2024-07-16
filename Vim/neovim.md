# NeoVim and LunarVim

## Buffers

### Navigation between opened buffers

1. `:Telescope buffers` or `Space-bf` in LunarVim
2. https://github.com/j-morano/buffer_manager.nvim (I mapped it to whichkey space-j)
3. https://github.com/ThePrimeagen/harpoon/tree/harpoon2

## Telescope

If you get that `gr` or `Telescope lsp_references` does not work: `method textDocument/references is not supported by any of the servers registered for the current buffer` - upgrade or install the newest node version (use nvm!)

## StatusLine (LuaLine)

https://www.lunarvim.org/docs/configuration/appearance/statusline
LunarVim's lualine modified components are defined here:
https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/lualine/components.lua

You can use these and also lualine's components (you can redefine them as well):
https://github.com/nvim-lualine/lualine.nvim

To get your full-screen dimensions execute this in command mode:
`:lua print("Columns: " .. vim.opt.columns:get() .. ", Lines: " .. vim.opt.lines:get())`

Then you can add a clock to full-screen mode only:

```lua
local function clock()
	if vim.opt.columns:get() < 118 or vim.opt.lines:get() < 39 then return "" end
  local time = os.date("%b %d, %H:%M")
	if os.time() % 2 == 1 then time = time:gsub(":", " ") end -- make the `:` blink
	return time
end
```
You can also add a function to display the count of selected characters:

```lua
local fn = vim.fn
local function selectionCount()
	local isVisualMode = fn.mode():find("[Vv]")
	if not isVisualMode then return "" end
	local starts = fn.line("v")
	local ends = fn.line(".")
	local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
	return " " .. tostring(lines) .. "L " .. tostring(fn.wordcount().visual_chars) .. "C"
end
```

```lua
local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections = {
lualine_a = { 'mode', {fmt = function(str) return str end }},
lualine_b = { components.branch, 'filename', {file_status = true, path = 1 }},
lualine_c = { components.diff, components.diagnostics, components.python_env },
lualine_x = { { clock }, components.filetype, components.treesitter }, -- Not sure what 'treesitter' does
lualine_y = { { selectionCount }, components.location },
lualine_z = { components.progress, components.scrollbar },
}
```

## Plugins

### Show function signature when you type
https://github.com/ray-x/lsp_signature.nvim

How to close hover hint when in insert mode (I would do Shift+Ecs in VSCode but here it drops me to Normal mode)
you can use <M-x> to map to Alt+x in insert mode, but it will again pop up when you type another argument. 
Perhaps better to get used to it and don't pay much attention to that floating window.

### CamelCase and snake_case motions
I tried the more well-known https://github.com/bkad/CamelCaseMotion  
but:
1. It's no longer maps CamelCaseMotion to <leader>w/e/b/ge by default. 
So you need:
```lua
vim.keymap.set("n", "\\w", "<Plug>CamelCaseMotion_w")
vim.keymap.set("n", "\\b", "<Plug>CamelCaseMotion_b")
vim.keymap.set("n", "\\e", "<Plug>CamelCaseMotion_e")
vim.keymap.set("n", "\\ge", "<Plug>CamelCaseMotion_ge")
```
I could not use this (it didn't work): `vim.g.camelcasemotion_key = '\\'`
2. I cound't get it to work with `c` and `d` - only motions would work, 
but not editing/deleting parts of CamelCase words.

So, I found this wonderful plugin: https://github.com/chaoren/vim-wordmotion  

I just set `vim.g.wordmotion_prefix="\\"` and it all worked as I need!

### Save and open last opened files (buffers)
At first I used persistence and would open last session with <leader>Ss
https://github.com/folke/persistence.nvim)
See also this demo: https://www.youtube.com/watch?v=Qf9gfx7gWEY&t=490s

BUT! Then I found out this auto-session plugin and it automatically saves yor session:
https://github.com/rmagatti/auto-session

### Multi-file Search and Replace
https://github.com/nvim-pack/nvim-spectre
https://www.youtube.com/watch?v=YzVmdJ41Xkg&t=194s

### Code Structure and Breadcrumbs

https://github.com/stevearc/aerial.nvim

I mapped `<leader>-a` to toggle aerial popup:
`wk.mappings["a"] = { "<cmd>AerialToggle!<CR>", "Aerial (Code structure)"}`

Just use `{` and `}` to sync jump while navigating structure. 

I could not make it to close when I switch buffers or switch to another app from lvim:
`close_automatic_events= {'switch_buffer'}` - didn't work with any of these settings.

```
 -- List of enum values that configure when to auto-close the aerial window
  --   unfocus       - close aerial when you leave the original source window
  --   switch_buffer - close aerial when you change buffers in the source window
  --   unsupported   - close aerial when attaching to a buffer that has no symbol source
```

### File Explorer as a floating window
I tried it, it worked but I didn't like it and I like the default one on the left side better.

Taken from https://github.com/MarioCarrion/videos/blob/269956e913b76e6bb4ed790e4b5d25255cb1db4f/2023/01/nvim/lua/plugins/nvim-tree.lua

```lua
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then return end

vim.cmd([[
  nnoremap - :NvimTreeToggle<CR>
]])

local keymap = vim.keymap -- for conciseness
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false --                  " Disable folding at startup.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5  -- You can change this too

nvimtree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  respect_buf_cwd = true,
  sync_root_with_cwd = true,
  view = {
    relativenumber = true,
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                         - vim.opt.cmdheight:get()
        return {
          border = "rounded",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
        end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
  },
  -- filters = {
  --   custom = { "^.git$" },
  -- },
  -- renderer = {
  --   indent_width = 1,
  -- },
})
```

### Surronding

Two nice plugins:
https://github.com/tpope/vim-surround
https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md

I used the first one and kind of got used to it, althoug the second one may seem simpler in terms of keystrokes.

### Git plugins
https://github.com/lewis6991/gitsigns.nvim has built-in support for inline git-blame,
but I like https://github.com/f-person/git-blame.nvim much better - 
you can open commit URLs (I bound a U key to leader-g where LunarVim has Git to this).
It also allows you to set [c ]c to navigate between changed hunks in a buffer!

I tried https://github.com/airblade/vim-gitgutter, 
but built-in gitsigns is much better integrated with other gutter plugins like LSP

https://github.com/rhysd/conflict-marker.vim - Doesn't work for me with any theme...

## Colors
### Customize highlights after setting the colorscheme
Example of changing color for selection (Visual mode)
vim.cmd [[
  augroup CustomHighlights
    autocmd!
    autocmd ColorScheme sonokai highlight Visual guibg=#fef5e7  
  augroup END
]]

## VSCode features that are needed in any NeoVim IDE
- multiple cursors (with option to specify case and whole words + to be able to add/remove occurrences)
- inline git blame displayed with option to go to the commit
- rename file in explorer
- global find & replace in all code

### Troubleshooting

I experienced severe lvim lags when I edited my config.lua that had lots of commented out lines (with plugins or settings that I played with).
When I deleted them - lvim again became fast. May be related to this:
https://github.com/LunarVim/LunarVim/issues/3353

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
