" Numbers
set relativenumber
set number
set numberwidth=5

" Go file config
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

call plug#begin("~/.vim/plugged")
  " Plugin Section
  Plug 'dracula/vim'
  Plug 'morhetz/gruvbox'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'airblade/vim-gitgutter'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Config Section
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


syntax enable
colorscheme gruvbox
set background=dark

" NERD tree configuration
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
noremap <C-d> :NERDTreeToggle<CR>
nnoremap F :NERDTreeFind<CR>
