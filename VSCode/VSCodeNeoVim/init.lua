if vim.g.vscode then
    -- VSCode extension
    -- Taken from https://medium.com/@shaikzahid0713/integrate-neovim-inside-vscode-5662d8855f9d
    -- Create vscode directory within nvim config and then add settings.vim inside it
    vim.cmd[[source $HOME/.config/nvim/vscode/settings.vim]]
else
    -- ordinary Neovim
    require "alpha-config"
    require "autopairs-config"
    require "bufferline-config"
    require "git-config"
    require "hop-config"
    require "indentline-config"
    require "lualine-config"
    require "lsp-config"
    require "nvim-tree-config"
    require "telescope-config"
    require "toggleterm-config"
    require "treesitter-config"
    require "undotree-config"
    require "whichkey"

    
-- " Better nav for omnicomplete TODO figure out why this is being overridden
-- inoremap <expr> <c-j> ("\<C-n>")
-- inoremap <expr> <c-k> ("\<C-p>")

end
