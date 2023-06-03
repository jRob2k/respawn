" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
" Nord theme
Plug 'arcticicestudio/nord-vim'
" Nerd Tree for files and ish
Plug 'preservim/nerdtree'

" Vim git gutter for git hints and the like
Plug 'airblade/vim-gitgutter'

" Commentary to easily comment stuff in vim
Plug 'tpope/vim-commentary'

" Vim airline for a cool azz toolbar
Plug 'vim-airline/vim-airline'
call plug#end()

colorscheme nord
