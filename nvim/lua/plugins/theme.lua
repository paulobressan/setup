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
    end
  }
}
