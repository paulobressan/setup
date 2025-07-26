local servers        = { "lua_ls", "jsonls", "yamlls", "html", "terraformls", "gopls" }
local manual_servers = { "vtsls", "vue_ls", "rust_analyzer" }
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
      "neovim/nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig.nvim",
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
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

      local on_init = function(client, _)
        if client.supports_method("textDocument/semanticTokens") then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end

      local lsp = vim.lsp

      -- Auto servers
      for _, name in ipairs(servers) do
        lsp.config(name, {
          on_attach    = on_attach,
          on_init      = on_init,
          capabilities = capabilities,
        })
      end
      lsp.enable(servers)

      lsp.config("vue_ls", {
        on_attach    = on_attach,
        on_init      = on_init,
        capabilities = capabilities,
        handlers     = {
          ["tsserver/request"] = function(_, result, context)
            local clients = lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            if #clients == 0 then
              vim.notify('Could not find `vtsls`, `vue_ls` requires it.', vim.log.levels.ERROR)
              return
            end

            local ts_client = clients[1]
            local param = result[1] -- Fix unpack
            local id, command, payload = table.unpack(param)

            ts_client:exec_cmd({
              title = 'vue_request_forward',
              command = 'typescript.tsserverRequest',
              arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
              local response_data = { { id, r.body } }
              context.client.notify('tsserver/response', response_data)
            end)
          end,
        },
      })
      lsp.enable("vue_ls")

      local vue_language_server_path = vim.fn.expand("$MASON/packages/vue-language-server" ..
        "/node_modules/@vue/language-server")
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      lsp.config("vtsls", {
        on_attach    = on_attach,
        on_init      = on_init,
        capabilities = capabilities,
        settings     = {
          vtsls = {
            tsserver = {
              globalPlugins = { vue_plugin },
            },
          },
        },
        filetypes    = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      })
      lsp.enable("vtsls")

      -- Rust Analyzer
      local features = {}
      for feat in (os.getenv("LSP_RUST_FEATURES") or ""):gmatch("([^,]+)") do
        table.insert(features, vim.trim(feat))
      end
      lsp.config("rust_analyzer", {
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
      lsp.enable("rust_analyzer")
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  }
}
