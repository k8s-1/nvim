-- lsp does not require plugins to setup https://neovim.io/doc/user/lsp.html,
-- using plugins just makes it easier to setup
-- otherwise, we could to manually install the lsp server, which
-- is just a binary that communicates locally or remotely via LSP protocol, start it in neovim, and attach
-- it to our active buffer with an autocmd

-- :LspInfo
-- LSP does linting, formatting, and more,
-- it's complex compared to a simple linter

return {
  {
    -- this plugin installs lsp
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end
  },
  {
    -- this plugin enables automatic installation of lsp servers with ensure_installed
    -- rather than using :Mason UI
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- DEFINE WHICH LSP TO INSTALL HERE
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "bashls",
          "yamlls",
          "gopls",
          "eslint",
        }
      })
    end
  },
  {
    -- this plugin binds the language server binary to our buffer
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities() -- EXPOSE cmp_nvim_lsp in completions module to LSP server

      local lspconfig = require('lspconfig')
      -- ADD CONFIG AND AUTOSTART LSP HERE
      lspconfig.rust_analyzer.setup({
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ['rust-analyzer'] = {},
        },
      })
      lspconfig.lua_ls.setup({ capapbilities = capabilities })

      lspconfig.eslint.setup({
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro", "cue" },
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      lspconfig.bashls.setup({ capabilties = capabilities })
      lspconfig.gopls.setup({
        capabilties = capabilities,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true, },
          },
        }
      })
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            filetypes = { "yaml", "yml" },
            schemas = {
              -- https://github.com/redhat-developer/yaml-language-server
              -- https://www.schemastore.org/json/
              ["kubernetes"] = { "*.yaml", "*.yml" },
              ["https://json.schemastore.org/github-workflow"] = "**/workflows/*.{yml,yaml}",
              ["https://json.schemastore.org/github-action"] = "**/action/*.{yml,yaml}",
              ["https://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["https://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
              ["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "*docker-compose*.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-2.0.json"] = ".github/dependabot.{yml,yaml}",
            },
          },
        },
      })

      vim.diagnostic.config({
        virtual_lines = false, -- Enable virtual lines for diagnostics
        signs = true,      -- Show signs in the gutter
        underline = true,  -- Underline problematic text
        update_in_insert = true, -- Update diagnostics in insert mode
        severity_sort = false, -- Do not sort by severity (show all diagnostics)
      })

      -- keymaps attached with autocmd
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function()
          -- these will be buffer-local keybindings
          -- because they only work if you have an active language server
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})

          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
          vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, {})
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
          vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, {})

          vim.keymap.set('n', '<F3>', function() vim.lsp.buf.format({ async = true }) end, {})
        end
      })
    end
  }
}
