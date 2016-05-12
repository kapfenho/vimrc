syntax enable

set vb t_vb=            " we dont need no beeping software

set smarttab            " separate indent and rest
                        "     indent: shiftwidth
                        "     rest: tabstop/softtabstop
                        " nosmarttab: tabstop/softtabstop, expandtab
set tabstop=8           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " tab: number of spaces before first char, (auto)indent
set expandtab           " for indent, edit, ect: use spaces instead of tab
set autoindent          " auto indent on new lines

set number              " show line numbers
set ruler
set showcmd             " show command in bottom bar
set cursorline          " highlight currentl line
set scrolloff=3         " always show nr lines below and above
set backspace=indent,eol,start  " allow backspace over averything in
                        " insert mode
silent! set mouse=a     " use mouse for all modes

set hidden
set encoding=utf-8

filetype plugin indent on  " file type specific indent and plugins

set wildmenu            " visual autocomplete for command meu
set lazyredraw          " redraw only when necessary
set showmatch           " highlight matching [{()}]

set modeline            " modeline on (eg. vi:ft=...)
set modelines=10        " search in first/last 10 lines

set smartcase           " for searching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

if has("folding")
  set foldenable          " enable folding
  set foldlevelstart=10   " open most folds by default
  set foldnestmax=10      " 10 nested folds max
  "set foldmethod=indent  " or manual,syntax,expr,marker,diff
endif

" tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

let mapleader=","       " leader is comma
noremap \ ,

                        " turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" move vertically on visual long lines
nnoremap j gj
nnoremap k gk

let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

set backup
set backupdir=~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

silent! execute pathogen#infect()
silent! execute pathogen#runtime_append_all_bundles()

let g:solarized_termcolors=256
set background=dark
silent! colorscheme solarized
" silent! colorscheme molokai
" silent! colorscheme badwolf

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
"
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" toggle between number and relativenumber
"
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" ruby load path
" let g:ruby_path = system('echo $RBENV_ROOT/shims')

set laststatus=2
set statusline=
set statusline+=%-3.3n\                       " buffer name
set statusline+=%f\                           " filename
set statusline+=%h%m%r%w                      " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}]  " file type
set statusline+=%=                            " right align remainder
set statusline+=0x%-8B                        " character value
set statusline+=%-14(%l,%c%V%)                " line, character
set statusline+=%<%P                          " file position

" syntastic bundle - syntax error checks
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

" automatic set paste mode, tmux enabled
" 
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" paste mode end

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

