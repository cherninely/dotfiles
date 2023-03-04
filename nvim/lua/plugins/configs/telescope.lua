local present, telescope = pcall(require, 'telescope')

if not present then
    return
end

telescope.setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "build",
        }
    }
}
