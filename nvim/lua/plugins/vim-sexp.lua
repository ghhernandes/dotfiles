-- Lazy-load vim-sexp only for Clojure/Lisp files
-- This prevents the slow 7+ second startup cost when not editing these filetypes

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "clojure", "fennel", "scheme", "lisp" },
  callback = function()
    vim.cmd("packadd vim-sexp")
    vim.cmd("packadd vim-sexp-mappings-for-regular-people")
  end,
  once = false,
})
