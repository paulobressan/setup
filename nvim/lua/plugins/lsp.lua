local servers        = { "jsonls", "yamlls", "html", "terraformls", "gopls" }
local manual_servers = { "vtsls", "vue_ls", "rust_analyzer", "lua_ls" }
local formatters     = { "prettier" }

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      local ensure = {}
      vim.list_extend(ensure, servers)
      vim.list_extend(ensure, manual_servers)
      vim.list_extend(ensure, formatters)

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
      -- Enhanced capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        float = {
          source = true,
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end

        -- LSP keymaps
        map("n", "gD", vim.lsp.buf.declaration)
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "gi", vim.lsp.buf.implementation)
        map("n", "<C-k>", vim.lsp.buf.signature_help)
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
        map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
        map("n", "<leader>e", vim.diagnostic.open_float)

        -- Workspace management
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end)

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
      local mason_path = vim.fn.stdpath("data") .. "/mason"

      -- Auto servers
      for _, name in ipairs(servers) do
        lsp.config(name, {
          on_attach = on_attach,
          on_init = on_init,
          capabilities = capabilities,
        })
      end
      lsp.enable(servers)

      -- Manual servers
      local manual_configs = {
        lua_ls = function()
          if vim.fn.executable("lua-language-server") == 1 or vim.fn.isdirectory(mason_path .. "/packages/lua-language-server") == 1 then
            lsp.config("lua_ls", {
              on_attach = on_attach,
              on_init = on_init,
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = { 'vim' } },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = { enable = false },
                },
              },
            })
            return true
          else
            vim.notify("lua_ls not found. Install with :MasonInstall lua-language-server", vim.log.levels.WARN)
            return false
          end
        end,

        vue_ls = function()
          local vue_language_server_path = mason_path ..
              "/packages/vue-language-server/node_modules/@vue/language-server"

          if vim.fn.isdirectory(vue_language_server_path) == 1 then
            lsp.config("vue_ls", {
              on_attach = on_attach,
              on_init = on_init,
              capabilities = capabilities,
              init_options = {
                typescript = {
                  tsdk = mason_path .. "/packages/typescript-language-server/node_modules/typescript/lib"
                }
              },
            })
            return true
          else
            vim.notify("Vue Language Server not found. Install with :MasonInstall vue-language-server",
              vim.log.levels.WARN)
            return false
          end
        end,

        vtsls = function()
          local vue_language_server_path = mason_path ..
              "/packages/vue-language-server/node_modules/@vue/language-server"

          if vim.fn.isdirectory(mason_path .. "/packages/vtsls") == 1 then
            local vue_plugin = {
              name = '@vue/typescript-plugin',
              location = vue_language_server_path,
              languages = { 'vue' },
              configNamespace = 'typescript',
            }

            lsp.config("vtsls", {
              on_attach = on_attach,
              on_init = on_init,
              capabilities = capabilities,
              settings = {
                vtsls = {
                  tsserver = {
                    globalPlugins = { vue_plugin },
                  },
                },
              },
              filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
            })
            return true
          else
            vim.notify("vtsls not found. Install with :MasonInstall vtsls", vim.log.levels.WARN)
            return false
          end
        end,

        rust_analyzer = function()
          if vim.fn.executable("rust-analyzer") == 1 or vim.fn.isdirectory(mason_path .. "/packages/rust-analyzer") == 1 then
            local features = {}
            for feat in (os.getenv("LSP_RUST_FEATURES") or ""):gmatch("([^,]+)") do
              table.insert(features, vim.trim(feat))
            end

            lsp.config("rust_analyzer", {
              on_attach = on_attach,
              on_init = on_init,
              capabilities = capabilities,
              settings = {
                ["rust-analyzer"] = {
                  cargo = { features = features },
                  check = { features = features },
                },
              },
            })
            return true
          else
            vim.notify("rust-analyzer not found. Install with :MasonInstall rust-analyzer", vim.log.levels.WARN)
            return false
          end
        end,
      }

      -- Enable manual servers
      for server, config_fn in pairs(manual_configs) do
        if config_fn() then
          lsp.enable(server)
        end
      end
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        notification = {
          window = {
            winblend = 100,
          },
        },
      })
    end,
  }
}
