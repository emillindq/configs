" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
Plugin 'bling/vim-airline'
" Plugin 'majutsushi/tagbar'
"Plugin 'tranvansang/octave.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
"Plugin 'preservim/tagbar'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
map <leader>w1 :set textwidth=80<CR>
map <leader>w0 :set textwidth=0<CR>
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noshiftround
set colorcolumn=80
set expandtab

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim
nnoremap go <C-O>
nmap W 3w
nmap B 3b
map J 4j
map K 4k


" clipboard
autocmd VimLeave * call system("xsel -ib", getreg('+'))
autocmd VimEnter * if @% == "" | execute "AnsiEsc" | set bt=nofile | endif

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
vnoremap / <Esc>/\%V
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

map <leader>b <C-t>
map <leader>g g<C-]>
set tags=tags;

" Visualize tabs and newlines
set listchars=tab:▸-,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

:command! -nargs=1 Sil execute ':silent !'.<q-args> | execute ':redraw!'

noremap * *N
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>

map <leader>fo <c-w>gf
map <leader>fc :tabclose<CR>

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

function! AirlineInit()
    let g:airline_section_b = airline#section#create([''])
    let g:airline_section_gutter = airline#section#create([''])
    let g:airline_section_error = airline#section#create([''])
    let g:airline_section_warning = airline#section#create([''])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" Color scheme (terminal)
set background=dark

" Debugging
let g:termdebugger = '/home/emil/zephyr-sdk/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb'
let g:termdebug_wide=1

"nnoremap <leader>ds :Step<CR>
"nnoremap <leader>dn :Next<CR>
"nnoremap <leader>dc :Continue<CR>
"nnoremap <leader>dd :Clear<CR>
"nnoremap <leader>db :Break<CR>
"nnoremap <leader>dp :Stop<CR>
"nnoremap <leader>de :Eval 
"nnoremap <leader>t <C-w>t
"nnoremap <leader>e :Source<CR>
"nnoremap <leader>g :Gdb<CR>

"nnoremap <C-l> <C-w>l
"nnoremap <C-k> <C-w>k
"nnoremap <C-j> <C-w>j
"nnoremap <C-h> <C-w>h

nnoremap + $

function! Debug()
    :packadd termdebug
    let g:termdebugger = $ZEPHYR_SDK_INSTALL_DIR . '/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb'
    call term_start("west debugserver", {"term_name" : "west_session", "hidden": "1"})
    execute "Termdebug" . "./build/zephyr/zephyr.elf"
    call TermDebugSendCommand('target remote :3333')
    call TermDebugSendCommand('load')
    call TermDebugSendCommand("python import yaml; f = open(\"./build/zephyr/runners.yaml\", \"r\"); l = yaml.safe_load(f); f = [i for i in l[\"args\"][\"stlink\"] if \"gdbinit\" in i][0].split(\"=\")[1]; gdb.execute(\"source \" + f)")
    map K 4k
    while len(system("pgrep ST-LINK")) < 3 && len(system("pgrep openocd")) < 3
        echom "wait!"
        execute "sleep 100m"
    endwhile
    execute "sleep 1000m"
    call feedkeys("\<C-w>\<C-w>:q\<CR>")
    let tty=system("find_st_tty.tcl")
    "call feedkeys(":Sil conf_st_tty.sh ".tty."\<CR>")
    "call feedkeys(":terminal cat ".tty."\<CR>")
    call feedkeys(":Source\<CR>")
        
endfunction
command! Debug call Debug()
