local servers        = { "lua_ls", "jsonls", "yamlls", "html", "terraformls", "gopls" }
local manual_servers = { "ts_ls", "rust_analyzer" }
local formatters     = { "prettier" }
local combine        = vim.tbl_flatten

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      local ensure = combine({ servers, manual_servers, formatters })

      require("mason").setup()

      require("mason-lspconfig").setup()

      require("mason-tool-installer").setup({
        ensure_installed = ensure,
        auto_update = false,
        run_on_start = true,
      })
    end,
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig.nvim",
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach    = function(_, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end

        map("n", "gD", vim.lsp.buf.declaration)
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "gi", vim.lsp.buf.implementation)
        map("n", "<C-k>", vim.lsp.buf.signature_help)
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "[d", vim.diagnostic.goto_prev)
        map("n", "]d", vim.diagnostic.goto_next)
        map("n", "<leader>e", vim.diagnostic.open_float)

        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable()
        end
      end

      local on_init      = function(client, _)
        if client.supports_method("textDocument/semanticTokens") then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end

      -- Auto servers
      for _, name in ipairs(servers) do
        vim.lsp.config(name, {
          on_attach    = on_attach,
          on_init      = on_init,
          capabilities = capabilities,
        })
      end
      vim.lsp.enable(servers)

      -- TypeScript + Vue
      local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server" ..
        "/node_modules/@vue/language-server")
      vim.lsp.config("ts_ls", {
        on_attach    = on_attach,
        on_init      = on_init,
        capabilities = capabilities,
        init_options = {
          plugins = {
            {
              name      = "@vue/typescript-plugin",
              location  = vue_ls_path,
              languages = { "vue" },
            },
          },
        },
        filetypes    = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })
      vim.lsp.enable("ts_ls")

      -- Rust Analyzer
      local features = {}
      for feat in (os.getenv("LSP_RUST_FEATURES") or ""):gmatch("([^,]+)") do
        table.insert(features, vim.trim(feat))
      end
      vim.lsp.config("rust_analyzer", {
        on_attach    = on_attach,
        on_init      = on_init,
        capabilities = capabilities,
        settings     = {
          ["rust-analyzer"] = {
            cargo = { features = features },
            check = { features = features },
          },
        },
      })
      vim.lsp.enable("rust_analyzer")
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  }
}
