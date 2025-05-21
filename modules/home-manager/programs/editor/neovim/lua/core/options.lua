local opt = vim.opt

-- Make line numbers default
vim.opt.number = true;

-- Tabs and indent
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Whitespaces
opt.list = true
opt.listchars = { tab = '» ', space = '·', nbsp = '␣', trail = '~' }

-- Show cursor line
opt.cursorline = true
