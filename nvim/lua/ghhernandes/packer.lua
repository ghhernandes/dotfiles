
return require('packer').startup(function(use)
	use('wbthomason/packer.nvim')

	use('neovim/nvim-lspconfig') -- Configurations for Nvim LSP
	use('sbdchd/neoformat') -- Plugin for formatting code

	use('nvim-treesitter/nvim-treesitter', {
		run = ':TSUpdate'
	})

    use("nvim-lua/plenary.nvim")
    use('nvim-telescope/telescope.nvim')

	-- Colorscheme section
	use("gruvbox-community/gruvbox")
	use("folke/tokyonight.nvim")
end)
