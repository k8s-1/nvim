require("config.keymaps")
require("config.options")
require("config.autocmds")

-- package manager: https://github.com/folke/lazy.nvim
-- :checkhealth lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--- lazy load ./lua/plugins/*.lua
require("lazy").setup("plugins")


--- LSP
---
--- (!) install via mason first
---
--- load settings
require("config.lsp")

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
})

--- load lsp
---
-- to override defaults, see https://github.com/neovim/nvim-lspconfig, use a second { } value
-- {
--     "clangd",
--     {
--         init_options = ...
--     }
-- },

local lsps = {
    { "lua_ls" },
    { "rust_analyzer" },
    { "bashls" },
    { "yamlls" },
    { "gopls" },
    { "eslint" },
}

for _, lsp in pairs(lsps) do
    vim.lsp.enable(lsp)
end
--- LSP
