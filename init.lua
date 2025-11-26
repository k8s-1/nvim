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
--- 1. configs in https://github.com/neovim/nvim-lspconfig
--- copy to ./lua/<language-server>.lua
---
--- 2. (!) install language server via mason
---
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

local lsps = {
    "lua_ls",
    "rust_analyzer",
    "bashls",
    "yamlls",
    "gopls",
    "eslint",
}

for _, lsp in ipairs(lsps) do
    vim.lsp.enable(lsp)
end

--- LSP
