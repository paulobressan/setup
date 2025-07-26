return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- window = {
      --   completion = { border = "rounded" },
      --   documentation = { border = "rounded" },
      -- },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp",                priority = 1000 },
        { name = "nvim_lsp_signature_help", priority = 950 },
        { name = "luasnip",                 priority = 750 },
        { name = "buffer",                  priority = 500, keyword_length = 3 },
        { name = "path",                    priority = 250 },
      },
      formatting = {
        format = function(entry, vim_item)
          -- Add source name to completion items
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lsp_signature_help = "[Sig]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      experimental = {
        ghost_text = true,
      },
    })

    -- Vue-specific configuration
    cmp.setup.filetype('vue', {
      sources = {
        { name = "nvim_lsp",                priority = 1000 },
        { name = "nvim_lsp_signature_help", priority = 950 },
        { name = "luasnip",                 priority = 750 },
        { name = "path",                    priority = 600 },                     -- Higher priority for Vue imports
        { name = "buffer",                  priority = 500, keyword_length = 2 }, -- Lower keyword length for Vue
      }
    })

    -- JavaScript/TypeScript in Vue files
    cmp.setup.filetype({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }, {
      sources = {
        { name = "nvim_lsp",                priority = 1000 },
        { name = "nvim_lsp_signature_help", priority = 950 },
        { name = "luasnip",                 priority = 750 },
        { name = "path",                    priority = 600 },
        { name = "buffer",                  priority = 500, keyword_length = 3 },
      }
    })

    -- Enhanced cmdline completion
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'path' },
        { name = 'cmdline' }
      },
      matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- Search cmdline completion
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
  end
}
