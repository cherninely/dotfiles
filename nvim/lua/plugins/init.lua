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
        end
    }

    use { 'nvim-tree/nvim-web-devicons' }

    --- Информационная строка внизу
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('plugins.configs.lualine')
        end
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
        end
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
        end
    }

    -- Замена fzf и ack
    use {
        'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require 'plugins.configs.telescope'
        end
    }

    -----------------------------------------------------------
    -- LSP и автодополнялка
    -----------------------------------------------------------

    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require 'plugins.configs.treesitter'
        end
    }

    -- Плагин для того чтобы в Neovim была поддержка LSP, он позволяет включать автодополнение, проверку синтаксиса и ещё много прочего
    use { 'neovim/nvim-lspconfig' }

    -- Standalone UI for nvim-lsp progress. Eye candy for the impatient
    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup {}
        end
    }

    -- Добавляет иконки для пунктов автодополнения
    use {
        'onsails/lspkind-nvim',
        config = function()
            require('plugins.configs.lspkind')
        end
    }

    use {
        'ThePrimeagen/refactoring.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        },
        config = function()
            require('refactoring').setup {}
        end
    }

    -- for formatters and linters
    use {
        'nvimtools/none-ls.nvim',
        requires = 'ThePrimeagen/refactoring.nvim',
        config = function()
            require('plugins.configs.lsp.null-ls')
        end
    }

    -- Позволяет устанавливать LSP-сервера быстро и без боли
    use {
        'mason-org/mason.nvim',
        requires = 'mason-org/mason-lspconfig.nvim',
        config = function()
            require('plugins.configs.lsp')
        end
    }

    -- Позволяет удобно показывать все ошибки и предупреждения, которые нашел LSP
    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('plugins.configs.trouble')
        end
    }

    -- Automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
    use {
        'RRethy/vim-illuminate',
        disable = true
    }

    use { 'rafamadriz/friendly-snippets' }

    -- Автодополнение
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {
                'L3MON4D3/LuaSnip',
                run = 'make install_jsregexp'
            },
            { 'saadparwaiz1/cmp_luasnip'             },
            { 'hrsh7th/cmp-nvim-lsp'                 },
            { 'hrsh7th/cmp-path'                     },
            { 'hrsh7th/cmp-emoji'                    },
            { 'hrsh7th/cmp-nvim-lsp-signature-help'  },
            { 'hrsh7th/cmp-nvim-lua'                 },
            { 'hrsh7th/cmp-buffer'                   },
            { 'hrsh7th/cmp-cmdline'                  }
        },
        config = function()
            require('plugins.configs.cmp')
        end
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
    use { 'idanarye/breeze.vim' }

    -- Закрывает автоматом html и xml тэги. Пишешь <h1> и он автоматом закроется </h1>
    use { 'alvan/vim-closetag' }

    -- Подсвечивает #ffffff
    use { 'ap/vim-css-color' }

    -----------------------------------------------------------
    -- РАЗНОЕ
    -----------------------------------------------------------

    -- Даже если включена русская раскладка vim команды будут работать
    use { 'powerman/vim-plugin-ruscmd' }

    -- 'Автоформатирование' кода для всех языков
    use { 'Chiel92/vim-autoformat' }

    -- ]p - вставить на строку выше, [p - ниже
    use { 'tpope/vim-unimpaired' }

    --- popup окошки
    use 'nvim-lua/popup.nvim'

    -- Обрамляет или снимает обрамление. Выдели слово, нажми S и набери <h1>
    use { 'tpope/vim-surround' }

    -- Считает кол-во совпадений при поиске
    use { 'google/vim-searchindex' }

    -- Может повторять через . vimsurround
    use { 'tpope/vim-repeat' }

    -- Стартовая страница, если просто набрать vim в консоле
    use {
        'glepnir/dashboard-nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        event = 'VimEnter',
        config = function()
            require('plugins.configs.dashboard')
        end
    }

    -- Комментирует по gc все, вне зависимости от языка программирования
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- Обрамляет строку в теги по ctrl- y + ,
    use { 'mattn/emmet-vim' }

    -- Плагин для автодополнения скобок и кавычек
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }

    use {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('which-key').setup {}
        end
    }

    -- Speed up loading Lua modules in Neovim to improve startup time.
    use { 'lewis6991/impatient.nvim' }

    -- Adds indentation guides to all lines (including empty lines)
    use { 'lukas-reineke/indent-blankline.nvim' }

    -- TODOs
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup {}
        end
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
