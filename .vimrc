auto BufEnter * let &titlestring = "vim"

if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_install
    au!
    au! VimEnter * PlugInstall
  augroup END
endif


" PLUGINS {{{
call plug#begin('~/.vim/plugged')
Plug 'skywind3000/asyncrun.vim'
Plug 'scrooloose/nerdtree'  " file list
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'  "to highlight files in nerdtree
Plug 'majutsushi/tagbar'  " show tags in a bar (functions etc) for easy browsing
Plug 'mbbill/undotree'
Plug 'Konfekt/FastFold'  " fast folding
Plug 'godlygeek/tabular'
Plug 'kana/vim-surround'
Plug 'jiangmiao/auto-pairs', {'on': 'PAIRSToggle'}
Plug 'w0rp/ale', { 'on':  'ALEToggle'  }
Plug 'rhysd/vim-grammarous'
Plug 'junegunn/goyo.vim'
Plug 'gabrielelana/vim-markdown'
" Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
" COMPLETION {{{
Plug 'ervandew/supertab'  " for autocompletion using <TAB>
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
Plug 'prabirshrestha/asyncomplete-tags.vim'
Plug 'prabirshrestha/asyncomplete-necovim.vim'
" }}}
" PYTHON {{{
Plug 'davidhalter/jedi-vim', {'for': 'python'}   " jedi for python
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}  "better indenting for python
Plug 'tmhedberg/SimpylFold', {'for': 'python'}  " for nice python folding
Plug 'tweekmonster/impsort.vim', {'for': 'python'}  " color and sort imports
"Plug 'plytophogy/vim-virtualenv', {'for': 'python'} " virtualenv support
"Plug 'PieterjanMontens/vim-pipenv', {'for': 'python'}
" }}}
" GIT {{{
Plug 'airblade/vim-gitgutter'  " show git changes to files in gutter
Plug 'tpope/vim-fugitive'
" }}}
" NOT NOW{{{
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'
"Plug 'tpope/vim-commentary'  "comment-out by gc
"Plug 'wsdjeg/FlyGrep.vim'  " awesome grep on the fly
"Plug 'easymotion/vim-easymotion'
" }}}
call plug#end()
" }}}

let g:is_bash=1
set shell=$SHELL
if &compatible
  set nocompatible
endif
syntax on
filetype plugin indent on
scriptencoding utf-8

set nowrap textwidth=79 colorcolumn=80
set autochdir
set autoindent smartindent
set autoread
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,gb2312,default,latin1
set fileformats=unix,dos,mac
set fillchars=diff:⣿,vert:│
set gcr=a:blinkon0
set hidden
set history=700
set hlsearch incsearch ignorecase smartcase
set laststatus=2
set lazyredraw
set list lcs=tab:\ \ ,extends:›,precedes:‹,nbsp:·,trail:·
set listchars=eol:$,tab:>-,trail:·,extends:❯,precedes:❮
set magic
set matchpairs+=<:>            " Highlight <>.
set matchtime=2
set mouse=a
set nobackup nowritebackup noswapfile
set noeb vb
set nojoinspaces
set number relativenumber ruler
set pastetoggle=<F2>
set path+=**
set shortmess=atI
set showcmd showmode
set showmatch
set spelllang=en,ru,pl,ua
set synmaxcol=800
set tags=tags;/,codex.tags;/ " look for tags in current dir and up and
set ts=4 sts=4 sw=4 noexpandtab smarttab
set ttimeoutlen=0
set undolevels=1000
set updatetime=500

if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
set clipboard+=unnamedplus


" highlight line and column
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline nocursorcolumn
set cursorline nocursorcolumn


set sessionoptions=blank,buffers,curdir,folds,help,localoptions,tabpages,winsize
set switchbuf=useopen,usetab


" STATUSLINE {{{
function! LinterStatus() abort
	let l:counts = ale#statusline#Count(bufnr(''))
	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors

	return l:counts.total == 0 ? 'OK' : printf(
	\   '%dW %dE',
	\   all_non_errors,
	\   all_errors
	\)
endfunction

if has('statusline')
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=\ [%{&ff}/%Y]            " filetype
    set statusline+=\ [%{getcwd()}]          " current dir
    set statusline+=\ %{fugitive#statusline()} "  Git Hotnes
    set statusline+=\ %{LinterStatus()}
    set statusline+=%*
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif
"}}}
" WILDIGNORE {{{
set wildignorecase
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~
set wildignore+=*.so,*.swp
set wildignore+=*.gem,*.rbc,*.class
set wildignore+=.hg,.git,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=__pycache__,*.pyc,*.luac
set wildignore+=.hg,.git,.svn
set wildignore+=*.o,*.obj,*.dll,*.manifest
set wildignore+=*.spl,*.sw?
set wildignore+=migrations,*.orig,*.class
set wildignore+=*vim/backups*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=log/**
set wildignore+=tmp/**,*/tmp/*
"}}}
" AUTOCMD {{{
"function! DelWhitespace()
    "execute \":retab\"
    ":%s/\s\+$//g
"endfunction
"command! Unfuck execute DelWhitespace()
"
"autocmd BufWrite *.py :call DelWhitespace()
"autocmd BufWrite *.coffee :call DelWhitespace()


autocmd FileType python,javascript setlocal ts=4 sw=4 sts=4 expandtab autoindent
autocmd FileType php,snippets setlocal ts=4 sw=4 sts=4 noexpandtab
autocmd FileType html,xhtml setlocal ts=2 sts=2 sw=2
autocmd FileType make setlocal ts=4 sts=2 sw=2 noexpandtab

autocmd FileType vim setlocal foldmethod=marker
autocmd FileType vim setlocal foldmarker={{{,}}}
autocmd FileType vim setlocal foldlevel=1
autocmd FileType vim normal zM

autocmd FileType c,cpp,java,javascript,css,php,conf setlocal foldmethod=marker
autocmd FileType c,cpp,java,javascript,css,php,conf setlocal foldmarker={,}
autocmd FileType c,cpp,java,javascript,css,php,conf setlocal foldlevel=1
autocmd FileType c,cpp,java,javascript,css,php,conf normal zM


autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " Disable comment new line

autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
autocmd BufWritePost *aliasrc,*bashrc,*bash_prompt !source %
" autocmd BufWritePost *vimrc :source %
autocmd BufWritePost *tmux.conf !tmux source-file %


"autocmd FileType cpp,java setlocal equalprg=astyle\ -A1sCSNLYpHUEk1xjcn
"autocmd FileType python setlocal makeprg=pylint
"autocmd FileType c setlocal commentstring=//\ %s
"autocmd FileType cpp setlocal commentstring=//\ %s
"autocmd FileType python setlocal fdm=indent formatprg=autopep8\ -


"autocmd FileType html,xhtml,xml,haml,jst,python,ruby setlocal foldmethod=indent
"autocmd FileType python,ruby setlocal foldlevel=1
"autocmd FileType html,xhtml,xml,haml,hst setlocal foldlevel=20
"autocmd FileType html,xhtml,xml,haml,jst,ruby normal zR

"}}}
" KEYMAPPING {{{
nnoremap <bs> <nop>
nnoremap <delete> <nop>
nnoremap <Space> <nop>
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor


let mapleader=","
let g:mapleader = ","
map <space> <leader>

nmap Q q

" Allows to go throw wrapped lines
nnoremap <silent> j gj
vnoremap <silent> j gj
nnoremap <silent> k gk
vnoremap <silent> k gk


" jk is now esc
"inoremap jk <esc>
"cnoremap jk <esc>
"vnoremap jk <esc>


" Folding focus
nnoremap <leader>z zMzvzz

" Move blocks of text around
nnoremap <C-j> :m+<CR>==
nnoremap <C-k> :m-2<CR>==
inoremap <C-j> <Esc>:m+<CR>==gi
inoremap <C-k> <Esc>:m-2<CR>==gi
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv

nnoremap <leader>sudo :w !sudo tee % <CR><CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :q!<CR>

nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>h <C-w>h
nnoremap <leader>l <C-w>l


" yy to yank whole line
nnoremap yy Y
nnoremap Y y$

" searching will keep cursor on middle of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

" Make shifting indent in visual mode not removing the visual selection
vnoremap > >gv
vnoremap < <gv

" upper/lower first char of word
nnoremap <leader>u mQviwU`Q
nnoremap <leader>d mQviwu`Q
nnoremap <leader>U mQgewvU'Q
nnoremap <leader>D mQgewvu'Q

" select all text in current buffer
nnoremap <leader>a ggVG

" Format entire file
nnoremap <leader>fef ggVG=

" jump to matching pair
nnoremap <Leader>m %

" Visually select the text that was last edited/pasted
nnoremap gV `[v`]

nnoremap <silent> <leader>bn :bn<cr>
nnoremap <silent> <leader>bp :bp<cr>
nnoremap <leader>bd :bdelete<cr>
nnoremap <leader>bb :buffers<cr>:buffer
"}}}
" PLUGIN KEYBINDS {{{
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-t> :TagbarToggle<CR>
nnoremap <C-e> :UndotreeToggle<CR>
nnoremap <C-w> :call asyncrun#quickfix_toggle(8)<CR>
nnoremap <C-r> :AsyncRun ctags -R .<CR>
"nnoremap <C-t> :set nosplitright<CR>:TagbarToggle<CR>:set splitright<CR>

" imap <c-x><c-w> <plug>(fzf-complete-word)
" imap <c-x><c-p> <plug>(fzf-complete-path)
" imap <c-x><c-f> <plug>(fzf-complete-file)
" imap <c-x><c-a> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)
" nnoremap <leader><c-w> <plug>(fzf-complete-word)

" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)



" open with locate or find command
" tutorial video: https://www.youtube.com/watch?v=X0KPl5O006M
" noremap <leader>o :exec '!xdg-open ' . shellescape(getline('.')) <CR><CR>
" noremap <leader>mp :exec '!mplayer ' . shellescape(getline('.')) <CR><CR>
" noremap <leader>p :exec '!vlc $(youtube-dl -g ' . shellescape(getline('.')) . ')' <CR><CR>
"}}}
" SCREEN MOVEMENT {{{
" mapping to make movements operate on 1 screen line in wrap mode
"function! ScreenMovement(movement)
   "if &wrap
      "return "g" . a:movement
   "else
      "return a:movement
   "endif
"endfunction
"
"onoremap <silent> <expr> j ScreenMovement("j")
"onoremap <silent> <expr> k ScreenMovement("k")
"onoremap <silent> <expr> 0 ScreenMovement("0")
"onoremap <silent> <expr> ^ ScreenMovement("^")
"onoremap <silent> <expr> $ ScreenMovement("$")
"nnoremap <silent> <expr> j ScreenMovement("j")
"nnoremap <silent> <expr> k ScreenMovement("k")
"nnoremap <silent> <expr> 0 ScreenMovement("0")
"nnoremap <silent> <expr> ^ ScreenMovement("^")
"nnoremap <silent> <expr> $ ScreenMovement("$")
"}}}
" NERDTREE {{{
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'


let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
" }}}
" AUTO-PAIRS {{{
let g:AutoPairsCenterLine=1
let g:AutoPairsMapSpace=1
let g:AutoPairsFlyMode=0
"}}}
" ALE {{{
let g:ale_python_flake8_options = '--ignore=E129,E501,E302,E265,E241,E305,E402,W503'
let g:ale_python_pylint_options = '-j 0 --max-line-length=120'

let g:ale_list_window_size = 6
let g:ale_sign_column_always = 0
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1

" Options are in .pylintrc!
highlight VertSplit ctermbg=253

highlight ALEWarning cterm=underline
highlight ALEError cterm=underline
"highlight ALEWarning ctermfg=Yellow cterm=underline
"highlight ALEError ctermfg=Red cterm=underline


let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

let g:ale_linters = {
\'python': 'all',
\'bib': 'all',
\'bash': 'all',
\'sh': 'all',
\'vim': 'all',
\'latex': 'all',
\'tex': 'all',
\'text': 'all',
\'markdown': 'all'
\}
let g:ale_fixers = {
\'*': ['remove_trailing_lines', 'trim_whitespace'],
\'python': ['isort', 'autopep8', 'yapf', 'add_blank_lines_for_python_control_statements'],
\'bash': 'shfmt',
\'sh': 'shfmt',
\}

nmap <silent> <C-M> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)

let g:ale_completion_enabled=0

"}}}
" JEDI {{{
let g:jedi#auto_initialization = 1

let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0

let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = "1"
let g:jedi#show_call_signatures_delay = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures_modes = 'i'  " ni = also in normal mode
let g:jedi#enable_speed_debugging=0

let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>v"
let g:jedi#documentation_command = "<leader>c"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "C-Space"
let g:jedi#rename_command = "<leader>r"
"}}}
" COMPLETION {{{
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
    \ 'name': 'omni',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['python'],
    \ 'completor': function('asyncomplete#sources#omni#completor')
    \  }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
    \ 'name': 'necosyntax',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
    \ }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'whitelist': ['c'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \ 'name': 'necovim',
    \ 'whitelist': ['vim'],
    \ 'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))




set omnifunc=syntaxcomplete#Complete
"au FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS

set completeopt+=preview
set completeopt+=menuone
set completeopt+=noinsert


" let g:SuperTabDefaultCompletionType="<C-X><C-O>"
"let g:SuperTabDefaultCompletionType="context"


let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" to do text select via j/k
inoremap <expr> j     ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k     ((pumvisible())?("\<C-p>"):("k"))
inoremap <expr> <cr>  ((pumvisible())?("\<C-y>"):("<cr>"))
inoremap <silent><expr> <TAB>  (pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : asyncomplete#force_refresh())
"inoremap <expr> <S-TAB> ((pumvisible())?("\<C-p>"):("\<C-h>"))
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

"}}}
" SimpylFold {{{
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_import=1
"}}}
" IMPSORT {{{
hi pythonImportedObject ctermfg=127
hi pythonImportedFuncDef ctermfg=127
hi pythonImportedClassDef ctermfg=127
"}}}
" GITGUTTER {{{
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0
"}}}
" PIPENV {{{
" let g:pipenv_auto_activate=1
"}}}
" ASYNCRUN {{{
let g:asyncrun_mode=0
let g:asyncrun_open = 3
"}}}
" RUN FUNC {{{
nnoremap <leader>r :call <SID>compile_and_run()<CR>
" command R :call Runit()


let pipenv_venv_path = system('pipenv --venv')
if shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  let g:python3_host_prog = pipenv_venv_path . '/bin/python3.5'
  let g:python_host_prog = pipenv_venv_path . '/bin/python'
else
  let g:python3_host_prog = '/usr/bin/python3.5'
  let g:python_host_prog = '/usr/bin/python2'
endif



function! s:compile_and_run()
    exec 'w'
    if &filetype == 'c'
        exec "AsyncRun! gcc % -o %<; time ./%<"
    elseif &filetype == 'cpp'
       exec "AsyncRun! g++ -std=c++11 % -o %<; time ./%<"
    elseif &filetype == 'java'
       exec "AsyncRun! javac %; time java %<"
    elseif &filetype == 'sh'
       exec "! time bash %"
    elseif &filetype == 'python'
       exec "AsyncRun! time python3.5 %"
    elseif &filetype == 'ruby'
       exec "AsyncRun! time ruby %"
    elseif &filetype == 'javascript'
       exec "AsyncRun! time node %"
    elseif &filetype == 'lua'
       exec "AsyncRun! time lua %"
    elseif &filetype == 'coffee'
       exec "AsyncRun! time coffee %"
    elseif &filetype == 'php'
       exec "AsyncRun! time php %"
    elseif &filetype == 'tex'
       exec "AsyncRun! time latexmk -pvc -pdf %"
    endif
endfunction
"}}}


" highlight python and self function
autocmd BufEnter * syntax match Type /\v\.[a-zA-Z0-9_]+\ze(\[|\s|$|,|\]|\)|\.|:)/hs=s+1
autocmd BufEnter * syntax match pythonFunction /\v[[:alnum:]_]+\ze(\s?\()/
hi def link pythonFunction Function
autocmd BufEnter * syn match Self "\(\W\|^\)\@<=self\(\.\)\@="
highlight self ctermfg=239

" easy breakpoint python
"au FileType python map <silent> <leader>b ofrom pudb import set_trace; set_trace()<esc>
"au FileType python map <silent> <leader>j ofrom pdb import set_trace; set_trace()<esc>
"au FileType python map <silent> <leader>j oif __name__ == "__main__":<CR>main()<esc>
