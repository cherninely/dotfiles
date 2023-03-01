local present, null_ls = pcall(require, "null-ls")
if not present then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
    debug = false,
    sources = {
        diagnostics.tsc,

        code_actions.eslint,
        code_actions.refactoring,

        completion.vsnip,

        formatting.prettier,
    },
})
