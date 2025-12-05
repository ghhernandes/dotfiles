-- Plugins are now managed by Nix (see nix/home-manager/modules/neovim.nix)
-- require("plugins.packer")  -- Replaced by Nix

-- LSP and completion
require("plugins.lsp")
-- require("plugins.mason")  -- Replaced by Nix LSP management
require("plugins.cmp")

-- Navigation and editing
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.harpoon")

-- Plugins not currently installed (configs kept for reference)
-- To enable: add plugin to nix/home-manager/modules/neovim.nix
-- require("plugins.trouble")   -- trouble-nvim
-- require("plugins.flash")     -- flash-nvim
-- require("plugins.copilot")   -- copilot-lua

