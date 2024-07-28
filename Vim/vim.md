# Vim/NeoVim notes
- [**Vim keybindings**](#vim-keybindings)
- [**Use system clipboard**](#use-system-clipboard)
- [**Motions (Navigation)**](#motions-navigation)
  - [**`g` motions**](#g-motions)
- [**Deleting words and characters**](#deleting-words-and-characters)
  - [**Delete the first 2 characters of every line**](#delete-first-2-characters-of-every-line-only-if-theyre-spaces)
  - [**Delete the same word/char on multiple lines**](#delete-the-same-wordchar-on-multiple-lines)
  - [**Delete a word under cursor**](#delete-a-word-under-cursor)
  - [**Delete all blank lines**](#delete-all-blank-lines)
- [**Select (to copy) multiple lines in range**](#select-to-copy-multiple-lines-in-range)
- [**Advanced copying, deleting and moving (without moving or selecting, with +/- lines numbers and `:t`/`:d`/`:m`)**](#advanced-copying-deleting-and-moving-without-moving-or-selecting-with---lines-numbers-and-tdm)
- [**Change the same word multiple times**](#change-the-same-word-multiple-times)
- [**Search and Replace**](#search-and-replace)
- [**Surroundings in Vim**](#surroundings-in-vim)
  - [**Copy text inside surrounding characters**](#copy-text-inside-surrounding-characters)
  - [**`vim.surround` plugin**](#vimsurround-plugin)
  - [**Surround words on multiple lines**](#surround-words-on-multiple-lines)
- [**Diffs in vim/nvim**](#diff-in-vim/neovim)
- [**Indentation**](#indentatgon)
- [**Splits**](#splits)
- [**`!` (Bang) commands**](#bang-commands)
- [**Vim apps for MacOSX**](#vim-apps-for-macosx)
- [**Vim for shell**](#vim-for-shell)

See my vim keybindings and settings for VSCode in https://github.com/Perun108/my_notes_and_settings/tree/main/VSCode/VSCodeNeoVim and https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCode%20Vim%20plugin.md

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
`G`	Go To command (prefix with number) (same as `gg`)  
`H` move to top of screen  
`M` move to middle of screen 
`L` move to bottom of screen  
`Ctrl+e` move screen down one line (without moving cursor)  
`Ctrl+y` move screen up one line (without moving cursor)  
`i`	start insert mode at cursor  
`I`	insert at the beginning of the line  
`a`	append after the cursor  
`A`	append at the end of the line  
`o`	open (append) blank line below current line  
`O`	open blank line above current line  
`ea`	append at end of word  
`r`	replace a single character (does not use insert mode)  
`R` replace more than one character, until ESC is pressed  
`J`	join line below to the current one  
`cc`	change (replace) an entire line (same as `S`)  
`cw`	change (replace) to the end of word  
`c$`	change (replace) to the end of line (same as `C`)  
`s`	delete character at cursor and start Insert mode  
`S`	delete line at cursor and start Insert mode (same as `cc`)  
`yy`	yank (copy) a line  
`2yy`	yank 2 lines  
`yw`	yank word  
`y$` or `Y` yank (copy) to end of line  
`yiw` yank (copy) word under the cursor
`yaw` yank (copy) word under the cursor and the space after or before it
`yip` copy entire paragraph
`p`	put (paste) the clipboard after cursor  
`P`	put (paste) before cursor  
`dd`	delete (cut) a line  
`dw`	delete (cut) the current word  
`x`	delete (cut) current character  
`:w`	write (save) the file, but don't exit  
`:wq`	write (save) and quit  
`:q`	quit (fails if anything has changed)  
`:q!`	quit and throw away changes  

2. Buffers/Tabs/Files/Windows hotkeys:  
Buffers
`:e filename`	Edit (create) a file in a new buffer  
`:bnext` (or `:bn`)	go to next buffer  
`:bprev` (of `:bp`)	go to previous buffer  
`:bd`		delete a buffer (close a file)  
`:b<number>` - go to buffer N
`:b#` or `Ctrl+6` - switch between two last opened buffers
`:sp filename`	Open a file in a new buffer and split window  

Splits:
`ctrl+ws`		Split windows  
`ctrl+ww`		Switch between windows  (same as `Ctrl+h/j/k/l/`)
`ctrl+wq`   	Quit a window  
`ctrl+wv`		Split windows vertically  
`:vs#`          Split current window vertically and open the alternate file

Resize:
`Ctrl+w+Left/Right` for vertical splits and `Up/Down` for horizontal (holding `Ctrl`)

`x` is equivalent to `dl` and deletes the character under the cursor  
`X` is equivalent to `dh` and deletes the character before the cursor  
`s` is equivalent to `ch`, deletes the character under the cursor and puts you into Insert mode  
`r` allows you to replace one single character for another. Very handy to fix typos.  
`~` to switch case for a single character  

`i` lets you *i*nsert text before the cursor  
`a` lets you *a*ppend text after the cursor  
`I` lets you *i*nsert text at the beginning of a line  
`A` lets you *a*ppend text at the end of a line  

Additionally:  
`yyp` == `Yp` == `:t.Enter`     
`yyP` == `YP` == `:t-1Enter` == `:t-.`   
`:sav <filepath>` will save the file under `filepath` name and path

## Registers

`:reg` view registers contents

### Use system clipboard

https://superuser.com/questions/1726375/how-can-i-always-yank-text-to-clipboard

`:set clipboard=unnamedplus` in neovim.

To delete something without saving it in a register, you can use the "black hole register": `"_d`  
To copy/paste/delete using system clipboard without `:set` above just `"+y`/ `"+p` /`"+d`  

## Motions (Navigation)

`[[` or `]]` go to prev/next class definition
`[m` or `]m` go to prev/next function definition
``.` go to the position of the last change in this file 
`25|` go to 25th column in a line in normal mode
`$3h` go to the end and then 3 characters to the left ($2b, etc.)

### `g` motions
`gd` go to definition  
`gf` go to file under cursor (e.g. `~/my_notes_and_settings/zsh.md`)  
`gx` open a link under cursor with default browser  
`gt` go to the next tab
`gT` go to the previous tab 
`gj` go cursor down (multi-line text) 
`gk` go cursor up (multi-line text)
`gx` open a link under cursor with browser (Very useful for opening a PR on GitHub after pushing (just like in VSCode)).

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
`:3,5d` - delete lines starting from 3 to 5  
Tip: You can also use the following characters to specify the range:  
`:.,$d` - From the current line to the end of the file  
`:.,1d` - From the current line to the beginning of the file  
`:10,$d` - From the 10th line to the beginning of the file  
`di(` or `dib` - delete inside parentheses  
`da(` or `dab` - delete text inside parentheses (including parentheses)  
`di{` or `diB` - delete inside braces  
`da{` or `daB` - delete text inside braces (including braces)  
`di[` - delete inside brackets  
`da[` - delete text inside brackets (including brackets)  
`di"` - delete inside quotes  
`da"` - delete a quoted text (including quotes)  
`dit` - delete inside tag  
`dat` - delete a tag (including tag)  
`dip` - delete entire paragraph  


### Delete lines
`:g/{pattern}/d` - delete all lines containing pattern
`:g!/{pattern}/d` - delete all lines not containing pattern 

Delete all blank lines
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

## Advanced copying, deleting and moving (without moving or selecting, with +- lines numbers and `:t`/`:d`/`:m`)

Adapted  from [https://jovica.org/posts/vim_advanced_copy/](https://jovica.org/posts/vim_advanced_copy/)

Signs:
minus (-) means above current line  
plus (+) means below current line  
no sign means absolute line number  

To copy a line without selecting, copying it and then pasting:

If your cursor is on the line you want to copy/paste the current line 10 lines above: `:t-10`

Copy/paste current line to 10 lines below: `:t+10`

Copy/paste current line to absolute line 10: `:t10`

To paste multiple lines *range* from N1 to N2 to some line N3 (use -/+ for relative number of lines above/below, no sign for absolute target line number for each N1, N2 or N3): `:N1,N2tN3`

E.g. to copy/paste absolute lines from 3 to 7 to 5 lines below: `:3,7t+5`

to copy/paste relative lines from 7 to 3 lines above current to 5 lines below: `:-7,-3t+5` (make sure to have range in correct order – from -7 to -3).

to copy/paste relative lines from 3 to 7 lines below current to 5 lines above: `:+3,+7t-5` (make sure to have range in correct order – from -7 to -3).

You can skip some of N to copy/paste lines directly above/below the current line immediately above/below it: `:-15,t` copies all lines from relative line 15 above the current up to the line immediately above the current to the line immediately below the current.

You can use `:d` to delete lines in the same vein. Just use `''` to jump back to the previous position.

Unfortunately, `:m[ove]` is not yet implemented in VSCode Vim extension! There is some hope it will be implemented because there is a commit for that and a couple of issues:
[https://github.com/VSCodeVim/Vim/commit/958d598463e2767f3d067e09636701a61c31d348#diff-80801984c94d0f1db829e793854a3fe1720b7454d62b07898a4e705434b64b4b](https://github.com/VSCodeVim/Vim/commit/958d598463e2767f3d067e09636701a61c31d348#diff-80801984c94d0f1db829e793854a3fe1720b7454d62b07898a4e705434b64b4b)
[https://github.com/VSCodeVim/Vim/issues/2472](https://github.com/VSCodeVim/Vim/issues/2472)
[https://github.com/VSCodeVim/Vim/issues/8503](https://github.com/VSCodeVim/Vim/issues/8503)

UPD: Actually, according to this comment https://github.com/VSCodeVim/Vim/issues/2346#issuecomment-568312141 you can enable (at least some) commands that are not yet supported in Vum extension but integrating it with `nvim` (no need to replace Vim extension with NeoVim extension). Just set these:

```json
{
  "vim.enableNeovim":true,
  "vim.neovimPath": "/opt/homebrew/bin/nvim", // Set this to your nvim path (`which nvim`)
}
```

## Change the same word multiple times

Navigate to the start of the word (`f`, `t`, `w` or similar), `c` with some motion (`f` till the last char of the word or `t` to the first char of the next word, etc), then again navigate to the next occurrence (`f`, `t`, etc.) and press `.` 

Or better: navigate to start of the word, press `c` then navigate to the last char of the word and cursor changes to insert mode, then type the new word and press `Esc`, then press `n` and `.`

## Search and Replace
`/pattern`	search for pattern  
`?pattern`	search backward for pattern  
`/pattern\c` - case insensitive search (default)  
`/pattern\C` - case sensitive search  
`n`		repeat search in same direction  
`N`		repeat search in opposite direction  
Replace All:

```
:%s/foo/bar/g
```

Find each occurrence of `'foo'` (in all lines), and replace it with `'bar'`.

For the current line: `:s/foo/bar/` (no `%` sign)

For specific lines:

```
:6,10s/foo/bar/g
```

Delimiter doesn't have to be `/` - it can be any symbol from the numeric row with Shift (`~``!@#$%^&*()-+=[]{}/?.,<>`, but not `_`, `\` or `|`)

If you need to append something to a word you don't have to type it twice, just use `\0` to reference the search word in replace word:

`:s/shift/shifted/` == `:s/shift/\0ed/`

To replace something only on the lines that contain some pattern:

`:g/<search pattern>/s/<old>/<new>` (e.g. to change `is` to `are` on lines containing `there`: `:g/there/s/is/are`)

`:%s/old/new/g` - replace all old with new throughout file  
`:%s/old/new/gc` - replace all old with new throughout file with confirmations  

## Surroundings in Vim

### Copy text inside surrounding characters

If the text is surrounded by only one pair of quotes, in this case double quotes, the most efficient way to copy that text is `yi"`. This will copy (`y`) the text inside the quotes (`i"`), **regardless** of where the cursor originally is. To make this work with single quotes, brackets, parentheses, or something else, simply replace the " with the character surrounding the text.

If the text is surrounded by more than one pair of quotes, however, we must first navigate to the innermost quote before we can copy the text inside. The command above will not work, since it will see the first two quotes with nothing in between them (""). The fastest way to navigate to the first quote is `f"`. Then, press `;` until the cursor is on the innermost quote, and we can now use `yib` (the `ib` command selects the inner block.) to copy the text inside!

### `vim.surround` plugin
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

## Diffs in vim/neovim

To compare two files in neovim:
`vim/nvim/lvim /path/to/file1 /path/to/file2 -d`

## Indentation
Move indentation to left for every line:
`:%normal <<`

## Splits
Taken from https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/splitting-windows/

Splits are awesome. They allow you to divide your workspace into vertical and horizontal split windows:

Use the `:sp {relative-path-to-file}` command to open a file in a horizontal split.
Use the `:vsp {relative-path-to-file}` command to open a file in a vertical split.

These two commands take a filename as an argument. To split the current file use these:

`<CTRL-W> s` to open horizontal split (mnemonic **W**indow and **S**plit).
`<CTRL-W> v` to open a vertical split (mnemonic **V**ertical).

`Ctrl+h/l`: move between explorer and editor or vertically split tabs  
`Ctrl+j/k`: move between horizontally split tabs  

`ZZ` or `Ctrl+wq` - quit a window (`ZQ` without saving)  

## Folds  
`zf` - manually define a fold up to motion (fold three lines: zf3j or zf3Enter)
`za` - toggle fold under the cursor

##  Visual mode (Marking text)  
`o` - move to other end of marked area  
`O` - move to other corner of block  

## `!` (Bang) commands

`:r!<any shell command like cat>` will paste into the current file cursor position the output of any shell command (`:r!cat ~/.zshrc` will paste this file into current file)

`:!sort` will sort selected (in visual mode) lines ASC

`!!date` will insert current datetime (Sun 24 Sep 2023 13:23:09 EDT) and REPLACE the current line

`!!sh` will run the command under cursor and REPLACE the line with its result

## Vim apps for MacOSX

https://kindavim.app/
https://www.homerow.app/

## Vim for shell

Vim mode plugin for zsh: https://github.com/jeffreytse/zsh-vi-mode
