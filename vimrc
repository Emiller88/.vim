﻿
set nocompatible

let g:is_ssh = ($SSH_TTY != "")

" Preferences {{{
    syntax on

    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

    " Editor looks {{{
        " Disable matchit, I find it distracting
        let loaded_matchparen = 1

        if &t_Co == 8 && $TERM !~# '^linux'
            set t_Co=16
        else
            set t_Co=256
        endif
        set background=dark
        let g:rehash256 = 1
        colorscheme molokai

        set number                   " Line numbers
        set showcmd                  " Show command issued
        set fillchars=vert:¦
        set list
        set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
        set textwidth=88

        set synmaxcol=1500
    " }}}

    " Behavior {{{
        set noeol
        set autoread                 " Auto-update a file that's been edited externally
        set nospell                  " No spell check, please
        set visualbell               " No sounds!
        set backspace=indent,eol,start
        set lazyredraw               " Don't update screen while running macros
        set hidden                   " Hide abandoned buffers
        set shortmess+=filmnrxoOtTs
        set nrformats-=octal
        set fileformats+=mac

        set mouse=a
        set iskeyword-=_             " Regard _ as a word boundary
    " }}}

    " StatusBar {{{
        if has('statusline')
            set laststatus=2
            set ruler                                      " Show line/col no in statusline
            set statusline=%t                              " tail of the filename
            set statusline+=%w%h%m%r                       " Options
            if exists('g:loaded_syntastic_plugin')
                set statusline+=\ %{SyntasticStatuslineFlag()}
            endif
            set statusline+=%=                             " left/right separator
            set statusline+=%y                             " filetype
            if exists('g:loaded_fugitive')
                set statusline+=\ %{fugitive#statusline()}     " Git Hotness
            endif
            set statusline+=\ •\
            set statusline+=%c                             " cursor column
            set statusline+=\ %l/%L                        " cursor line/total lines
            set statusline+=\ \:%P                         " percent through file
        endif
    " }}}

    " Movement & search {{{
        set nostartofline
        set sidescrolloff=5

        set incsearch            " find as you type
        set hlsearch             " Highlight search terms
        set ignorecase           " case insensitive search
        set smartcase            " case sensitive when uc present
        set gdefault             " global flag for substitute by default

        if executable('ag')
            let g:ackprg = 'ag --nogroup --nocolor --column'
            set grepprg=ag\ --nogroup\ --nocolor
        elseif executable('ack-grep')
            let g:ackprg = "ack-grep -H --nocolor --nogroup --column"
        endif
    " }}}

    " Text formatting {{{
        set autoindent
        set shiftround
        set expandtab
        set shiftwidth=4
        set tabstop=4
        set softtabstop=4
        " Wrapping
        set nowrap
        " Backspace and cursor keys to wrap
        set whichwrap=b,s,h,l,<,>,[,]
        " see :h fo-table
        set formatoptions=qrn1lr

        function! <SID>StripTrailingWhitespaces()
            let l = line(".")
            let c = col(".")
            %s/\s\+$//e
            call cursor(l, c)
        endfun
        autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
    " }}}

    " Folding {{{
        set foldlevel=1
        " Cleaner, readable fold headers
        set foldtext=MyFoldText()
        fu! MyFoldText()
            let line = getline(v:foldstart)
            " Lines that have been folded
            let nl = v:foldend - v:foldstart + 1

            let indent = repeat(' ', indent(v:foldstart))
            let endcol = &colorcolumn ? &colorcolumn : &textwidth
            let startcol = &columns < endcol ? &columns-4 : endcol

            return indent . substitute(line,"^ *","",1)
        endf
    " }}}

    " Swap files, history & persistence {{{
        " No backup (that's what git is for!) and swapfiles are annoying
        set nobackup
        set nowritebackup
        set noswapfile
        if has('persistent_undo')
            set undodir=~/.vim/tmp/undo
            set undolevels=500
            set undoreload=500
        endif
        set history=5000

        " preserve buffer state (cursor location, folds, etc.)
        set viewdir=~/.vim/tmp/views
        set viewoptions=cursor,folds,unix,slash
        augroup persistence
            au!
            au BufWinLeave * if expand("%") != "" | silent! mkview | endif
            au BufWinEnter * if expand("%") != "" | silent! loadview | endif
        augroup END
    " }}}

    " Omnicomplete + wild settings {{{
        set tags=./tags,./../tags,./../../tags,./../../../tags,tags

        set complete-=i
        set completeopt=menu
        set wildmenu                    " Show menu instead of auto-complete
        set wildmode=list:longest,full  " command <Tab> completion: list
                                        " matches -> longest common -> then
                                        " all.
        set wildignore+=*.swp,*.log,.sass-cache,.codekit-cache,config.codekit
        set wildignore+=*.class,*.o,*.pyc,*.obj,*DS_Store*
    " }}}

    " Show buffer name in tmux window name
    " au BufEnter * let &titlestring = expand("%")
    set titlestring=%f%m
    set title

    " Automatically close the popup menu / preview window
    au InsertLeave * if pumvisible() == 0|silent! pclose|endif

    " Set *.scss to ft=scss instead of css.scss
    au BufRead,BufNewFile *.scss set filetype=scss
    " For some reason vaxe's ftdetect isn't always on the ball
    au BufRead,BufNewFile *.hx set filetype=haxe
    " For emacs Caskfiles
    au BufRead,BufNewFile Cask set filetype=lisp
    " 2-space indentation
    au FileType ruby setl ts=2 sw=2 sts=2 et
" }}}

" Bundles and their settings are specified externally.
source $HOME/.vim/rc/plugins

" rcfiles
source $HOME/.vim/rc/keymaps
source $HOME/.vim/rc/util

" If one exists, this is where you'll want local settings
try
    source $HOME/.vimrc.local
catch
endtry

" vim:set fdl=0 fdm=marker:
