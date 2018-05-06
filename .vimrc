" Vundle set-up
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Installed plugins
Plugin 'vim-latex/vim-latex'

" Vundle set-up
call vundle#end()            " required

"	 Non Vundle

filetype plugin indent on    " required
" how existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" " On pressing tab, insert 4 spaces
set expandtab

" line numberss
set number

" highlight search
set hlsearch

" Setting Syntax on
syntax on

" Latex stuff
filetype plugin on
set grepprg=grep\ -nH\ $*
filetype indent on
let g:tex_flavor='latex'
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode $*'
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -src-specials -interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'okular --unique'
function! SyncTexForward()
let execstr = "silent !okular --unique %:p:r.pdf\#src:".line(".")."%:p &"
exec execstr
endfunction
nmap f :call SyncTexForward()
map <Leader>t :w<CR><bar><Leader>ll<CR><bar>
