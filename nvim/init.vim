" Packer插件管理
lua require('init')

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
