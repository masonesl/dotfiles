vim.api.nvim_create_user_command('AutoCHeader', function ()
  local header_name = vim.fn.expand('%:t'):gsub('%.', '_'):upper()
  vim.api.nvim_buf_set_lines(0, 0, 1, false, {
    '#ifndef ' .. header_name,
    '#define ' .. header_name})

  local last_line = vim.fn.line('$') + 1
  vim.api.nvim_buf_set_lines(0, last_line, last_line + 3, false, {
    '', '', '',
    '#endif'})
end, {})
