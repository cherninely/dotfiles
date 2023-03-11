local present, telescope = pcall(require, 'telescope')

if not present then
    return
end

telescope.setup {
    defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                preview_width = 0.5,
                results_width = 0.5,
            },
            width = 0.99,
            height = 0.99,
            preview_cutoff = 1, -- always show preview
        },
    },
    builtin = {
        treesitter = true,
    },
}
