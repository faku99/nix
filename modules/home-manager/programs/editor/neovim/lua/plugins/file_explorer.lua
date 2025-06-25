vim.keymap.set('n', '-', '<cmd>Oil<cr>')

---@type oil.setupOpts
return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = {
    {
        'echasnovski/mini.icons', opts = {}
    }
  },
  lazy = false,
}
