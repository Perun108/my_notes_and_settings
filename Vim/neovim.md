# NeoVim and LunarVim

## Installation

How I installed nvim in Ubuntu

I `rm -rf` all directories related to `nvim`

Downloaded appimage from here:
https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage

It downloaded it to the `Downloads` folder, so I moved it to a dedicated directory:
`mkdir ~/.nvim`
`mv ~/Downloads/nvim.appimage ~/.nvim/`
`chmod u+x ~/.nvim/nvim.appimage`

Created a symlink to a directory on `PATH` to start nvim with just `nvim`:
`sudo ln -s ~/.nvim/nvim.appimage /usr/local/bin/nvim`

## Buffers

### Navigation between opened buffers

1. `:Telescope buffers` or `Space-bf` in LunarVim
2. https://github.com/j-morano/buffer_manager.nvim (I mapped it to whichkey space-j)
3. https://github.com/ThePrimeagen/harpoon/tree/harpoon2

### Close unused buffers
https://www.reddit.com/r/neovim/comments/12c4ad8/closing_unused_buffers/

I asked ChatGPT to write me a script for this:
```lua
wk.mappings["bc"]  = { "<cmd>lua CloseUnusedBuffers()<CR>", "Close unused buffers" }

-- Define the function to close unused buffers
function CloseUnusedBuffers()
    local curbufnr = vim.api.nvim_get_current_buf()
    local buflist = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buflist) do
        if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and not vim.b[bufnr].bufpersist then
            vim.cmd('bd ' .. bufnr)
        end
    end
end

-- Create an augroup for buffer persistence
local augroup = vim.api.nvim_create_augroup("BufferPersistence", { clear = true })

-- Function to persist buffer
local function persistbuffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.b[bufnr].bufpersist = 1
end

-- Auto command to persist buffers
vim.api.nvim_create_autocmd("BufRead", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.api.nvim_create_autocmd({"InsertEnter", "BufModifiedSet"}, {
            buffer = 0,
            once = true,
            callback = function()
                persistbuffer()
            end
        })
    end
})

### Re-open closed buffers

Initially I thought of this functionality (because I had this in VSCode and in Firefox, etc),
but then it kind of appeared to me that you can actually just use Vim's `Ctrl+o` to go to the previous place
and it's essentially the same as re-open closed buffer.

I asked ChatGPT to write a script for this and it's not ideal but it almost works.

```lua
-- EXPERIMENT TO REOPEN CLOSED BUFFERS
-- Create a table to hold the buffer numbers
local closed_buffers = {}
local max_buffers = 5  -- Number of buffers to keep track of

-- Function to add buffer to the list of closed buffers
function Add_to_closed_buffers(bufnr)
    if #closed_buffers >= max_buffers then
        table.remove(closed_buffers, 1)  -- Remove the oldest buffer if we reach the limit
    end
    table.insert(closed_buffers, bufnr)
end

-- Function to handle buffer deletion event
vim.api.nvim_create_autocmd("BufDelete", {
    pattern = "*",
    callback = function()
        local bufnr = vim.fn.expand("<abuf>")  -- Get the buffer number of the deleted buffer
        Add_to_closed_buffers(bufnr)  -- Call the function with correct name
    end
})

-- Function to reopen the last closed buffer
function Reopen_last_closed_buffer()
    if #closed_buffers == 0 then
        print("No closed buffers to reopen.")
        return
    end

    local bufnr = table.remove(closed_buffers)  -- Get the last closed buffer
    vim.cmd('buffer ' .. bufnr)  -- Switch to the buffer
end

-- Set the key mapping to call the Reopen_last_closed_buffer
wk.mappings["bu"] = { "<cmd>lua Reopen_last_closed_buffer()<CR>", "Re-open last buffer"}
```

## Telescope

### Useful pickers

buffers
command_history
search history or resume (see what's better)
old files
live grep args
keymaps (searchable list of keymaps)
maybe quickfix?
jumplist

interesting but need to think about use cases:
current_buffer_fuzzy_find

What's difference between fd and findfiles?

If you get that `gr` or `Telescope lsp_references` does not work: `method textDocument/references is not supported by any of the servers registered for the current buffer` - upgrade or install the newest node version (use nvm!)

### Telescope-frecency
I tried telescope-frecency, but I'm not sure if it's the best solution for me: 
1) It does not display buffer numbers that you can enter to switch to that buffer as telescope does
2) I'm not sure I need a 'frequent' metrics here, I just usually need the recent files list (like VSCode does).
So, for that for now I try to use this:
`wk.mappings["bs"] = { "<cmd>Telescope buffers sort_mru=true<CR>", "Select Buffer" }`

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

### All plugins
https://github.com/rockerBOO/awesome-neovim

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

For multifile use telescope, search for some text that you want to replace (e.g.`repace_this`),
then `<C-q>` opens in quick fix window, then `:cdo s/replace_this/with_this/g`

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

### Note taking and Obsidian
https://github.com/epwalsh/obsidian.nvim
https://www.reddit.com/r/neovim/comments/18qcyah/notetaking_with_nvim_and_obsidian/

### Plugins to help learn and practice Vim
https://github.com/m4xshen/hardtime.nvim
https://www.reddit.com/r/neovim/comments/14jferq/hardtimenvim_a_neovim_plugin_helping_you/
Good thing is this plugin disables Arrow Keys by default.

### Git plugins
https://github.com/lewis6991/gitsigns.nvim has built-in support for inline git-blame,
but I like https://github.com/f-person/git-blame.nvim much better - 
you can open commit URLs (I bound a U key to leader-g where LunarVim has Git to this).
It also allows you to set [c ]c to navigate between changed hunks in a buffer!

I tried https://github.com/airblade/vim-gitgutter, 
but built-in gitsigns is much better integrated with other gutter plugins like LSP

https://github.com/rhysd/conflict-marker.vim - Doesn't work for me with any theme...

### Plugins to test in future
This plugin can be useful but for now I just use the script that it is based on (the link is in Readme in plugin GitHub):
https://github.com/axkirillov/hbac.nvim?tab=readme-ov-file
https://github.com/smartpde/telescope-recent-files
I could not get it to work properly although is sounds promising:
https://github.com/dzfrias/arena.nvim

### Pluging that I tried and didn't use

#### Lazygit


I think it's useful in some cases, but I prefer using terminal commands - it gives me auto suggestions for commit messages from previous commits and also when pre-commit hooks fail I don't have to re-add all the files again - I just repeat the previous command in terminal and I don't have to enter the same commit message again - I repeat the same command from the terminal.  It's useful for fixing up or squashing commits in rebase, for cherry picking commits, for a very simple and straightforward add commit push flow (just press space on the top level of files, c+ commit message and P). 

## Colors

### Customize a colorschema without modifying it directly (with autocommands)
https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f

### Different colorscheme for different files types
https://www.reddit.com/r/neovim/comments/ynm6n6/different_colorscheme_by_filetype/

I asked ChatGPT to write a script for this and it's not ideal but sometimes works:
```lua
vim.cmd [[
  augroup CustomHighlights
    autocmd!
    autocmd FileType markdown colorscheme cyberdream
    autocmd BufLeave *.md if &ft == 'markdown' | colorscheme sonokai | endif
    autocmd BufEnter * if &ft != 'markdown' | colorscheme sonokai | endif
  augroup END
]]
```

### Customize highlights after setting the colorscheme
Example of changing color for selection (Visual mode)
vim.cmd [[
  augroup CustomHighlights
    autocmd!
    autocmd ColorScheme sonokai highlight Visual guibg=#fef5e7  
  augroup END
]]

## Working with different layouts (languages)
You can specify `vim.opt.keymap = 'ukrainian-jcuken'` and it will use Ukrainian layout for Insert mode, but English for all the rest. 
You can switch layouts (2 only) in Insert mode with `Ctrl+6`.

To see all layouts in vim: `:e $VIMRUNTIME/keymap`

Taken from here:
https://stackoverflow.com/questions/3776728/how-to-avoid-constant-switching-to-and-from-english-keyboard-layout-to-type-vim
https://www.reddit.com/r/vim/comments/ijgm0w/using_vim_with_nonlatin_language/

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

## Tips and Tricks
https://blog.devgenius.io/editing-in-lunar-vim-is-magic-17-more-lvim-tips-and-tricks-598ba7f4f6d6

### M key on Mac

https://www.lunarvim.org/docs/beginners-guide/keybinds-overview
iTerm2: go to Settings->Profiles-Keys and set Option to be `Esc+` in your profile (not just default profile, play with the profiles there if you don't know which profile is currently used).

#### Opening files in normal mode

When running tests, you can go to the specific test by searching its name (`leader+s+w` in my setup) and then Telescope is opened with your file. Need also to consider going to a file (`gf`) by selecting the path to the test (without the test class name etc.) but that does not work yet without `.py` in the end (look for some plugins).


#### Keymaps
Bind bn and bp to ctrl+tab? Doesn't work well in some terminals (didn't work in iTerm2 on Mac)


