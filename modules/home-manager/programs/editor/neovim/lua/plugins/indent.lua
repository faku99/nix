vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.tabstop = 4

return {
  'nmac427/guess-indent.nvim',
  event = 'BufReadPost',
  config = true,
}
