local present, monokai = pcall(require, 'monokai')

if not present then
  return
end

monokai.setup{}
vim.cmd 'colorscheme monokai' -- без этой настройки не применяет тему

