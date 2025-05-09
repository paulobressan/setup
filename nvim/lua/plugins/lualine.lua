local error_icon = '󰅚 '
local warn_icon = '󰀪 '
local info_icon = '󰋽 '
local hint_icon = '󰌶 '

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            symbols = { error = error_icon, warn = warn_icon, info = info_icon, hint = hint_icon },
          }
        },
        lualine_c = { "filename" },
        lualine_x = {
          {
            function()
              local result = {}

              local diagnostics_error = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
              if #diagnostics_error > 0 then
                table.insert(result, string.format("%%#%s#%s%d", "DiagnosticError", error_icon, #diagnostics_error))
              end

              local diagnostics_warn = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
              if #diagnostics_warn > 0 then
                table.insert(result, string.format("%%#%s#%s%d", "DiagnosticWarn", warn_icon, #diagnostics_warn))
              end

              local diagnostics_info = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.INFO })
              if #diagnostics_info > 0 then
                table.insert(result, string.format("%%#%s#%s%d", "DiagnosticInfo", info_icon, #diagnostics_info))
              end

              local diagnostics_hint = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.HINT })
              if #diagnostics_hint > 0 then
                table.insert(result, string.format("%%#%s#%s%d", "DiagnosticHint", hint_icon, #diagnostics_hint))
              end

              if #result > 0 then
                return table.concat(result, " ")
              else
                return ""
              end
            end,
            padding = { left = 1, right = 1 },
          },
          "lsp_status",
          "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  end
}
