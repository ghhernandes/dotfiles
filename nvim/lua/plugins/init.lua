-- Plugins are now managed by Nix (see nix/home-manager/modules/neovim.nix)
-- require("plugins.packer")  -- Replaced by Nix

-- LSP and completion
require("plugins.cmp")
require("plugins.lsp")
-- require("plugins.mason")  -- Replaced by Nix LSP management

-- Navigation and editing
require("plugins.telescope")
require("plugins.flash")
require("plugins.treesitter")
require("plugins.harpoon")
require("plugins.vim-sexp")
require("plugins.trouble")

