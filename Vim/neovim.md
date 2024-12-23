# NeoVim
<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
* [Fonts](#fonts)
* [LazyVim](#lazyvim)
* [Buffers](#buffers)
  * [Navigation between opened buffers](#navigation-between-opened-buffers)
  * [Close unused buffers](#close-unused-buffers)
  * [Re-open closed buffers](#re-open-closed-buffers)
* [File explorer](#file-explorer)
  * [Neo-tree move/cut/copy/paste](#neo-tree-movecutcopypaste)
  * [File Explorer as a floating window](#file-explorer-as-a-floating-window)
* [Terminals](#terminals)
  * [Terminals workflow](#terminals-workflow)
* [Search](#search)
  * [Search with arguments (exclude files, directories, etc.)](#search-with-arguments-exclude-files-directories-etc)
  * [Workflows to search for some text in specific files or folders](#workflows-to-search-for-some-text-in-specific-files-or-folders)
    * [Using Telescope the default `live_grep` -- first search for text and then limit files](#using-telescope-the-default-live_grep----first-search-for-text-and-then-limit-files)
    * [Using Telescope `dir live_grep` plugin -- first limit files and then search for text](#using-telescope-dir-live_grep-plugin----first-limit-files-and-then-search-for-text)
    * [Using Telescope `live_grep_args` plugin](#using-telescope-live_grep_args-plugin)
  * [Search and Replace](#search-and-replace)
    * [Plugins](#plugins)
    * [External tool (`serpl`)](#external-tool-serpl)
    * [Interesting keymaps](#interesting-keymaps)
    * [Useful Posts](#useful-posts)
* [Plugins](#plugins-1)
  * [All plugins](#all-plugins)
  * [Telescope](#telescope)
    * [Adding ignore patterns to telescope](#adding-ignore-patterns-to-telescope)
    * [Useful pickers](#useful-pickers)
* [StatusLine (LuaLine)](#statusline-lualine)
* [Colors](#colors)
  * [Customize a colorschema without modifying it directly (with autocommands)](#customize-a-colorschema-without-modifying-it-directly-with-autocommands)
  * [Different colorscheme for different files types](#different-colorscheme-for-different-files-types)
  * [Customize highlights after setting the colorscheme](#customize-highlights-after-setting-the-colorscheme)
* [Markdown files](#markdown-files)
  * [Formatting text and spell-checking](#formatting-text-and-spell-checking)
* [Working with different layouts (languages)](#working-with-different-layouts-languages)
* [VSCode features that are needed in any NeoVim IDE](#vscode-features-that-are-needed-in-any-neovim-ide)
  * [Troubleshooting](#troubleshooting)
* [Python configs](#python-configs)
  * [Formatters, linters](#formatters-linters)
* [Tips and Tricks](#tips-and-tricks)
  * [Show function signature when you type](#show-function-signature-when-you-type)
  * [neovim as `git diff` or `merge` tool](#neovim-as-git-diff-or-merge-tool)
  * [M key on Mac](#m-key-on-mac)
    * [Opening files in normal mode](#opening-files-in-normal-mode)
    * [Keymaps](#keymaps)
* [Chris (LunarVim) keybindings (<https://www.youtube.com/watch?v=g4dXZ0RQWdw>)](#chris-lunarvim-keybindings-httpswwwyoutubecomwatchvg4dxz0rqwdw)
* [Interesting Keybindings](#interesting-keybidings)
* [NeoVim painpoints](#neovim-painpoints)
<!-- vim-markdown-toc -->

## Installation

How I installed nvim in Ubuntu

I `rm -rf` all directories related to `nvim`

Downloaded appimage from here:
<https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage>

It downloaded it to the `Downloads` folder, so I moved it to a dedicated directory:
`mkdir ~/.nvim`
`mv ~/Downloads/nvim.appimage ~/.nvim/`
`chmod u+x ~/.nvim/nvim.appimage`

Created a symlink to a directory on `PATH` to start nvim with just `nvim`:
`sudo ln -s ~/.nvim/nvim.appimage /usr/local/bin/nvim`

## Fonts

I like the following fonts:
<https://www.nerdfonts.com/font-downloads>

* `SourceCodePro (10)` - there is a Nerd variant at the link above (this is the font I used in Arch linux!)
* `Ubuntu Mono Nerd` from the same link is also good
* `Monaco` font (originally designed for MacOSX -- rounded parentheses, etc) - <https://github.com/Karmenzind/monaco-nerd-fonts>

## LazyVim

Default keybindings: <https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/telescope.lua>

Read https://lazyvim-ambitious-devs.phillips.codes 

## Buffers

### Navigation between opened buffers

1. `:Telescope buffers` or `Space-bf` in LunarVim
2. <https://github.com/j-morano/buffer_manager.nvim> (I mapped it to whichkey space-j)
3. <https://github.com/ThePrimeagen/harpoon/tree/harpoon2>

### Close unused buffers

<https://www.reddit.com/r/neovim/comments/12c4ad8/closing_unused_buffers/>

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
```

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

## File explorer

### Neo-tree move/cut/copy/paste

Relative paths work for me, like if i want to move a file up I can just write `../file-name.extension`
The initial path displayed is also configurable in neo-tree. (<https://github.com/nvim-neo-tree/neo-tree.nvim#longer-example-for-packer>)
I mostly use cut/paste for moving single files out of habit from file explorers.

### File Explorer as a floating window

I tried it, it worked but I didn't like it and I like the default one on the left side better.

Taken from <https://github.com/MarioCarrion/videos/blob/269956e913b76e6bb4ed790e4b5d25255cb1db4f/2023/01/nvim/lua/plugins/nvim-tree.lua>

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

## Terminals

I need a dedicated terminal split just for terminal(s) like in VSCode that I can open with a specific keymap.
I use toggleterm <https://github.com/akinsho/toggleterm.nvim>

Important and useful posts:
<https://www.reddit.com/r/vim/comments/8n5bzs/using_neovim_is_there_a_way_to_display_a_terminal/>
<https://github.com/LazyVim/LazyVim/discussions/193#discussioncomment-5988621>
This way you just press a number and then the keybind and it will open #2, #3, #4,etc additional terminals either horizontally or vertically.
I took config from here: <https://github.com/dpetka2001/dotfiles/blob/main/dot_config/nvim/lua/plugins/toggleterm.lua>

I saw somewhere interesting keymaps for splitting terminals:

`vim.keymap.set("n", "<leader>Tsv", ":vsp term://", { desc = "Open vertical terminal split" })`
`vim.keymap.set("n", "<leader>Tsh", ":sp term://",  { desc = "Open horizontal terminal split" })`

I use customized ToggleTerm plugin for this, but maybe just a keymap would be enough instead of a whole plugin?

### Terminals workflow

1. To have multiple terminals (like in VSCode) you can press <leader>th to open a horizontal terminal
2. Then press 2<leader>th, 3<leader>th to open 2nd and 3rd terminals.
3. To toggle terminals window (not buffer!) press Ctrl+\ (just like VSCode Ctrl+`)
4. Switch between terminals with <leader>ts
5. Name your terminals with <leader>tn

## Search

### Search with arguments (exclude files, directories, etc.)

<https://www.reddit.com/r/neovim/comments/121otka/a_nice_telescope_surprise/>
<https://www.reddit.com/r/neovim/s/4Vn3ZclbCw>
<https://github.com/fdschmidt93/telescope-egrepify.nvim>

### Workflows to search for some text in specific files or folders

#### Using Telescope the default `live_grep` -- first search for text and then limit files

1. Open `Live grep` and search for it
2. Press `Ctrl+e` (my rebinding, original was `Ctrl+Space)` and you'll be taken to select files. Enter files that you want to include or exclude (e.g. `views !tests !services`, etc.)
3. Press `Ctrl+q` to send all filtered files to quickfix list.

#### Using Telescope `dir live_grep` plugin -- first limit files and then search for text

1. Open `Dir live grep` and search for directories that you want to search in - use `Tab` to select the desired directory and then enter the next directory and press `Tab` to select it too. Press `Enter` when you are done. This brings another picker to enter text.
2. Enter text to search.

#### Using Telescope `live_grep_args` plugin

### Search and Replace

For multifile use telescope, search for some text that you want to replace (e.g.`replace_this`),
then `<C-q>` opens in quick fix window, then `:cdo s/replace_this/with_this/g`

#### Plugins

<https://github.com/MagicDuck/grug-far.nvim>
<https://github.com/gabrielpoca/replacer.nvim>
<https://github.com/roobert/search-replace.nvim>
<https://github.com/s1n7ax/nvim-search-and-replace>
<https://github.com/nvim-pack/nvim-spectre>

#### External tool (`serpl`)

<https://github.com/yassinebridi/serpl>
See discussion here:
<https://www.reddit.com/r/neovim/comments/1dmv3cn/i_missed_vs_codes_search_and_replace_so_i_made_a/>

#### Interesting keymaps

`vim.keymap.set('v', '<leader><C-r>', '"hy:%s/\\v<C-r>h//g<left><left>', { desc = "change selection" })`

LazyVim offers `inc-rename.nvim` with similar functionality but:
1. It renames in entire file (not just in selection)
2. Maybe just a keymap would be enough instead of a whole plugin?

#### Useful Posts

<https://www.reddit.com/r/neovim/comments/1eifbfp/searching_and_search_and_replace_is_the_most/>
<https://www.reddit.com/r/neovim/comments/1ebwx8x/how_do_you_all_search_and_replace_multiline/>
<https://www.reddit.com/r/neovim/comments/11ukbgn/how_to_includeexclude_files_in_telescope_live_grep/>
<https://www.youtube.com/watch?v=YzVmdJ41Xkg&t=194s>
<https://www.reddit.com/r/neovim/comments/z2kakf/better_telescope_live_grep_ui/>
<https://www.reddit.com/r/neovim/comments/1ekjctx/how_to_search_like_in_vscode_using_telescope/>
<https://www.reddit.com/r/neovim/comments/1eifbfp/searching_and_search_and_replace_is_the_most/>
<https://www.reddit.com/r/neovim/comments/1egfv2h/advanced_search_in_a_single_tool_any_chances/>

## Plugins

### All plugins

<https://github.com/rockerBOO/awesome-neovim>

### Telescope

#### Adding ignore patterns to telescope

Add the following line to

```lua
config = function()
  telescope.setup({
    defaults = {
      ...
      file_ignore_patterns = { "folder-you-want-to-exclude/", ".*package%-lock%.json" },
```

#### Useful pickers

buffers
command_history
search history or resume (see what's better)
old files
live grep args
keymaps (searchable list of keymaps)
maybe quickfix?
jumplist

Interesting but need to think about use cases:
current_buffer_fuzzy_find

What's the difference between `fd` and `findfiles`?

If you get that `gr` or `Telescope lsp_references` does not work: `method textDocument/references is not supported by any of the servers registered for the current buffer` - upgrade or install the newest node version (use nvm!)

```

### CamelCase and snake_case motions

I tried the more well-known <https://github.com/bkad/CamelCaseMotion>  
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

So, I found this wonderful plugin: <https://github.com/chaoren/vim-wordmotion>  

I just set `vim.g.wordmotion_prefix="\\"` and it all worked as I need!

### Session management (Save and open last opened files (buffers))

At first I used persistence and would open last session with <leader>Ss
<https://github.com/folke/persistence.nvim>)
See also this demo: <https://www.youtube.com/watch?v=Qf9gfx7gWEY&t=490s>

BUT! Then I found out this `auto-session` plugin and it automatically saves your session:
<https://github.com/rmagatti/auto-session>

### Code Structure and Breadcrumbs

<https://github.com/stevearc/aerial.nvim>

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

### Surrounding

Two nice plugins:
<https://github.com/tpope/vim-surround>
<https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md>

I used the first one and kind of got used to it, althoug the second one may seem simpler in terms of keystrokes.

### Note taking and Obsidian

<https://github.com/epwalsh/obsidian.nvim>
<https://www.reddit.com/r/neovim/comments/18qcyah/notetaking_with_nvim_and_obsidian/>

### Plugins to help learn and practice Vim

<https://github.com/m4xshen/hardtime.nvim>
<https://www.reddit.com/r/neovim/comments/14jferq/hardtimenvim_a_neovim_plugin_helping_you/>
Good thing is this plugin disables Arrow Keys by default.

### Git plugins

<https://github.com/lewis6991/gitsigns.nvim> has built-in support for inline git-blame,
but I like <https://github.com/f-person/git-blame.nvim> much better -
you can open commit URLs (I bound a U key to leader-g where LunarVim has Git to this).
It also allows you to set [c ]c to navigate between changed hunks in a buffer!

I tried <https://github.com/airblade/vim-gitgutter>,
but built-in gitsigns is much better integrated with other gutter plugins like LSP

<https://github.com/rhysd/conflict-marker.vim> - Doesn't work for me with any theme...

### Plugins to test in future

This plugin can be useful but for now I just use the script that it is based on (the link is in Readme in plugin GitHub):
<https://github.com/axkirillov/hbac.nvim?tab=readme-ov-file>
<https://github.com/smartpde/telescope-recent-files>
I could not get it to work properly although is sounds promising:
<https://github.com/dzfrias/arena.nvim>

### Plugins I tried and not sure I need them

#### Lazygit

I think it's useful in some cases, but I prefer using terminal commands - it gives me auto suggestions for commit messages from previous commits and also when pre-commit hooks fail I don't have to re-add all the files again - I just repeat the previous command in terminal and I don't have to enter the same commit message again - I repeat the same command from the terminal.  It's useful for fixing up or squashing commits in rebase, for cherry picking commits, for a very simple and straightforward add commit push flow (just press space on the top level of files, c+ commit message and P).

#### Telescope extensions

I tried telescope-frecency, but I'm not sure if it's the best solution for me:

1) It does not display buffer numbers that you can enter to switch to that buffer as telescope does
2) I'm not sure I need a 'frequent' metrics here, I just usually need the recent files list (like VSCode does).
So, for that for now I try to use this:
`wk.mappings["bs"] = { "<cmd>Telescope buffers sort_mru=true<CR>", "Select Buffer" }`

The same goes for these telescope extensions that I tried and didn't like or need them:
<https://github.com/danielfalk/smart-open.nvim>
<https://github.com/FabianWirth/search.nvim> - I tried it and I'm not sure it's useful for me. Maybe better to use all the tabs individually with keymaps...

#### Session management

```lua
{  "folke/persistence.nvim",
  event = "BufReadPre",
  config = function()
    require("persistence").setup({
      dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" }
    })
  end
},
```

```lua
{  'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
    }
  end
}
## StatusLine (LuaLine)

<https://www.lunarvim.org/docs/configuration/appearance/statusline>
LunarVim's lualine modified components are defined here:
<https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/lualine/components.lua>

You can use these and also lualine's components (you can redefine them as well):
<https://github.com/nvim-lualine/lualine.nvim>

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

## Colors

### Customize a colorschema without modifying it directly (with autocommands)

<https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f>

### Different colorscheme for different files types

<https://www.reddit.com/r/neovim/comments/ynm6n6/different_colorscheme_by_filetype/>

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

```lua
vim.cmd [[
  augroup CustomHighlights
    autocmd!
    autocmd ColorScheme sonokai highlight Visual guibg=#fef5e7  
  augroup END
]]
```

## Markdown files

I tried several plugins for `markdown`:
<https://github.com/MeanderingProgrammer/render-markdown.nvim>
<https://github.com/OXY2DEV/markview.nvim>
<https://github.com/epwalsh/obsidian.nvim>

It seems that <https://github.com/MeanderingProgrammer/render-markdown.nvim>
is the most mature and visually nice for my needs.

* `obsidian-nvim` is good too, but I decided to not use Obsidian in neovim due to sync and languages problem (I can't get it to work with typing Ukrainian in Insert mode -- see below).

* `markview.nvim` looks very promising, but is not yet mature enough it seems. See also <https://www.reddit.com/r/neovim/comments/1ekl7rn/markviewnvim_just_had_its_first_proper_release/>
It does not have color highlights as render-markdown does.

I also use `mzlogin/vim-markdown-toc` to generate TOC for markdown file, but it doesn't work always well.

I also use `iamcco/markdown-preview.nvim` to sometimes preview my markdown files in browser.

### Formatting text and spell-checking

`:%!fmt -w 80` seems to break lines in a wrapped text (you perhaps need to `:set unwrap` before that).

## Working with different layouts (languages)

You can specify `vim.opt.keymap = 'ukrainian-jcuken'` and it will use Ukrainian layout for Insert mode, but English for all the rest.
You can switch layouts (2 only) in Insert mode with `Ctrl+6`.

To see all layouts in vim: `:e $VIMRUNTIME/keymap`

Taken from here:
<https://stackoverflow.com/questions/3776728/how-to-avoid-constant-switching-to-and-from-english-keyboard-layout-to-type-vim>
<https://www.reddit.com/r/vim/comments/ijgm0w/using_vim_with_nonlatin_language/>

## VSCode features that are needed in any NeoVim IDE

* multiple cursors (with option to specify case and whole words + to be able to add/remove occurrences)
* inline git blame displayed with option to go to the commit
* rename file in explorer
* global find & replace in all code

### Troubleshooting

I experienced severe lvim lags when I edited my config.lua that had lots of commented out lines (with plugins or settings that I played with).
When I deleted them - lvim again became fast. May be related to this:
<https://github.com/LunarVim/LunarVim/issues/3353>

## Python configs

<https://github.com/LunarVim/starter.lvim/blob/python-ide/config.lua>

I could not make it to work with Python virtual environments for my project.

I tried this:

<https://stackoverflow.com/a/75176846/10466399>

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
<https://stackoverflow.com/a/70416303/10466399>

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

### Formatters, linters

How to add line-length to black and isort args:
I did this: <https://github.com/LazyVim/LazyVim/discussions/2609#discussioncomment-8614808>

## Tips and Tricks

### Show function signature when you type

<https://github.com/ray-x/lsp_signature.nvim>

How to close hover hint when in insert mode (I would do Shift+Ecs in VSCode but here it drops me to Normal mode)
you can use <M-x> to map to Alt+x in insert mode, but it will again pop up when you type another argument.
Perhaps better to get used to it and don't pay much attention to that floating window.

### neovim as `git diff` or `merge` tool

In the `.gitconfig`

```
    [alias] dt = “! args=$@; shift $#; nvim -c \”DiffviewOpen $args\””
```

This is a git alias to open `diffview.nvim`

Run it as follows: `git dt <args>`

<https://blog.devgenius.io/editing-in-lunar-vim-is-magic-17-more-lvim-tips-and-tricks-598ba7f4f6d6>

Diffview as diff and merge tool  
https://github.com/sindrets/diffview.nvim  
https://gist.github.com/Pagliacii/8fcb4dc64937305c19df9bb3137e4cad  

### M key on Mac

<https://www.lunarvim.org/docs/beginners-guide/keybinds-overview>
iTerm2: go to Settings->Profiles-Keys and set Option to be `Esc+` in your profile (not just default profile, play with the profiles there if you don't know which profile is currently used).

#### Opening files in normal mode

When running tests, you can go to the specific test by searching its name (`leader+s+w` in my setup) and then Telescope is opened with your file. Need also to consider going to a file (`gf`) by selecting the path to the test (without the test class name etc.) but that does not work yet without `.py` in the end (look for some plugins).

#### Keymaps

Bind bn and bp to ctrl+tab? Doesn't work well in some terminals (didn't work in iTerm2 on Mac)

## Chris (LunarVim) keybindings (<https://www.youtube.com/watch?v=g4dXZ0RQWdw>)

* if you can’t start `lvim` after installing `cargo` with standard methods (`curl https://sh.rustup.rs -sSf | sh` recommended in Rust dosumentation (<https://doc.rust-lang.org/cargo/getting-started/installation.html>) or with `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` recommended here <https://www.rust-lang.org/tools/install>), it’s probably because it’s not added to `PATH` in `.zshrc`, so just add this line to `./zshrc`: `export PATH="${HOME}/.cargo/bin:${PATH}"` and then restart shell with `exec $SHELL`.

<https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json>
<https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/keybindings.json>

## Interesting Keybindings
```lua
-- Selects the text that was just pasted
vim.keymap.set("n", "<leader>gp", "`[v`]", { desc = "select pasted text" }) 

vim.keymap.set("n", "<leader>mj", ":m .+1<CR>==",     { desc = "Move line down" })
vim.keymap.set("n", "<leader>mk", ":m .-2<CR>==",     { desc = "Move line up" })
vim.keymap.set("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move Line Down in Visual Mode" })
vim.keymap.set("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Move Line Up in Visual Mode" })
```

## NeoVim painpoints
- Swap files (buffers) instead of directly editing files - I always get "The file has been changed since reading it!!!" message although I work exclusively in neovim and you have to figure out which version you need - the one that was changed (sometimes in some git operation) or something else... (Can be solved by custom auto-save function).
- In this line - when you change or delete some code and then do live grep for some of the things that you've just deleted and the things that you deleted are there in the grep results because you forgot to save - IDEs and VSCode have a very useful feature to auto-save when leaving the focus (Can be solved by custom auto-save function).
- git diff shows diff with the committed version, so my local changes are not reflected in it until I commit them, which is something I don't want exactly.
- Search (and Replace)!!!
  - in Telescope - whole words, parts, case sensitive, etc.
  - Search inside folders + exclude folders or filetypes from search
https://www.reddit.com/r/neovim/comments/11ukbgn/how_to_includeexclude_files_in_telescope_live_grep/
https://www.reddit.com/r/neovim/comments/r74647/how_to_live_grep_in_telescope_on_certain_folders/ https://miguelcrespo.co/posts/using-telescope-to-find-text-inside-paths/
  - Previous search input and results in search
https://www.reddit.com/r/neovim/comments/16boaai/is_there_a_way_to_see_my_last_telescope_search/
https://www.reddit.com/r/neovim/comments/phndpv/can_telescope_remember_my_last_search_result/?sort=new
https://github.com/nvim-telescope/telescope-smart-history.nvim
- Telescope FF - sort by mru? - I ended up using telescope-frequecy.nvim plugin.
- Mark an open buffer from another branch that does not exist in the current branch (VSCode strikes through the name of the file).
- How to get code suggestions (actions) on a word (like in VSCode I could Cmd+. and get import suggestions for a class or function).
  - See https://github.com/kiyoon/python-import.nvim
  - https://github.com/ray-x/navigator.lua - Code action under cursor including adding imports + better gd and gr floating windows!
- Spell check for code - nothing worked well, while IDEs and VSCode have excellent spellcheckers.
  - Try spell check for CamelCase etc like in VSCode
https://github.com/kamykn/spelunker.vim
https://github.com/shinglyu/vim-codespell
- Writing notes in a different language with non Roman scrypt.
- Debugging in nvim (especially with Docker).

## What didn't work
- Switching layouts for Insert mode:  
https://github.com/ivanesmantovich/xkbswitch.nvim  
https://github.com/lyokha/vim-xkbswitch  
https://github.com/lyokha/g3kb-switch  

- Writing Obsidian notes in Ukrainian:  
https://www.reddit.com/r/neovim/comments/6s109n/non_uslanguage_in_insert_mode/  
https://github.com/lyokha/vim-xkbswitch  
https://github.com/lyokha/g3kb-switch  
https://github.com/yorik1984/lualine-xkblayout  

- Too raw yet (didn't work well): https://github.com/prochri/telescope-picker-history-action  

https://github.com/nvim-telescope/telescope-smart-history.nvim?tab=readme-ov-file  

- How to debug in nvim? - Especially with docker  
https://www.reddit.com/r/neovim/s/kwdB7vInGD  
https://github.com/mfussenegger/nvim-dap-python/issues/7#issuecomment-755166718

Debug plugins and keymaps:
```lua
  "ChristianChiarulli/swenv.nvim",
  "mfussenegger/nvim-dap-python",
  "nvim-neotest/neotest",
  "nvim-neotest/nvim-nio",
  "nvim-neotest/neotest-python",

wk.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" }
wk.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP" }
wk.mappings["df"] = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
wk.mappings["dF"] = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
wk.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }
-- binding for switching
wk.mappings["C"] = { name = "Python", c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" }, }

-- setup debug adapter
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)
-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})
```

***
This is the snippet that does that: https://github.com/chrisgrieser/.config/blob/fc14b9f798379d61689d25e6767504e3fae82643/nvim/lua/config/autocmds.lua#L125-L168

Remove the `vim.opt.hlsearch = true` and `vim.opt.hlsearch = false` if you do not care for the automatic-nohl.

If you want a more feature rich solution, there is [nvim-hlslens](https://github.com/kevinhwang91/nvim-hlslens) which I used before I came up with the autocmd.

```lua
--------------------------------------------------------------------------------
-- AUTO-NOHL & INLINE SEARCH COUNT
-- Taken from https://github.com/chrisgrieser/.config/blob/fc14b9f798379d61689d25e6767504e3fae82643/nvim/lua/config/autocmds.lua#L125-L168
-- See https://www.reddit.com/r/neovim/comments/1ewodlg/comment/lj2954r/
------@param mode? "clear"
---local function searchCountIndicator(mode)
---  local signColumnPlusScrollbarWidth = 2 + 3 -- CONFIG
---
---  local countNs = vim.api.nvim_create_namespace("searchCounter")
---  vim.api.nvim_buf_clear_namespace(0, countNs, 0, -1)
---  if mode == "clear" then
---    return
---  end
---
---  local row = vim.api.nvim_win_get_cursor(0)[1]
---  local count = vim.fn.searchcount()
---  if count.total == 0 then
---    return
---  end
---  local text = (" %d/%d "):format(count.current, count.total)
---  local line = vim.api.nvim_get_current_line():gsub("\t", (" "):rep(vim.bo.shiftwidth))
---  local lineFull = #line + signColumnPlusScrollbarWidth >= vim.api.nvim_win_get_width(0)
---  local margin = { (" "):rep(lineFull and signColumnPlusScrollbarWidth or 0) }
---
---  vim.api.nvim_buf_set_extmark(0, countNs, row - 1, 0, {
---    virt_text = { { text, "IncSearch" }, margin },
---    virt_text_pos = lineFull and "right_align" or "eol",
---    priority = 200, -- so it comes in front of lsp-endhints
---  })
---end
---
----- without the `searchCountIndicator`, this `on_key` simply does `auto-nohl`
---vim.on_key(function(char)
---  local key = vim.fn.keytrans(char)
---  local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
---  local isNormalMode = vim.api.nvim_get_mode().mode == "n"
---  local searchStarted = (key == "/" or key == "?") and isNormalMode
---  local searchConfirmed = (key == "<CR>" and isCmdlineSearch)
---  local searchCancelled = (key == "<Esc>" and isCmdlineSearch)
---  if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then
---    return
---  end
---
---  -- works for RHS, therefore no need to consider remaps
---  local searchMovement = vim.tbl_contains({ "n", "N", "*", "#" }, key)
---
---  if (searchCancelled or not searchMovement) and not searchConfirmed then
---    -- vim.opt.hlsearch = false
---    searchCountIndicator("clear")
---  elseif searchMovement or searchConfirmed or searchStarted then
---    -- vim.opt.hlsearch = true
---    vim.defer_fn(searchCountIndicator, 1)
---  end
---end, vim.api.nvim_create_namespace("autoNohlAndSearchCount"))
```
