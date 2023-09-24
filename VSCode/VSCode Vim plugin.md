Set up new keybinding for moving a line up/down - `Alt+j/k`:  
`Alt+j` == `Alt+Down` == `yyp` == `Yp` == `:t.Enter`  
`Alt+k` == `Alt+Up` == `yyP` == `YP` == `:t-1Enter` == `:t-.`  

Unfortunately, many `Ex` commands (like`:m[ove]`, `:g`, `:sav`, etc) are not yet implemented in VSCode Vim extension! There is some hope it will be implemented because there is a commit for that and a couple of issues:
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

## Added to my VSCode settings.json

"vim.normalModeKeyBindings": [

Add zz to Ctrl+d/u to center cursor when scrolling half page:
```json
{
"before": [
"<C-u>" 
],
"after": [
"<C-u>", "z", "z"
]
},
{"before": [
"<C-d>"
],
"after": [
"<C-d>", "z", "z"
]
},
```

Add `zz` to navigating to next/previous search result:
```json
{
"before": [ "n" ],
"after": [ "n", "z", "z" ]
},
{
"before": [ "N" ],
"after": ["N", "z", "z"]
}
```

Bind `ctrl+n` to turn off search highlighting and `<leader>w` to save the current file:
```json
{
"before":["<C-n>"],
"commands": [
":nohl",
]
},
```
  

## From Vim plugin Readme page
### 🖱️ Multi-Cursor Mode

**:warning:** Multi-Cursor mode is experimental. Please report issues in our feedback thread.

Enter multi-cursor mode by:

On OSX, `cmd-d`. On Windows, `ctrl-d`.

`gb`, a new shortcut we added which is equivalent to `cmd-d` (OSX) or `ctrl-d` (Windows). It adds another cursor at the next word that matches the word the cursor is currently on.

Running "Add Cursor Above/Below" or the shortcut on any platform.

Once you have multiple cursors, you should be able to use Vim commands as you see fit. Most should work; some are unsupported (ref PR#587).

Each cursor has its own clipboard.

Pressing `Escape` in Multi-Cursor Visual Mode will bring you to Multi-Cursor Normal mode. Pressing it again will return you to Normal mode.

### **CamelCaseMotion**

Based on CamelCaseMotion, though not an exact emulation. This plugin provides an easier way to move through camelCase and snake_case words.

  Setting Description Type Default Value

`vim.camelCaseMotion.enable` Enable/disable CamelCaseMotion Boolean false

Once CamelCaseMotion is enabled, the following motions are available:

Motion Command Description

`<leader>w` Move forward to the start of the next camelCase or snake_case word segment

`<leader>e` Move forward to the next end of a camelCase or snake_case word segment

`<leader>b` Move back to the prior beginning of a camelCase or snake_case word segment

`<operator>i<leader>w` Select/change/delete/etc. the current camelCase or snake_case word segment

By default, `<leader>` is mapped to `\`, so for example, `d2i\w` would delete the current and next camelCase word segment.

## 🎩 VSCodeVim tricks!

VS Code has a lot of nifty tricks and we try to preserve some of them:

`gd` - jump to definition.

`gq` - on a visual selection reflow and wordwrap blocks of text, preserving commenting style. Great for formatting documentation comments.

`gb` - adds another cursor on the next word it finds which is the same as the word under the cursor.

`af` - visual mode command which selects increasingly large blocks of text. For example, if you had "blah (foo [bar 'ba|z'])" then it would select 'baz' first. If you pressed af again, it'd then select [bar 'baz'], and if you did it a third time it would select "(foo [bar 'baz'])".

`gh` - equivalent to hovering your mouse over wherever the cursor is. Handy for seeing types and error messages without reaching for the mouse!

## 📚 F.A.Q.

### None of the native Visual Studio Code `ctrl` (e.g. `ctrl+f`, `ctrl+v`) commands work

Set the `useCtrlKeys` setting to false.

### Moving j/k over folds opens up the folds

Try setting `vim.foldfix` to `true`. This is a hack; it works fine, but there are side effects (see issue#22276).

### There are annoying intellisense/notifications/popups that I can't close with <esc>! Or I'm in a snippet and I want to close intellisense

Press `shift+Esc` to close all of those boxes.

