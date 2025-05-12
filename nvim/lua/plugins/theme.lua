return {
  {
    "catppuccin/nvim",
    priority = 1000,
    enabled = true,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    enabled = false,
    config = function()
      vim.cmd.colorscheme "gruvbox"
    end
  },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    enabled = false,
    config = function()
      vim.cmd.colorscheme "gruvbox-material"
      vim.cmd.hi "Normal guibg=#141617 ctermbg=NONE"
      vim.cmd.hi "NormalFloat guibg=#1d2021 guifg=NONE"
      vim.cmd.hi "FloatBorder guibg=#1d2021 guifg=NONE "
    end
  }
}
