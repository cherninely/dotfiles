local present, cmp = pcall(require, "cmp")

if not present then
  return
end

local present, luasnip = pcall(require, "luasnip")

if not present then
  return
end

local present, cmpLsp = pcall(require, "cmp_nvim_lsp")

if not present then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = cmpLsp.update_capabilities(capabilities)

vim.o.completeopt = 'menu,menuone,noselect'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer', opts = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end
        },
    },
},
}
