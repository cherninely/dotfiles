local present, trouble = pcall(require, 'trouble')

if not present then
    return
end

trouble.setup {
    auto_open = true,
    auto_close = true,
    use_diagnostic_signs = true
}
