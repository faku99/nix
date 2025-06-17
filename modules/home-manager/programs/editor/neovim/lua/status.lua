vim.opt.ruler = true
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.opt.statusline = '%!v:lua.Statusline()'

local format_count = function (format, count)
  if not count or count == 0 then
    return ''
  end

  return string.format(format, count)
end

local format_int = function(num, sep)
  if not sep then
    sep = ','
  end
  if num < 999 then
    return tostring(num)
  else
    num = tostring(num)
    return num:reverse():gsub('(%d%d%d)', '%1' .. sep):reverse():gsub('^,', '')
  end
end

local file_info = function()
  local wc_table = vim.fn.wordcount()

  if not wc_table.visual_words or not wc_table.visual_chars then
    return table.concat({
      '  %{&filetype}', -- Flietype
      '  %{&expandtab?"󱁐 ":"󰌒 "}%{&tabstop}', -- Indent info
      ('  %s lines'):format(format_int(vim.fn.line('$'))),
      ('  %s words'):format(format_int(wc_table.words)),
    })
  else
    local vis_line = math.abs(vim.fn.line('.') - vim.fn.line('v')) + 1

    return table.concat({
      '  ‹›',
      ('  %s lines'):format(format_int(vis_line)),
      ('  %s words'):format(format_int(wc_table.visual_words)),
      ('  %s chars'):format(format_int(wc_table.visual_chars)),
    })
  end
end

local vcs = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end

  local added = format_count(' +%s', git_info.added)
  local changed = format_count(' ~%s', git_info.changed)
  local removed = format_count(' -%s', git_info.removed)

  return table.concat({
    '  ' .. git_info.head,
    added,
    changed,
    removed,
  })
end

local diagnostic_sign = {
  [vim.diagnostic.severity.ERROR] = '',
  [vim.diagnostic.severity.WARN] = '',
  [vim.diagnostic.severity.HINT] = '',
  [vim.diagnostic.severity.INFO] = '',
}

local diagnostics = function()
  local format_diagnostic_count = function(level)
    local sign = diagnostic_sign[level]
    return format_count(' ' .. sign .. '%s', #(vim.diagnostic.get(0, { severity = level })))
  end

  local severity = vim.diagnostic.severity
  return table.concat({
    format_diagnostic_count(severity.ERROR),
    format_diagnostic_count(severity.WARN),
    format_diagnostic_count(severity.INFO),
    format_diagnostic_count(severity.HINT),
  })
end

function Statusline()
  return table.concat({
    ' %t %h%m%r%w',
    vcs(),
    diagnostics(),
    '%=', -- Separator
    file_info(),
    '  ',
  })
end
