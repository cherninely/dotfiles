return require('packer').startup(function()
    -- Packer сам себя
    use 'wbthomason/packer.nvim'

    -----------------------------------------------------------
    -- ПЛАГИНЫ ВНЕШНЕГО ВИДА
    -----------------------------------------------------------

     -- Цветовая схема
    use {
	    'tanvirtin/monokai.nvim',
    config = function()
        require('monokai').setup{}
    end, }

    --- Информационная строка внизу
    use { 'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
        require('lualine').setup{}
    end, }

    -- Табы вверху
    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons',
    config = function()
        require("bufferline").setup{}
    end, }

    -----------------------------------------------------------
    -- НАВИГАЦИЯ
    -----------------------------------------------------------

    -- Файловый менеджер
    use { 'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-tree'.setup {} end, }

    -- Замена fzf и ack
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function() 
            require'telescope'.setup {}
        end,
    }

    -----------------------------------------------------------
    -- LSP и автодополнялка
    -----------------------------------------------------------

    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter'

    -- Плагин для того чтобы в Neovim была поддержка LSP, он позволяет включать автодополнение, проверку синтаксиса и ещё много прочего
    use 'neovim/nvim-lspconfig'

    -- Добавляет иконки для пунктов автодополнения
	use {
		'onsails/lspkind-nvim',
		config = function()
            require('plugins.configs.lspkind')
		end
	}

    -- for formatters and linters
    use "jose-elias-alvarez/null-ls.nvim"

    -- Позволяет устанавливать LSP-сервера быстро и без боли
    use {
        'williamboman/mason.nvim',
        requires = {
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            require('plugins.configs.lsp')
        end,
    }

    -- Позволяет удобно показывать все ошибки и предупреждения, которые нашел LSP
	use {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup {}
		end,
	}

    -- Фutomatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
    use 'RRethy/vim-illuminate'

    -- Автодополнение
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-emoji',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-nvim-lua'
		},
		config = function()
            require('plugins.configs.cmp')
		end,
	}

    -----------------------------------------------------------
    -- HTML и CSS
    -----------------------------------------------------------

    -- Подсвечивает закрывающий и откры. тэг. Если, где-то что-то не закрыто, то не подсвечивает.
    use 'idanarye/breeze.vim'

    -- Закрывает автоматом html и xml тэги. Пишешь <h1> и он автоматом закроется </h1>
    use 'alvan/vim-closetag'

    -- Подсвечивает #ffffff
    use 'ap/vim-css-color'

    -----------------------------------------------------------
    -- РАЗНОЕ
    -----------------------------------------------------------

    -- Даже если включена русская раскладка vim команды будут работать
    use 'powerman/vim-plugin-ruscmd'

    -- 'Автоформатирование' кода для всех языков
    use 'Chiel92/vim-autoformat'

    -- ]p - вставить на строку выше, [p - ниже
    use 'tpope/vim-unimpaired'

    -- Переводчик рус - англ
    use 'skanehira/translate.vim'

    --- popup окошки
    use 'nvim-lua/popup.nvim'

    -- Обрамляет или снимает обрамление. Выдели слово, нажми S и набери <h1>
    use 'tpope/vim-surround'

    -- Считает кол-во совпадений при поиске
    use 'google/vim-searchindex'

    -- Может повторять через . vimsurround
    use 'tpope/vim-repeat'

    -- Стартовая страница, если просто набрать vim в консоле
    use 'mhinz/vim-startify'

    -- Комментирует по gc все, вне зависимости от языка программирования
    use { 'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end }

    -- Обрамляет строку в теги по ctrl- y + ,
    use 'mattn/emmet-vim'

    -- Закрывает автоматом скобки
    use 'cohama/lexima.vim'

    -- Линтер, работает для всех языков
    use 'dense-analysis/ale'

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end
    }

    -- Speed up loading Lua modules in Neovim to improve startup time.
    use 'lewis6991/impatient.nvim'

end)
