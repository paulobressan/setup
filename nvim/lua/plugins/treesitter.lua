return {
  "nvim-treesitter/nvim-treesitter",
  opts = {},
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "rust",
        "lua",
        "typescript",
        "javascript",
        "markdown",
        "tsx",
        "vue",
        "html",
        "css",
        "terraform",
        "go"
      },

      highlight = {
        enable = true,
        use_languagetree = true,
      },

      indent = { enable = true }
    })
  end
}
