local present, cmp = pcall(require, 'cmp')

if not present then
    return
end

local present, lspkind = pcall(require, 'lspkind')

if not present then
    return
end

local present, luasnip = pcall(require, "luasnip")
if not present then
    return
end

require("luasnip/loaders/from_vscode").lazy_load({
    paths = { "~/.local/share/nvim/site/pack/packer/start/friendly-snippets" }
})

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup {
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
            luasnip.lsp_expand(args.body) -- Luasnip expand
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
            ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, { 'i', 'c' }),
            ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 'c' }),
    },

    sources = cmp.config.sources({
        { name = 'luasnip',                 priority_weigh = 2000 }, -- Luasnip 🐌
        { name = 'buffer',                  priority_weigh = 1000 }, -- Буфферы 🐃
        { name = 'path',                    priority_weigh = 500 },  -- Пути 🪤
        { name = 'nvim_lsp',                priority_weigh = 50 },   -- LSP 👄
        { name = 'nvim_lsp_signature_help', priority_weigh = 50 },   -- Помощь при введении параметров в методах 🚁
        { name = "emoji",                   priority_weigh = 10 },   -- Эмодзи 😳
    }),
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        })
    },
}
