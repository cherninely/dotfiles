local map = vim.api.nvim_set_keymap

local silent_opts = { noremap = true, silent = true }
local notsilent_opts = { noremap = true, silent = false }

vim.g.mapleader = ','

-- Стрелочки откл. Использовать hjkl
map('', '<up>', ':echoe "Use k"<CR>', notsilent_opts)
map('', '<down>', ':echoe "Use j"<CR>', notsilent_opts)
map('', '<left>', ':echoe "Use h"<CR>', notsilent_opts)
map('', '<right>', ':echoe "Use l"<CR>', notsilent_opts)

-- Scrolling with window center
map('n', '<C-D>', '<C-D>zz', silent_opts)
map('n', '<C-U>', '<C-U>zz', silent_opts)
map('n', 'n', 'nzzzv', silent_opts)
map('n', 'N', 'Nzzzv', silent_opts)

-- Better window movement
map("n", "<C-h>", "<C-w>h", silent_opts)
map("n", "<C-j>", "<C-w>j", silent_opts)
map("n", "<C-k>", "<C-w>k", silent_opts)
map("n", "<C-l>", "<C-w>l", silent_opts)

-- Save
map('n', '<leader>s', '<cmd>w<CR>', silent_opts)
map('i', '<leader>s', '<esc><cmd>w<CR>', silent_opts)

-- Remove highlights
map("n", "<CR>", ":noh<CR><CR>", silent_opts)

-- Replace current
map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], notsilent_opts)

-- Don't yank on delete char
map("n", "x", '"_x', silent_opts)
map("n", "X", '"_X', silent_opts)
map("v", "x", '"_x', silent_opts)
map("v", "X", '"_X', silent_opts)

-- Don't copy the contents of an overwritten selection
map('v', 'p', '\"_dP\"', silent_opts)

-- Yank to system buffer
map('n', '<leader>y', '\"+y', silent_opts)
map('v', '<leader>y', '\"+y', silent_opts)
map('n', '<leader>Y', '\"+Y', silent_opts)

-- Disable Q
map('n', 'Q', '<nop>', silent_opts)

-- Tabs
map('n', 'gb', '<CMD>BufferLinePick<CR>', silent_opts)
map('n', '<leader>x', ':Bdelete<CR>', silent_opts)
map('n', '<S-l>', '<CMD>BufferLineCycleNext<CR>', silent_opts)
map('n', '<S-h>', '<CMD>BufferLineCyclePrev<CR>', silent_opts)
map('n', ']b', '<CMD>BufferLineMoveNext<CR>', silent_opts)
map('n', '[b', '<CMD>BufferLineMovePrev<CR>', silent_opts)
map('n', 'gs', '<CMD>BufferLineSortByDirectory<CR>', silent_opts)

-- Tree
map('n', '<leader>d', ':NvimTreeToggle<CR>', silent_opts)

-- Telscope
map('n', '<leader>p', '<cmd>Telescope find_files hidden=true<CR>', silent_opts)
map('n', '<leader>f', '<cmd>Telescope live_grep hidden=true<CR>', silent_opts)
map('n', '<leader>F', '<cmd>Telescope grep_string hidden=true<CR>', silent_opts)
map('n', '<leader>gs', '<cmd>Telescope get_status hidden=true<CR>', silent_opts)

-- TODOs
map('n', '<leader>t', '<cmd>TodoTelescope<CR>', silent_opts)

-- Trouble
map('n', '<leader>lt', '<cmd>TroubleToggle<CR>', silent_opts)
