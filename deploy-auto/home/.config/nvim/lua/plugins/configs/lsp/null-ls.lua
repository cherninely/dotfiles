local present, null_ls = pcall(require, "null-ls")
if not present then
    return
end

-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
    debug = false,
    sources = {
        code_actions.refactoring,

        completion.vsnip,

        formatting.prettier,
    },
})

-- formating after save
vim.cmd("autocmd BufWritePost * lua vim.lsp.buf.format()")
