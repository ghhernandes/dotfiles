return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use "nvim-lua/plenary.nvim"

    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    use 'hrsh7th/nvim-cmp'         -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip'         -- Snippets plugin

    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        'nvim-pack/nvim-spectre',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use {
        'nvim-treesitter/nvim-treesitter-refactor',
        requires = { { 'nvim-treesitter/nvim-treesitter' } }
    }

    use 'tpope/vim-fugitive'
    use 'mbbill/undotree'

    use 'zbirenbaum/copilot.lua'

    use 'folke/trouble.nvim'
    use 'folke/flash.nvim'

    use 'ellisonleao/gruvbox.nvim'
end)
