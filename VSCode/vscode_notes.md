# Table of contents
- [Table of contents](#table-of-contents)
  - [**My VSCode notes**](#my-vscode-notes)
  - [**Sync between computers (without SettingsSync via GitHub)**](#sync-between-computers-without-settingssync-via-github)
  - [**Python virtual envs and interpreter**](#python-virtual-envs-and-interpreter)
    - [**Selecting Interpreter for the virtual environment**](#selecting-interpreter-for-the-virtual-environment)
  - [**Using VSCode as your Git editor, difftool, and mergetool**](#using-vscode-as-your-git-editor-difftool-and-mergetool)
    - [**Make VSCode your default Git editor**](#make-vscode-your-default-git-editor)
    - [**Make VS Code your default Diff Tool**](#make-vs-code-your-default-diff-tool)
    - [**Make VS Code your default Merge Tool**](#make-vs-code-your-default-merge-tool)
  - [**Themes and Colors**](#themes-and-colors)
  - [**Custom settings**](#custom-settings)
    - [**Change tabs with `ctrl+tab` without dropdown menu**](#change-tabs-with-ctrltab-without-dropdown-menu)
    - [**Fix Alt key behavior for some zsh plugins**](#fix-alt-key-behavior-for-some-zsh-plugins)
    - [**Auto copy selected text from terminal to clipboard**](#auto-copy-selected-text-from-terminal-to-clipboard)
    - [**How many lines are shown above/below cursor**](#how-many-lines-are-shown-abovebelow-cursor)
    - [**Make diff colors more distinct**](#make-diff-colors-more-distinct)
  - [**Some links to settings, tips, tutorials**](#some-links-to-settings-tips-tutorials)
  
# My VSCode notes

## Sync between computers (without SettingsSync via GitHub)  

For my personal projects I use SettingsSync via GitHub, but if you need to sync your settings and extensions without using third-party services, here's how to do that:

1. Copy your settings files that are there in the directory `~/.config/Code/User/` (like `settings.json`, `keybindings.json`, perhaps `snippets` too) from one machine to another.  
2. Install all extensions by pasting into the terminal shell the contents of the file vscode_extensions (this file can be created by CLI: `code --list-extensions | xargs -L 1 echo code --install-extension >> vscode_extensions`).  
3. Set up `zsh` (`~/.zshrc` + custom setting for the theme's prompt – see my_zsh_notes).  

## Python virtual envs and interpreter  

I prefer `poetry`.

### Selecting Interpreter for the virtual environment  

If you encounter `import could not be resolved` error after you created and activated the virtual environment and installed a library that you want to import, then you probably have to select correct interpreter for this env and folder:  
1. Execute `which python` in terminal in your activated virtual env and copy the output.  
2. Open `Command Pallette`.  
3. Type `Select Interpreter`.  
4. Select your folder that you need to select interpreter for.  
5. Select `Enter interpreter path`.  
6. Paste the path from the 1st step into prompt and hit Enter.  
7. Restart VS Code.  

## Using VSCode as your Git editor, difftool, and mergetool  

Taken from https://www.roboleary.net/vscode/2020/09/15/vscode-git.html

Why should you make VS Code your default Git Editor, Diff Tool, or Merge Tool?  
It’s a personal choice! There are many, many options out there. Above all else, your tools should complement your workflow and not impede you.  
I’ll explain my decision and maybe it will give your some insight in to understanding what works best for you. In a sentence, I prefer to do as much as I can in my code editor.  
Here are the situations where I have encountered friction or have an alternate preference:  
1. If I am executing an interactive git command that requires input from me to edit and review a chunk of text, I would prefer to stay in my code editor and stay in the same mental mode.  
2. I haven’t used some of the Linux command-line tools associated with Git such as Nano enough to get the necessary muscle memory, I forget the commands! 🙈 It can be a flow-buster.  
3. I prefer less switching between applications generally. I would prefer to switch to another tab of my code editor rather than a separate window.  
4. For diffing, I prefer viewing it in a GUI-based editor.  
5. Some merge conflicts are demanding, I like to jump to source files to get the complete picture, I can use familiar shortcuts if I can do it in VS Code.  
6. If I can do it all in my code editor, I have a consistent colour theme without further configuration.  

### Make VSCode your default Git editor

`git config --global core.editor 'code --wait'`  

If you prefer that a new window opens each time, add the `--new-window` code flag:
`git config --global core.editor 'code --wait --new-window'`  

If you only want to change it for your current project, run the same command without the `–global` git flag.  

Unhappy and want to go back?  
`git config --global --unset core.editor`  

### Make VS Code your default Diff Tool  

`git config --global diff.tool vscode`  
`git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'`  

This adds the following settings to your global `Git config`:
```
[diff]
	tool = vscode
[difftool "vscode"]
	cmd = code --wait --diff $LOCAL $REMOTE
```

If you’re not feeling VS Code as your Diff Tool, you run the command `git difftool --tool-help` to see more options.  

### Make VS Code your default Merge Tool

`git config --global merge.tool vscode`  
`git config --global mergetool.vscode.cmd 'code --wait $MERGED'`  

This adds the following settings to your global `Git config`:
```
[merge]
    tool = vscode
[mergetool "vscode"]
    cmd = code --wait $MERGED
```

You can paste this in yourself if you prefer.

If you’re not feeling VS Code as your Merge Tool, you run the command `git mergetool --tool-help` to see more options.  

## Themes and Colors

Terminal colors for VSCode:
https://glitchbone.github.io/vscode-base16-term/#/brewer

Most beautiful themes:
- Andromeda (doesn't support color highlighting dicts, sets, lists)
- Monokai Pro (too much of red color - for, in, =, >, but highlights all methods and objects). I use it, but changed background color to full black (`"editor.background": "#000000"`, previously was grey), and also terminal font to Hack. Also set up different custom color highlighting (got on Stackoverflow) – you better set all custom colors and settings specifically for the given color theme - see these parts in my `vscode_settings.md`:

```json
"editor.tokenColorCustomizations": {
    "[Monokai]": {
        "strings": "#ffbb00",
        "textMateRules": [
            {
                "scope": "meta.function-call.generic.python",
                "settings": {
                    "foreground": "#F2777A",
                    "fontStyle": "italic"
                }
            }
        ]
    }
},
"workbench.colorCustomizations": {
        "[Monokai]": {
...
        }
}
```

## Custom settings

For the actual settings see `settings.json`

### Change tabs with `ctrl+tab` without dropdown menu

Use the `Command Palette` with `CTRL+SHIFT+P`, enter `Preferences: Open Keyboard Shortcuts (JSON)`, and hit Enter.

```json
// Place your key bindings in this file to override the defaults
[
// ...
{
"key": "ctrl+tab",
"command": "workbench.action.nextEditor"
},
{
"key": "ctrl+shift+tab",
"command": "workbench.action.previousEditor"
}
]
```

### Fix Alt key behavior for some zsh plugins

For some `zsh` plugins (like `dircycle`, `dirhistory`) to work you have to specify the following setting in `settings.json`:

```json
"terminal.integrated.sendKeybindingsToShell": true // otherwise it will not work (due to the Alt key integrated terminal bindings).
```

### Auto copy selected text from terminal to clipboard

Add `"terminal.integrated.copyOnSelection": true`, to be able have the selected text automatically copied to the clipboard.

### Make diff colors more distinct

```json
"diffEditor.removedTextBackground": "#FF000055",
"diffEditor.insertedTextBackground": "#ffff0055"
```
### How many lines are shown above/below cursor

Use `editor.cursorSurroundingLines` to control how many lines are shown above/below the cursor as it moves towards the boundaries of the editor window (I'm using 4. default is 0).

## Vscode hotkeys

You can simply rename a symbol (function name, class name, etc.) by placing your cursor there and pressing `F2`. it will then replace it in all references too

Navigation: `Ctrl+Shift+.` or `Ctrl+R` (in command pallette)

`Alt + click` to set multiple cursor in different places
`Ctrl + X` - instead of `Ctrl+Shift+K` to delete a line!
`Ctrl + L` - highlight a line and then a line below it!
`Ctrl + F2` - select all occurrenceS in a file (like multiple `Ctrl+D`)

Code Folding at various levels:
`cmd + K + n` - fold code at `n` level; `cmd+K+1`, `cmd+K+2`, 3, 4....
`cmd + K + J` - expand all lines of code.

**Multi-cursor**

Found on the internet
```
`Find in selection` feature is also highly useful. If you highlight some code, press Ctrl+f to open the search menu, then you can press `Alt+l` to only search in the highlighted area.

My favorite productivity tip aside from making my own custom keyboard short cuts is using multiple cursors -  you hold down the Alt key and click somewhere, you’ll put down a new cursor. Each cursor will accept the same key commands at the same time—a handy way to enter boilerplate text on multiple lines at once, for example.

Another way to add cursors is to hold Ctrl+Alt and press the up or down arrow keys. Doing so will insert cursors in the lines above or below the current one—useful for working in columns of text.

Another slick move: You can insert a cursor at every instance of a selected piece of text by hitting Ctrl-Shift-L. You can also control the selection size of multiple cursors by pressing Shift-Alt and the left or right arrow.
```

## Some links to settings, tips, tutorials

https://code.visualstudio.com/docs/editor/editingevolved

Basic Editing: https://code.visualstudio.com/docs/editor/codebasics 

Visual Studio Code Tips and Tricks: https://code.visualstudio.com/docs/getstarted/tips-and-tricks 

Getting Started with Python in VS Code: https://code.visualstudio.com/docs/python/python-tutorial 

Editing Python in Visual Studio Code: https://code.visualstudio.com/docs/python/editing 

**Articles about settings etc.**
https://www.vscodecandothat.com/ 
https://realpython.com/python-development-visual-studio-code/
https://dannys.cloud/10-best-vs-code-extensions-for-python/
https://switowski.com/blog/18-plugins-for-python-in-vscode 
https://www.dunebook.com/best-vscode-python-extensions/ 
https://dev.to/madza/what-does-your-vs-code-setup-look-like-2a6o
https://towardsdatascience.com/top-3-vs-code-extensions-for-python-and-data-science-7462dd4ee530 

**VSCode and ML, DS, AI Resources**
https://docs.microsoft.com/azure/machine-learning/service/how-to-vscode-tools
https://code.visualstudio.com/docs/python/data-science-tutorial