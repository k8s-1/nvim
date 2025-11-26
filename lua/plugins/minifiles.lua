return {
  "echasnovski/mini.files",
  name = "mini-files",
  config = function()
    require("mini.files").setup({
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = false,

        windows = {
          -- Maximum number of windows to show side by side
          max_number = math.huge,
          -- Whether to show preview of file/directory under cursor
          preview = false,
          -- Width of focused window
          width_focus = 50,
          -- Width of non-focused window
          width_nofocus = 15,
          -- Width of preview window
          width_preview = 25,
        },
      },
    })
    vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { noremap = true })

    -- Close                    │ q
    -- Go in entry              │ l
    -- Go in entry plus         │ L
    -- Go out of directory      │ h
    -- Go out of directory plus │ H
    -- Reset                    │ <BS>
    -- Reveal cwd               │ @
    -- Show Help                │ g?
    -- Synchronize              │ =
    -- Trim branch left         │ <
    -- Trim branch right        │ >


    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesWindowOpen',
      callback = function(args)
        local win_id = args.data.win_id

        -- Customize window-local settings
        vim.wo[win_id].winblend = 20
      end,
    })
  end,
}
