local present, mason = pcall(require, 'mason')

if not present then
  return
end

local present, mason_lsp_config = pcall(require, 'mason-lspconfig')

if not present then
  return
end

-- from https://github.com/williamboman/mason-lspconfig.nvim
local servers = {
    'html',                   -- HTML
    'cssls',                  -- CSS
    'eslint', -- eslint
    'emmet_ls',               -- emmet
    'jedi_language_server',   -- Python
    'lua_ls',                 -- Lua
    'ts_ls',                  -- Typescript, Javascript
    'jsonls',                 -- JSON
    'sqls',                   -- SQL
    'marksman',               -- Markdown
    'docker_compose_language_service', -- Docker compose
    'dockerls',               -- Docker
    'bashls',                 -- Bash
}

-- Конфигурируем mason
mason.setup ()

-- Конфигурируем lsp
mason_lsp_config.setup {
    ensure_installed = servers,
    automatic_installation = true,
}

for _, server in pairs(servers) do
    local opts = {
        on_attach = require('plugins.configs.lsp.handlers').on_attach,
        capabilities = require('plugins.configs.lsp.handlers').capabilities,
    }

    local has_user_opts, conf_opts = pcall(require, "plugins.configs.lsp.settings." .. server)
    if has_user_opts then
        opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
end

