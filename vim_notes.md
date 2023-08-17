# Vim/NeoVim notes
- [**Vim keybindings**](#vim-keybindings)
- [** Use system clipboard**](#use-system-clipboard)
- [**Deleting words and characters**](#deleting-words-and-characters)
  - [**Delete the first 2 characters of every line**](#delete-first-2-characters-of-every-line-only-if-theyre-spaces)
  - [**Delete the same word/char on multiple lines**](#delete-the-same-wordchar-on-multiple-lines)
  - [**Delete a word under cursor**](#delete-a-word-under-cursor)
  - [**Delete all blank lines**](#delete-all-blank-lines)
- [**Select (to copy) multiple lines in range:**](#select-to-copy-multiple-lines-in-range)
- [**Change the same word multiple times**](#change-the-same-word-multiple-times)
- [**Surroundings in Vim**](#surroundings-in-vim)
  - [**Copy text inside surrounding characters**](#copy-text-inside-surrounding-characters)
  - [**vim.surround plugin**](#vimsurround-plugin)
  - [**Surround words on multiple lines**](#surround-words-on-multiple-lines)
- [**Indentation**](#indentation)
- [**Vim vs NeoVim for VSCode**](#vim-vs-neovim-for-vscode)
  - [**VSCode features that are needed in any NeoVim IDE**](#vscode-features-that-are-needed-in-any-neovim-ide)
  - [**Chris (LunarVim) keybindings (https://www.youtube.com/watch?v=g4dXZ0RQWdw)**](#chris-lunarvim-keybindings-httpswwwyoutubecomwatchvg4dxz0rqwdw)
  - [**LunarVim**](#lunarvim)

## See my vim keybindings and settings for VSCode in https://github.com/Perun108/my_notes_and_settings/tree/main/VSCode/VSCodeNeoVim

## Vim keybindings

### Two simple steps:
1. Movement/editing/writing Hotkeys:
`h`	move left  
`j`	move down  
`k`	move up  
`l`	move right  
`w`	jump by start of words (punctuation considered words)  
`W`	jump by words (spaces separate words)  
`e`	jump to end of words (punctuation considered words)  
`E`	jump to end of words (no punctuation)  
`b`	jump backward by words (punctuation considered words)   
`B`	jump backward by words (no punctuation)  
`0`	(zero) start of line   
`^`	first non-blank character of line    
`$`	end of line   
`G`	Go To command (prefix with number)  
`i`	start insert mode at cursor  
`I`	insert at the beginning of the line  
`a`	append after the cursor  
`A`	append at the end of the line  
`o`	open (append) blank line below current line  
`O`	open blank line above current line  
`ea`	append at end of word  
`r`	replace a single character (does not use insert mode)  
`J`	join line below to the current one  
`cc`	change (replace) an entire line  
`cw`	change (replace) to the end of word  
`c$`	change (replace) to the end of line  
`s`	delete character at cursor and subsitute text  
`S`	delete line at cursor and substitute text (same as `cc`)  
`yy`	yank (copy) a line  
`2yy`	yank 2 lines  
`yw`	yank word  
`y$`	yank to end of line  
`p`	put (paste) the clipboard after cursor  
`P`	put (paste) before cursor  
`dd`	delete (cut) a line  
`dw`	delete (cut) the current word  
`x`	delete (cut) current character  
`:w`	write (save) the file, but don't exit  
`:wq`	write (save) and quit  
`:q`	quit (fails if anything has changed)  
`:q!`	quit and throw away changes  

2. File/window hotkeys:
`/pattern`	search for pattern  
`?pattern`	search backward for pattern  
`n`		repeat search in same direction  
`N`		repeat search in opposite direction  
`:e filename`	Edit a file in a new buffer  
`:bnext` (or `:bn`)	go to next buffer  
`:bprev` (of `:bp`)	go to previous buffer  
`:bd`		delete a buffer (close a file)  
`:sp filename`	Open a file in a new buffer and split window  
`ctrl+ws`		Split windows  
`ctrl+ww`		switch between windows  
`ctrl+wq`   	Quit a window  
`ctrl+wv`		Split windows vertically  

`x` is equivalent to `dl` and deletes the character under the cursor  
`X` is equivalent to `dh` and deletes the character before the cursor  
`s` is equivalent to `ch`, deletes the character under the cursor and puts you into Insert mode  
`r` allows you to replace one single character for another. Very handy to fix typos.  
`~` to switch case for a single character  

`i` lets you *i*nsert text before the cursor  
`a` lets you *a*ppend text after the cursor  
`I` lets you *i*nsert text at the beginning of a line  
`A` lets you *a*ppend text at the end of a line  

## Use system clipboard

https://superuser.com/questions/1726375/how-can-i-always-yank-text-to-clipboard

`:set clipboard=unnamedplus` in neovim.

To delete something without saving it in a register, you can use the "black hole register": `"_d`  
To copy/paste/delete using system clipboard without `:set` above just `"+y`/ `"+p` /`"+d`  

## Deleting words and characters

### Delete the first 2 characters of every line

`:%normal 2x`

Delete first 2 characters of every line, only if they're spaces: `:%s/^  /`

Note that the last slash is optional, and is only here so that you can see the two spaces. Without the slash, it's only 7 characters, including the :.

### Delete the same word/char on multiple lines
1. Place cursor on first or last word or character
2. Press `Ctrl+v` to enter `Visual Block` mode
3. Use `arrow` keys or `j, k` to select the words/characters you want to delete
4. Press `x` to delete them all at once

### Delete a word under cursor
`daw` : delete the word under the cursor    
`caw` : delete the word under the cursor and put you in `insert` mode 

If you're in the middle of a word,   
`dw` will delete from the cursor to the end of the word, while  
`daw` will delete the entire word along with a space.  
`diw` will delete the entire word without touching whitespace around it.  

### Delete all blank lines
`:g/^$/d` - Remove all blank lines. The pattern `^$` matches all empty lines.  
`:g/^\s*$/d` - Remove all blank lines. Unlike the previous command, this also removes the blank lines that have zero or more whitespace characters (`\s*`).  

## Select (to copy) multiple lines in range
`10GV12G`  
`10GV2j`  

Let's assume you want to highlight from line 10 to line 20. You can use: `10GV20G`  

Breakdown:  
    • `10` enters 10 into the buffer  
    • `G` goes to the line number in the buffer  
    • `V` enters visual line mode  
    • `20` enters 20 into the buffer  
    • `G` goes to the line number in the buffer (Note that `G` means `Shift+g` (capital G))  

## Change the same word multiple times
navigate to the start of the word (`f`, `t`, `w` or similar), `c` with some motion (`f` till the last char of the word or `t` to the first char of the next word, etc), then again navigate to the next occurrence (`f`, `t`, etc.) and press `.` 

Or better: navigate to start of the word, press `c` then navigate to the last char of the word and cursor changes to insert mode, then type the new word and press `Esc`, then press `n` and `.`

## Surroundings in Vim

### Copy text inside surrounding characters

If the text is surrounded by only one pair of quotes, in this case double quotes, the most efficient way to copy that text is `yi"`. This will copy (`y`) the text inside the quotes (`i"`), **regardless** of where the cursor originally is. To make this work with single quotes, brackets, parentheses, or something else, simply replace the " with the character surrounding the text.

If the text is surrounded by more than one pair of quotes, however, we must first navigate to the innermost quote before we can copy the text inside. The command above will not work, since it will see the first two quotes with nothing in between them (""). The fastest way to navigate to the first quote is `f"`. Then, press `;` until the cursor is on the innermost quote, and we can now use `yib` (the `ib` command selects the inner block.) to copy the text inside!

### vim.surround plugin
https://github.com/tpope/vim-surround

Example to surround a word: `ysiw”`. This will surround the current word you are on with double quotes. To surround a selection you have made in visual or visual block mode, use `s”`. No need to start the command with `y`.

To surround a line: `ys$”`

To change any surrounding symbol (like `()`, `{}`, `[]`, `‘’`, `“”` etc) – type anywhere in the line: `cs<old><new>`  
Similarly, to delete any surrounding symbol (like (), {}, [], ‘’, “” etc) – type anywhere in the line: `ds<char>`  

You can also use `vim-surround` by selecting a bit of text in visual mode and then using `S{desired character}`. This will surround your text selection with the desired character.  

### Surround words on multiple lines

What is the easiest way to use VIM for adding quotation marks to first word of each line?
https://stackoverflow.com/questions/60309202/add-double-quotation-mark-to-first-word-of-each-line

1. Record it for one line, using the following keys (with the cursor at the start of the first line):

(`Esc`)`qai"`(`Esc`)`ea"`(`Esc`)`j0q`

Then you can write `NumberOfLines@a` example: `100@a` for a 100 line you want the first word of each to be within "".

2. Using a `:substitute` command and matching the first word by a sequence of non-blank characters:

`:2,$s/\S\+/"&"/`

The `2,$` performs the substitution starting on line 2 and going through the end of the file.

The `\S\+` matches a sequence of non-whitespace characters. It will match the leftmost one and the longest one possible, which corresponds to the first word in each line.

The `&` on the replacement side is substituted for the match itself, so "&" will surround it in double quotes.

UPDATE: You can generalize this to quote the kth word on a line by matching k-1 words before it.

For example, to quote the 4th word:

`:%s/\(\S\+\s\+\)\{3}\zs\S\+/"&"/`

Here the `\(...\)` defines a group of non-whitespace followed by whitespace, the `\{3}` matches 3 of those and the `\zs` marks the beginning of the actual match, so only that part will be replaced.

The net effect is that you're quoting the 4th word of lines that have 4 or more words.

## Indentation
Move indentation to left for every line:
`:%normal <<`

## Vim vs NeoVim for VSCode
NeoVim extension is slightly better in the following:
- it’s a real nvim instance, not an emulator – so:
- it’s faster (maybe)
- you can add any plugin (can’t add plugins to Vim emulator!), but this is relatively irrelevant since I don’t really need to add plugins and Vim emulator already has every plugin I need.
- you can execute any `:` command (Vim emulator doesn’t allow some commands)
- you can navigate between explorer and split tabs with regular vim motions (`Ctrl+h/l`)
- you can have very nice keybindings to `rename`, `create` and `delete` files and directories right within explorer! (this is really useful!!), to `split windows`, etc.
Cons:
- `Ctrl+d/u` doesn’t work in `git diff` window! (in works with Vim!)
- when you move from explorer to tab with `Ctrl+l` sometimes (often or even always!) it drops you into `visual` mode or something and starts to select words and lines with simple `h/j/k/l` motions! (Very annoying!)
- I had issues with motions after some time working in NeoVim plugin (`d$` didn’t work, motions didn’t go anywhere, strange character or whitespace selection that didn’t go away even after Space+n) and had to reload the window. You have to reload window in VSCode quite often because nvim starts misbehaving (just now I got stuck in `INSERT` mode and only `Ctrl+[` or `Ctrl+c` helped but until I again needed to go into insert mode and `Esc` didn't work).
- VSCode crashes often when recording macros with NeoVim.

### VSCode features that are needed in any NeoVim IDE
- multiple cursors (with option to specify case and whole words + to be able to add/remove occurrences)
- inline git blame displayed with option to go to the commit
- rename file in explorer
- global find & replace in all code

### Chris (LunarVim) keybindings (https://www.youtube.com/watch?v=g4dXZ0RQWdw)

https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/keybindings.json

`Ctrl+h/l`: move between explorer and editor or vertically split tabs  
`Ctrl+j/k`: move between horizontally split tabs  

In explorer:
`a`: create file  
`A`: create directory  
`r`: rename file/directory  
`K`: pop-up hover (same as hover with mouse)  

### LunarVim
- if you can’t start `lvim` after installing `cargo` with standard methods (`curl https://sh.rustup.rs -sSf | sh` recommended in Rust dosumentation (https://doc.rust-lang.org/cargo/getting-started/installation.html) or with `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` recommended here https://www.rust-lang.org/tools/install), it’s probably because it’s not added to `PATH` in `.zshrc`, so just add this line to `./zshrc`: `export PATH="${HOME}/.cargo/bin:${PATH}"` and then restart shell with `exec $SHELL`.
