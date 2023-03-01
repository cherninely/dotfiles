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
    'emmet_ls',               -- emmet
    'jedi_language_server',   -- Python
    'lua_ls',                 -- Lua
    'tsserver',               -- Typescript, Javascript
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

local present, lspconfig = pcall(require, "lspconfig")
if not present then
    return
end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require('plugins.configs.lsp.handlers').on_attach,
        capabilities = require('plugins.configs.lsp.handlers').capabilities,
    }

    server = vim.split(server, "@")[1]

    local present, conf_opts = pcall(require, "plugins.configs.lsp.settings." .. server)

    if present then
        opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    lspconfig[server].setup(opts)
end

