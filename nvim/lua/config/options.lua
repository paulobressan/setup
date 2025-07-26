vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true

-- default relativenumber
vim.opt.relativenumber = true

-- folder
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false  -- Start with folds open
vim.opt.foldlevel = 99      -- Start with everything unfolded
vim.opt.foldlevelstart = 99 -- Start with everything unfolded
