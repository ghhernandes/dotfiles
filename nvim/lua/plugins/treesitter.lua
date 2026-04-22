-- Parsers are managed by Nix (nvim-treesitter.withAllGrammars)
-- Treesitter highlight/indent are enabled automatically by the plugin

-- Incremental selection
vim.keymap.set('n', '<C-space>', function()
    require('nvim-treesitter.incremental_selection').init_selection()
end)
vim.keymap.set('v', '<C-space>', function()
    require('nvim-treesitter.incremental_selection').node_incremental()
end)
vim.keymap.set('v', '<bs>', function()
    require('nvim-treesitter.incremental_selection').node_decremental()
end)
