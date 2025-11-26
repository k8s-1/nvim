-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- " Use tabs for Go files (4 spaces wide)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false -- Use actual tab characters
    vim.opt_local.tabstop = 4       -- Width of a tab character (4 spaces wide)
    vim.opt_local.shiftwidth = 4    -- Indent width for auto-indent (4 spaces)
  end,
})


-- CUE config -> replace with cuelang lsp if available one day
-- treat cue files as javascript for better syntax highlighting and commenting //
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.cue",
  callback = function()
    vim.bo.filetype = "javascript"
  end,
})
-- Set up a keybinding for formatting .cue files with cue fmt when F3 is pressed
vim.api.nvim_set_keymap('n', '<F3>', ':lua FormatCueFile()<CR>', { noremap = true, silent = true })
-- Define a function that runs cue fmt and cue fix on the current file
function FormatCueFile()
  if vim.fn.expand('%:e') == 'cue' then
    vim.cmd('silent !cue fix %')
    vim.cmd('silent !cue fmt %')
    vim.cmd('edit!') -- Reload the file after formatting
  else
    print("Not a CUE file!")
  end
end



-- type laeder + q to open the quickfix list
-- show diagnostics on hold over line
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
        if #line_diagnostics > 0 then
            vim.diagnostic.config({
                virtual_lines = true,
            })
        end
    end,
})
-- disable line diagnostics when moving the cursor
vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
        vim.diagnostic.config({
            virtual_lines = false, -- Disable virtual text when cursor moves
        })
    end,
})
