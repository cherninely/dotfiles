local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

vim.g.mapleader = ','

-- Стрелочки откл. Использовать hjkl
map('', '<up>', ':echoe "Use k"<CR>', {noremap = true, silent = false})
map('', '<down>', ':echoe "Use j"<CR>', {noremap = true, silent = false})
map('', '<left>', ':echoe "Use h"<CR>', {noremap = true, silent = false})
map('', '<right>', ':echoe "Use l"<CR>', {noremap = true, silent = false})

-- Save
map('n', '<leader>s', '<cmd>w<CR>', default_opts)
map('i', '<leader>s', '<esc><cmd>w<CR>', default_opts)

-- Don't copy the contents of an overwritten selection
map('v', 'p', '\"_dP\"', default_opts)

-- Tabs
map('n', 'gb', '<CMD>BufferLinePick<CR>', default_opts)
map('n', '<leader>x', ':Bdelete<CR>', default_opts)
map('n', '<S-l>', '<CMD>BufferLineCycleNext<CR>', default_opts)
map('n', '<S-h>', '<CMD>BufferLineCyclePrev<CR>', default_opts)
map('n', ']b', '<CMD>BufferLineMoveNext<CR>', default_opts)
map('n', '[b', '<CMD>BufferLineMovePrev<CR>', default_opts)
map('n', 'gs', '<CMD>BufferLineSortByDirectory<CR>', default_opts)

-- Tree
map('n', '<leader>d', ':NvimTreeToggle<CR>', default_opts)

-- Telscope
map('n', '<leader>p', '<cmd> Telescope find_files<CR>', default_opts)
map('n', '<leader>f', '<cmd> Telescope live_grep<CR>', default_opts)
map('n', '<leader>gs', '<cmd> Telescope get_status<CR>', default_opts)

-- TODOs
map('n', '<leader>t', '<cmd> TodoTelescope<CR>', default_opts)
