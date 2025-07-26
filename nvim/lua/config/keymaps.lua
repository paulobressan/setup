local map = vim.keymap.set

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })


-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

-- tab buffers
map("n", "<Tab>", ":bnext<CR>", { desc = "Next tab buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Next tab buffer" })
map("n", "<C-c>", ":bdelete<CR>", { desc = "Close buffer" })

-- Oil
map("n", "<leader>o", ":Oil --float<CR>", { desc = "Open oil file explorer" })

-- -- Folder
-- vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
-- vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })
-- vim.keymap.set("n", "za", "za", { desc = "Toggle fold under cursor" })
-- vim.keymap.set("n", "zo", "zo", { desc = "Open fold under cursor" })
-- vim.keymap.set("n", "zc", "zc", { desc = "Close fold under cursor" })
-- vim.keymap.set("n", "zj", "zj", { desc = "Move to next fold" })
-- vim.keymap.set("n", "zk", "zk", { desc = "Move to previous fold" })
