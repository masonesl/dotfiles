vim.filetype.add({
  pattern = {['.*/hypr/.*%.conf'] = 'hyprlang'},
})

vim.filetype.add({
  pattern = {['.*/hypr/.*%.hl'] = 'hyprlang'},
})

vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  pattern = {'*.hl', 'hypr*.conf'},
  callback = function (event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start({
      name = 'hyprlang',
      cmd = {'hyprls'},
      root_dir = vim.fn.getcwd(),
    })
  end
})
