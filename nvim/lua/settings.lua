local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- Общие настройки
-----------------------------------------------------------

cmd([[
filetype indent plugin on
syntax enable
]])

g.python3_host_prog = '/usr/bin/python3'

-- Buffer options
opt.hidden = true                     -- hide buffers when they are abandoned
opt.autoread = true                -- auto reload changed files

opt.title = true                   -- show file name in window title
opt.visualbell = false            -- mute error bell
opt.list = true
opt.linebreak = true               -- break lines by words
opt.scrolljump = 5
opt.sidescroll = 4
opt.sidescrolloff = 10
opt.showcmd = true
opt.completeopt = 'menu,preview'
opt.infercase = true
opt.ruler = true
opt.ttyfast = true                 -- Optimize for fast terminal connections
opt.shortmess = 'atI'           -- Don’t show the intro message when starting Vim
opt.startofline = false
opt.number = true
opt.relativenumber = true
opt.laststatus = 2            -- always show statusline
opt.wrap = true                    -- when on, lines longer than the width of the window will wrap and displaying continues on the next line
opt.scrolloff = 3             -- show context above/below cursorline
opt.termguicolors = true
opt.background = 'dark'

-- Tab options
opt.autoindent = true              -- copy indent from previous line
opt.smartindent = true             -- enable nice indent
opt.expandtab = true               -- tab with spaces
opt.smarttab = true                -- indent using shiftwidth"
opt.shiftwidth = 4            -- number of spaces to use for each step of indent
opt.tabstop = 4
opt.softtabstop = 4           -- tab like 4 spaces
opt.shiftround = true              -- drop unused spaces

-- Search options
opt.gdefault = true                -- Add the g flag to search/replace by default
opt.hlsearch = true                -- Highlight search results
opt.ignorecase = true              -- Ignore case in search patterns
opt.smartcase = true               -- Override the 'ignorecase' option if the search pattern contains upper case characters
opt.incsearch = true               -- While typing a search command, show where the pattern

-- Matching characters
opt.showmatch = true               -- Show matching brackets
opt.matchpairs = '(:),{:},[:],<:>'         -- Make < and > match as well

-- Localization
opt.keymap = 'russian-jcukenwin' -- Alternative keymap highlight lCursor guifg=NONE guibg=Cyan
opt.iminsert = 0               -- English by default
opt.imsearch = -1              -- Search keymap from insert mode
opt.spelllang = 'en,ru'          -- Languages

-- opt.spell
opt.encoding = 'utf-8'           -- Default encoding
opt.fileencodings = 'utf-8,cp1251,koi8-r,cp866'
opt.termencoding = 'utf-8'
opt.fileformat = 'unix'

-- Enhance command-line completion
opt.wildmenu = true                 -- use wildmenu ...
opt.wildcharm = vim.api.nvim_replace_termcodes('<Tab>', true, true, true):byte()

-- Edit
opt.backspace='indent,eol,start' -- Allow backspace to remove indents, newlines and old tex"

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.eol = false

opt.diffopt = filler
opt.diffopt = opt.diffopt + 'vertical'
opt.diffopt = opt.diffopt + 'iwhite'

-- don't auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- remove line lenght marker for selected filetypes
cmd [[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]]

-- Запоминает где nvim последний раз редактировал файл
cmd [[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]

-- Подсвечивает на доли секунды скопированную часть текста
exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup end
]], false)
