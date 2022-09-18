local Remap = require("ghhernandes.keymap")
local nnoremap = Remap.nnoremap

-- Mappings 
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
nnoremap('<space>e', function() vim.diagnostic.open_float() end)
nnoremap('[d', function() vim.diagnostic.goto_prev() end)
nnoremap(']d', function() vim.diagnostic.goto_next() end)
nnoremap('<space>q', function() vim.diagnostic.setloclist() end)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  nnoremap('gD', function() vim.lsp.buf.declaration() end)
  nnoremap('gd', function() vim.lsp.buf.definition() end)
  nnoremap('K', function() vim.lsp.buf.hover() end)
  nnoremap('gi', function() vim.lsp.buf.implementation() end)
  nnoremap('<C-k>', function() vim.lsp.buf.signature_help() end)
  nnoremap('<space>wa', function() vim.lsp.buf.add_workspace_folder() end)
  nnoremap('<space>wr', function() vim.lsp.buf.remove_workspace_folder() end)
  nnoremap('<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  nnoremap('<space>D', function() vim.lsp.buf.type_definition() end)
  nnoremap('<space>rn', function() vim.lsp.buf.rename() end)
  nnoremap('<space>ca', function() vim.lsp.buf.code_action() end)
  nnoremap('gr', function() vim.lsp.buf.references() end)
  nnoremap('<space>f', function() vim.lsp.buf.formatting() end)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

lspconfig = require("lspconfig")

lspconfig['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

lspconfig['gopls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
