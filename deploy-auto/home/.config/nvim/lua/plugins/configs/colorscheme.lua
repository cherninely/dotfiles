local present, onedark = pcall(require, 'onedark')

if not present then
    return
end

onedark.setup {}

vim.cmd 'colorscheme onedark' -- без этой настройки не применяет тему
