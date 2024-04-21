local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

vim.defer_fn(function()
    pcall(require, 'impatient')
end, 0)


local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer сам себя
    use 'wbthomason/packer.nvim'

    -----------------------------------------------------------
    -- ПЛАГИНЫ ВНЕШНЕГО ВИДА
    -----------------------------------------------------------

    -- Цветовая схема
    use {
        'navarasu/onedark.nvim',
        config = function()
            require('plugins.configs.colorscheme')
        end,
        commit = '1fe908fb4acdcee26573e9ccde0de94ec77e5e84',
    }

    use {
        'nvim-tree/nvim-web-devicons',
        commit = 'c3c1dc4e36969370ff589b7025df8ec2e5c881a2',
    }

    --- Информационная строка внизу
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('plugins.configs.lualine')
        end,
        commit = 'e99d733e0213ceb8f548ae6551b04ae32e590c80',
    }

    -- Табы вверху
    use {
        'akinsho/bufferline.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons',
            'moll/vim-bbye'
        },
        config = function()
            require('plugins.configs.bufferline')
        end,
        commit = '3677aceb9a72630b0613e56516c8f7151b86f95c',
    }

    -----------------------------------------------------------
    -- НАВИГАЦИЯ
    -----------------------------------------------------------

    -- Файловый менеджер
    use {
        'nvim-tree/nvim-tree.lua',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require 'nvim-tree'.setup {}
        end,
        commit = '1b453441f4b1a501a6251db4138cf67172d0d5d2',
    }

    -- Замена fzf и ack
    use {
        'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require 'plugins.configs.telescope'
        end,
        commit = 'a3f17d3baf70df58b9d3544ea30abe52a7a832c2',
    }

    -----------------------------------------------------------
    -- LSP и автодополнялка
    -----------------------------------------------------------

    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require 'plugins.configs.treesitter'
        end,
        commit = '1ceaceb9dea9b0bac2162345ee11e47a44e07a70',
    }

    -- Плагин для того чтобы в Neovim была поддержка LSP, он позволяет включать автодополнение, проверку синтаксиса и ещё много прочего
    use {
        'neovim/nvim-lspconfig',
        commit = 'a557dd4d493e6afba3c24ffeb96fa32695f00874',
    }

    -- Standalone UI for nvim-lsp progress. Eye candy for the impatient
    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup {}
        end,
        commit = '688b4fec4517650e29c3e63cfbb6e498b3112ba1',
    }

    -- Добавляет иконки для пунктов автодополнения
    use {
        'onsails/lspkind-nvim',
        config = function()
            require('plugins.configs.lspkind')
        end,
        commit = 'c68b3a003483cf382428a43035079f78474cd11e',
    }

    use {
        'ThePrimeagen/refactoring.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-treesitter/nvim-treesitter' }
        },
        config = function()
            require('refactoring').setup {}
        end,
        commit = '57c32c6b7a211e5a3a5e4ddc4ad2033daff5cf9a',
    }

    -- for formatters and linters
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = 'ThePrimeagen/refactoring.nvim',
        config = function()
            require('plugins.configs.lsp.null-ls')
        end,
        commit = '456cd2754c56c991c5e4df60a807d054c1bc7148',
    }

    -- Позволяет устанавливать LSP-сервера быстро и без боли
    use {
        'williamboman/mason.nvim',
        requires = 'williamboman/mason-lspconfig.nvim',
        config = function()
            require('plugins.configs.lsp')
        end,
        commit = '51228a60d1a5017030429ba38f018ff27a460c76',
    }

    -- Позволяет удобно показывать все ошибки и предупреждения, которые нашел LSP
    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('plugins.configs.trouble')
        end,
        commit = '67337644e38144b444d026b0df2dc5fa0038930f',
    }

    -- Automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
    use {
        'RRethy/vim-illuminate',
        disable = true,
        commit = '49062ab1dd8fec91833a69f0a1344223dd59d643',
    }

    use {
        'rafamadriz/friendly-snippets',
        commit = '009887b76f15d16f69ae1341f86a7862f61cf2a1',
    }

    -- Автодополнение
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {
                'L3MON4D3/LuaSnip',
                run = 'make install_jsregexp',
                commit = '58236e8b2f20de23ff35106dace9212b41d78860',
            },
            { 'saadparwaiz1/cmp_luasnip',            commit = '18095520391186d634a0045dacaa346291096566' },
            { 'hrsh7th/cmp-nvim-lsp',                commit = '0e6b2ed705ddcff9738ec4ea838141654f12eeef' },
            { 'hrsh7th/cmp-path',                    commit = '91ff86cd9c29299a64f968ebb45846c485725f23' },
            { 'hrsh7th/cmp-emoji',                   commit = '19075c36d5820253d32e2478b6aaf3734aeaafa0' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = '3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1' },
            { 'hrsh7th/cmp-nvim-lua',                commit = 'f3491638d123cfd2c8048aefaf66d246ff250ca6' },
            { 'hrsh7th/cmp-buffer',                  commit = '3022dbc9166796b644a841a02de8dd1cc1d311fa' },
            { 'hrsh7th/cmp-cmdline',                 commit = '8fcc934a52af96120fe26358985c10c035984b53' },
        },
        config = function()
            require('plugins.configs.cmp')
        end,
        commit = '01f697a68905f9dcae70960a9eb013695a17f9a2',
    }

    use {
        "Exafunction/codeium.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                enable_chat = true
            })
        end
    }

    -----------------------------------------------------------
    -- HTML и CSS
    -----------------------------------------------------------

    -- Подсвечивает закрывающий и откры. тэг. Если, где-то что-то не закрыто, то не подсвечивает
    use {
        'idanarye/breeze.vim',
        commit = '8bb6d287c085e9eeec5165301f317e2a24a2b257',
    }

    -- Закрывает автоматом html и xml тэги. Пишешь <h1> и он автоматом закроется </h1>
    use {
        'alvan/vim-closetag',
        commit = 'd0a562f8bdb107a50595aefe53b1a690460c3822',
    }

    -- Подсвечивает #ffffff
    use {
        'ap/vim-css-color',
        commit = '1c4b78f5512980227ca747e76f1f6c904f2eb3dc',
    }

    -----------------------------------------------------------
    -- РАЗНОЕ
    -----------------------------------------------------------

    -- Даже если включена русская раскладка vim команды будут работать
    use {
        'powerman/vim-plugin-ruscmd',
        commit = 'e952abbea092e420b128936a0c284fb522612c3a',
    }

    -- 'Автоформатирование' кода для всех языков
    use {
        'Chiel92/vim-autoformat',
        commit = 'd529e3e09a378695367969bf01735b9b997014ec',
    }

    -- ]p - вставить на строку выше, [p - ниже
    use {
        'tpope/vim-unimpaired',
        commit = '6d44a6dc2ec34607c41ec78acf81657248580bf1',
    }

    --- popup окошки
    use 'nvim-lua/popup.nvim'

    -- Обрамляет или снимает обрамление. Выдели слово, нажми S и набери <h1>
    use {
        'tpope/vim-surround',
        commit = '3d188ed2113431cf8dac77be61b842acb64433d9',
    }

    -- Считает кол-во совпадений при поиске
    use {
        'google/vim-searchindex',
        commit = 'b0788c8213210b3bd23b62847dd5a9ebbe4ad648',
    }

    -- Может повторять через . vimsurround
    use {
        'tpope/vim-repeat',
        commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a',
    }

    -- Стартовая страница, если просто набрать vim в консоле
    use {
        'glepnir/dashboard-nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        event = 'VimEnter',
        config = function()
            require('plugins.configs.dashboard')
        end,
        commit = '42213650c278d007dd198a1d115394e85b406188',
    }

    -- Комментирует по gc все, вне зависимости от языка программирования
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
        commit = '6821b3ae27a57f1f3cf8ed030e4a55d70d0c4e43',
    }

    -- Обрамляет строку в теги по ctrl- y + ,
    use {
        'mattn/emmet-vim',
        commit = 'def5d57a1ae5afb1b96ebe83c4652d1c03640f4d',
    }

    -- Плагин для автодополнения скобок и кавычек
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end,
        commit = 'ab49517cfd1765b3f3de52c1f0fda6190b44e27b',
    }

    use {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('which-key').setup {}
        end,
        commit = 'fb027738340502b556c3f43051f113bcaa7e8e63',
    }

    -- Speed up loading Lua modules in Neovim to improve startup time.
    use {
        'lewis6991/impatient.nvim',
        commit = 'c90e273f7b8c50a02f956c24ce4804a47f18162e',
    }

    -- Adds indentation guides to all lines (including empty lines)
    use {
        'lukas-reineke/indent-blankline.nvim',
        commit = '018bd04d80c9a73d399c1061fa0c3b14a7614399',
    }

    -- TODOs
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup {}
        end,
        commit = '74c7d28cb50b0713c881ef69bcb6cdd77d8907d1',
    }


    -- Markdown
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()

        -- install binaries from mason.nvim
        vim.api.nvim_create_autocmd('User', {
            pattern = 'PackerComplete',
            callback = function()
                vim.cmd 'bw | silent! MasonInstallAll' -- close packer window
            end,
        })
    end
end)
