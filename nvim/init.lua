vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

-- setup packer + plugins
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    print "Cloning packer .."
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }

    vim.cmd [[packadd packer.nvim]]
    require 'plugins'
    vim.cmd "PackerSync"

    -- install binaries from mason.nvim
    vim.api.nvim_create_autocmd("User", {
        pattern = "PackerComplete",
        callback = function()
            vim.cmd "bw | silent! MasonInstallAll" -- close packer window
        end,
    })
end

-----------------------------------------------------------
-- Импорт модулей lua
-----------------------------------------------------------

-- Надо запускать после установки treesitter
require 'plugins.configs.treesitter'

require 'settings'
require 'keymaps'

