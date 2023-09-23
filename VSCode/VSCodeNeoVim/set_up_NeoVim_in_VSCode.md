Gleaned from:
- https://www.youtube.com/watch?v=g4dXZ0RQWdw
- https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
- https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/keybindings.json
- https://medium.com/@shaikzahid0713/integrate-neovim-inside-vscode-5662d8855f9d

Steps:
1. Install [Neovim](https://neovim.io/)
2. [Optional] Create a new folder `vscode` inside `nvim` config to keep `nvim` configs separated 
3. Install `NeoVim` and `WhichKey` extensions
4. Add settings provided in `NeoVim` extension page [Installation section](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim#installation) - all these settings are there in my [settings.json](https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCodeNeoVim/settings.json) and [init.lua](https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCodeNeoVim/init.lua):  
  a) Set the Neovim path  
  b) Set the vim init path   
  c) Modify `init.lua` to determine if `NeoVim` is running in `VSCode` with correct path to `settings.vim` inside `nvim` directory (see my [init.lua](https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCodeNeoVim/init.lua))  
5. Copy 3 files:  
    a) [settings.json](https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCodeNeoVim/settings.json) into VSCode `.../User/settings.json`  
    b) [keybindings.json](https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCodeNeoVim/keybindings.json) into VSCode `.../User/keybindings.json`  
    c) [settings.vim](https://github.com/Perun108/my_notes_and_settings/blob/main/VSCode/VSCodeNeoVim/settings.vim) into `vscode` folder inside `nvim` config folder (`~/.config/nvim/vscode/settings.vim`)  
6. To see it in action - watch Chris' video https://www.youtube.com/watch?v=g4dXZ0RQWdw`

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