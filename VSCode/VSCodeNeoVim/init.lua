if vim.g.vscode then
    -- VSCode extension
    vim.cmd[[source $HOME/.config/nvim/vscode/settings.vim]]
else
    -- ordinary Neovim
    -- require "alpha-config"
    -- require "autopairs-config"
    -- require "bufferline-config"
    -- require "git-config"
    -- require "hop-config"
    -- require "indentline-config"
    -- require "lualine-config"
    -- require "lsp-config"
    -- require "nvim-tree-config"
    -- require "telescope-config"
    -- require "toggleterm-config"
    -- require "treesitter-config"
    -- require "undotree-config"
    -- require "whichkey"

    
-- " Better nav for omnicomplete TODO figure out why this is being overridden
-- inoremap <expr> <c-j> ("\<C-n>")
-- inoremap <expr> <c-k> ("\<C-p>")

end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "folke/which-key.nvim",
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    { "tpope/vim-surround" },
    { "tpope/vim-repeat" },
})