Culled from:
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
6. To see it in action - watch Chris' video https://www.youtube.com/watch?v=g4dXZ0RQWdw