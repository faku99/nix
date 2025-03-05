local opt = vim.opt

-- Tabs, indent
opt.expandtab = true    -- Use spaces instead of tabs
opt.shiftwidth = 4      -- Shift 4 spaces when pressing <Tab>
opt.tabstop = 4         -- 1 tab equals 4 spaces
opt.smartindent = true  -- Auto-indent new lines

-- Basic
opt.mouse = 'a' -- Enable mouse support in all modes