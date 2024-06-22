" Packer插件管理
lua require('init')
lua require('plugins')
"lua require('lsp/setup')

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

"Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.config/nvim/init.vim<cr>
"Fast editing of .vimrc
map <silent> <leader>ee :e ~/.config/nvim/init.vim<cr>
" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>
nmap <leader>wq :wq!<cr>
"
nmap <leader>nh :noh<cr>
" no motion scroll
let g:loaded_comfortable_motion = 0

" Editor theme
" colorscheme nord
"set background=dark

" Don't show last command
set noshowcmd
" Yank and paste with the system clipboard
"set clipboard=unnamed
" Hides buffers instead of closing them
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" === TAB/Space settings === "
" Insert spaces when TAB is pressed.
set expandtab
" Change number of spaces that a <Tab> counts for during editing ops
set softtabstop=2
" Indentation amount for < and > commands.
set shiftwidth=2
" 继承前一行的缩进方式，适用于多行注释
set autoindent
" do not wrap long lines by default
set nowrap
" Don't highlight current cursor line
"set nocursorline

set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
set backup
set noswapfile

vmap <Leader>y "+y
vmap <Leader>p "+p
