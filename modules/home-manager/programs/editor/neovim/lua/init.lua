-- Leader key
vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('config')
require('keymaps')
require('lsp')

-------------------------------------------------------------------------------
-- PLUGINS
--
-- Setup 'lazy.nvim'
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
-- Load plugins
require('lazy').setup({
  { import = 'plugins' },
}, {
  -- For Nix
  lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',

  defaults = { lazy = true },
  change_detection = { notify = false },
})
vim.keymap.set('n', '<Leader>zz', '<cmd>Lazy<cr>')
