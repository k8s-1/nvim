return {
  "lewis6991/gitsigns.nvim",
  name = "gitsigns",
  lazy = false,
  config = function()
    require("gitsigns").setup({})
    local gitsigns = require('gitsigns')
    vim.keymap.set('n', '<leader>gt', gitsigns.toggle_current_line_blame)
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk)
  end,
}
