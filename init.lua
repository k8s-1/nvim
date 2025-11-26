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

--- lazy load plugins
require("lazy").setup("plugins")


--- LSP
---
--- (!) install via mason first
---
--- load settings
require("config.lsp")

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
    local name, config = lsp[1], lsp[2]
    vim.lsp.enable(name)
    if config then
        vim.lsp.config(name, config)
    end
end
--- LSP
