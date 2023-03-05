local present, cmp = pcall(require, 'cmp')

if not present then
  return
end

local present, lspkind = pcall(require, 'lspkind')

if not present then
  return
end

cmp.setup{
     experimental = {
        ghost_text = true
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    snippet = {

        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require'luasnip'.lsp_expand(args.body) -- Luasnip expand
        end,
    },

    -- Клавиши, которые будут взаимодействовать в nvim-cmp
    mapping = {

        -- Вызов меню автодополнения
        ['<C-;>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.config.disable,                      -- Я не люблю, когда вещи автодополняются на <Enter>
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- А вот на <C-y> вполне ок

        -- Используем для того чтобы прервать автодополнение
        ['<C-s>'] = cmp.mapping({
            i = cmp.mapping.abort(), -- Прерываем автодополнение
            c = cmp.mapping.close(), -- Закрываем автодополнение
        }),
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },                -- LSP 👄
        { name = 'nvim_lsp_signature_help' }, -- Помощь при введении параметров в методах 🚁
        { name = 'luasnip' },                 -- Luasnip 🐌
        { name = 'buffer' },                  -- Буфферы 🐃
        { name = 'path' },                    -- Пути 🪤
        { name = "emoji" },                   -- Эмодзи 😳
    }),
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        })
    }
}
