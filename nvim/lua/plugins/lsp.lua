local servers = {
  "lua_ls",
  "rust_analyzer",
  "tsserver",
  "jsonls",
  "yamlls"
}

local map = vim.keymap.set

local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "<leader>e", vim.diagnostic.open_float, opts)
  map("n", "[d", vim.diagnostic.goto_prev, opts)
  map("n", "]d", vim.diagnostic.goto_next, opts)
  map("n", "<leader>q", vim.diagnostic.setloclist, opts)
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
end

local on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = servers
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { 0 })
      end

      local lspconfig = require("lspconfig")
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          on_init = on_init,
          capabilities = capabilities,
        }
      end
    end
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  }
}
