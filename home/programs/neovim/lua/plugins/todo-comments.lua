return {
  -- Highlight todo, notes, etc in comments
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim', },
  cond = not vim.g.vscode,
}