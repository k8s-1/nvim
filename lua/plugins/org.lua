return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    -- https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua
    require('orgmode').setup({
      org_agenda_files = '~/org/**/*',
      org_default_notes_file = '~/org/life.org',
      org_todo_keywords = { 'TODO', 'DONE' },

    })

    -- fix theme
    vim.schedule(function()
      vim.api.nvim_set_hl(0, "@org.keyword.todo", { fg = "#ffcc00", bold = true }) -- Bright yellow
      vim.api.nvim_set_hl(0, "@org.agenda.deadline", { fg = "#09d0cd", bold = true }) -- Red
    end)

  end,
}
