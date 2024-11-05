require("mason").setup()

require("mason-lspconfig").setup {
    ensure_installed = {
        "rust_analyzer",
        "gopls",
        "pyright",
        "terraformls",
        "bashls",
        "dockerls",
    },
}

--require("mason-lspconfig").setup_handlers {
--    function(server_name) -- default handler (optional)
--        require("lspconfig")[server_name].setup {
--            --capabilities = require("cmp_nvim_lsp").default_capabilities(),
--            on_attach = function(client, bufnr)
--                -- Mappings.
--                -- See `:help vim.lsp.*` for documentation on any of the below functions
--                local bufopts = { noremap = true, silent = true, buffer = bufnr }
--                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
--                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--                vim.keymap.set('n', '<space>wl', function()
--                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--                end, bufopts)
--                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
--                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
--                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
--                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--                vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
--            end
--        }
--    end,
--}
