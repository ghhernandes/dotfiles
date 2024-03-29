vim.opt.guicursor = ""

--vim.opt.nu = true
--vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

--vim.opt.colorcolumn = "80"

-- Sync clipboard between OS and Neovim.
-- See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.cmd('language en_US.UTF-8')

vim.cmd('let g:loaded_python3_provider = 0')
vim.cmd('let g:loaded_ruby_provider = 0')
vim.cmd('let g:loaded_node_provider = 0')
vim.cmd('let g:loaded_perl_provider = 0')
