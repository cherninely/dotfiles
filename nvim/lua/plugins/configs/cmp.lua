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

require("luasnip/loaders/from_vscode").lazy_load()

-- If we are in a TS file, make all JS snippets available too.
luasnip.filetype_extend("typescript", { "jsdoc" })
luasnip.filetype_extend("typescriptreact", { "typescript", "jsdoc" })

local types = require("cmp.types")

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local function deprioritize_snippet(entry1, entry2)
    if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then return false end
    if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then return true end
end

local buffer_option = {
    -- Complete from all visible buffers (splits)
    get_bufnrs = function()
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
        end
        return vim.tbl_keys(bufs)
    end
}

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
        ['<CR>'] = cmp.config.disable, -- Я не люблю, когда вещи автодополняются на <Enter>
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
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
        { name = 'nvim_lsp',                priority_weigh = 9 },                     -- LSP 👄
        { name = 'nvim_lsp_signature_help', priority_weigh = 8 },                     -- Помощь при введении параметров в методах 🚁
        { name = 'luasnip',                 priority_weigh = 7, max_item_count = 8 }, -- Luasnip 🐌
        { name = "codeium", priority_weigh = 7, max_item_count = 3 }, -- AI
        {
            name = 'buffer',
            priority_weigh = 7,
            keyword_length = 5,
            option = buffer_option,
            max_item_count = 8,
        },                                         -- Буфферы 🐃
        { name = 'path',    priority_weigh = 9 },  -- Пути 🪤
        { name = "emoji",   priority_weigh = 10 }, -- Эмодзи 😳
    }),

    sorting = {
        comparators = {
            deprioritize_snippet,
            cmp.config.compare.exact,
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.sort_text,
            cmp.config.compare.order,
        },
    },

    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        })
    },
}
