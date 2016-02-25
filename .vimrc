" Use the Solarized Dark theme set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,nbsp:_
"set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
  set relativenumber
  au BufReadPost * set relativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
  " Enable file type detection
  filetype plugin indent on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  autocmd FileType text setlocal linebreak

  " When editing a file, always jump to the last known cursor position.  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif

set history=50		" keep 50 lines of command line history

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


" ################# Pathogen
execute pathogen#infect()

if has("autocmd")
  " ####### Fugitive
  autocmd BufReadPost fugitive://* set bufhidden=delete

  " ####### SAM
  autocmd BufNewFile,BufRead *.kjs,*._js setf javascript
endif

" ##### FUNCTIONS #####
function! OpenBash()
  execute ':!(cd ' . expand('%:h') . ';bash -l)'
endfunction

function! KeliUIBuild()
  execute ':!(cd ~/dev/keli_interface/; gulp dist; )'
  call KeliBuild('~/dev/keli_core/', '_core_ui_components.kjs')
endfunction

function! FindKeliFunction()
  execute ':vimgrep ' . @/
endfunction

function! KeliBuild(...)
  if a:0 == 0
    let directory = expand('%:p:h')
    let filename = expand('%:t')
  elseif a:0 == 1
    let directory = expand('%:p:h')
    let filename = a:1
  elseif a:0 == 2
    let directory = a:1
    let filename = a:2
  endif

  execute ':!(cd ' . directory . '; ~/dev/keli/writetemplate.sh "' . filename .'$")'
endfunction

function! BigWindows()
  set winwidth=150
  set winheight=75
endfunction

function! SmallWindows()
  set winwidth=20
  set winheight=20
endfunction

" ##### CUSTOM MAPPING #######

" Edit .vimrc in new tab
map <leader>v :tabe $MYVIMRC<cr>
" Fix spelling
map <leader>sf 1z=<CR>
" Toggle Spelling
map <leader>s :set spell!<cr>
" New Tab
map <leader>t :tabnew<cr>
" Save/Write/Update
imap <leader>w <esc>:update<cr>a
map <leader>w :update<cr>
" Clear highlight search
map <leader>h :nohlsearch<cr>
map <leader>c :nohlsearch <cr>
" Open a bash prompt in the current directory of the file
map <leader>b :call OpenBash()<cr>
" Run the current file in bash
map <leader>r :!./%<cr>
" Function lookup using grep
map <leader>j :grep -id recurse $f %g
" Word Lookup using group
map <leader>f :grep -id recurse $w %g

"cnoremap $v <C-R>='/n '.substitute(@/,'\\[<>]\{1}','','g').'/'<cr>
cnoremap $v <C-R>='/n '.expand('<cword>').'/'<cr>
cnoremap $f <C-R>='"n '.expand('<cword>').'"'<cr>
cnoremap $w <C-R>='"'.expand('<cword>').'"'<cr>
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
cnoremap %k <C-R>=fnameescape(expand('%:h')).'/*.kjs'<cr>
cnoremap %s <C-R>=fnameescape(expand('%:p:h')).'/**/*'<cr>
cnoremap %g <C-R>=fnameescape(expand('%:p:h')).'/*'<cr>
cnoremap %r s/<c-r>=expand('<cword>')<cr>/

" Edit in current directory
map <leader>ew :e %%
" Edit Split in current directory
map <leader>es :sp %%
" Edit Split Vertical in current directory
map <leader>ev :vsp %%
" Edit New Tab in current directory
map <leader>et :tabe %%

" Alternate to ESC
inoremap kj <esc>
" Scroll Right
map <C-l> 3zl
" Scroll Left
map <C-h> 3zh

" ## APP SPECIFIC ##
" Build templates
map <leader>kb :call KeliBuild()<cr>
" Build UI and ui templates only
map <leader>kg :call KeliUIBuild()<cr><cr>

" ##### PLUGINS #####

" STATUS LINE
" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

let jsdoc_default_mapping = 0
let g:UltiSnipsEditSplit = "vertical"

