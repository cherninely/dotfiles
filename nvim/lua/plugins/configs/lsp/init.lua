local present, _ = pcall(require, "lspconfig")
if not present then
    return
end

require "plugins.configs.lsp.mason"
require("plugins.configs.lsp.handlers").setup()
require "plugins.configs.lsp.null-ls"
