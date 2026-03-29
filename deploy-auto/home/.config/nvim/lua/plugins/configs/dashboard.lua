local present, dashboard = pcall(require, 'dashboard')

if not present then
    return
end

dashboard.setup{
    theme = 'hyper',
    shortcut_type = 'number',
    config = {
        week_header = {
            enable = true,
        },
        packages = { enable = false }, -- show how many plugins neovim loaded
        shortcut = {
            { desc = ' Update', group = '@property', action = 'PackerUpdate', key = 'u' }
        },
    }
}
