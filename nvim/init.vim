lua require('plugins')
lua require("ghhernandes")

let g:gruvbox_underline=1
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_transparent_bg=1

set termguicolors
set mouse=a

highlight Normal ctermbg=NONE guibg=NONE

set encoding=utf-8

set showmatch
set ignorecase
set hlsearch
set incsearch

set tabstop=4
set shiftwidth=4
set softtabstop=4
set cc=80

set smarttab
"set smartindent
set autoindent " copy indent from current line when starting a new line

set showcmd

set expandtab " enter spaces when tab is pressed
set splitbelow
set splitright

set clipboard=unnamedplus

set cursorline
set number
set relativenumber
set ttyfast

set noswapfile

set wildignore+=*.pyc
set wildignore+=**/.git/*

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu

" move line or visually selected block - alt+j/k
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

"nnoremap <silent> <C-f> :silent !tmux neww tmux-sessionizer<CR>
