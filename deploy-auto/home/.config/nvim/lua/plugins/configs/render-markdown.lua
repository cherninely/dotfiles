local ok, render_markdown = pcall(require, 'render-markdown')
if not ok then
    return
end

render_markdown.setup({
    file_types = { 'markdown' },
    completions = { lsp = { enabled = true } },
    heading = {
        sign = true,
        icons = { '󰼏  ', '󰎨  ', '󰼑  ', '󰎲  ', '󰼓  ', '󰎴  ' },
    },
    code = {
        sign = false,
        width = 'block',
        right_pad = 1,
    },
    checkbox = {
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰡖 ' },
    },
})
