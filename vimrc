set tabstop=4   "tab等于4空格
set incsearch   "实时搜索
set hls			"高亮搜索
set expandtab   "输入tab自动替换为空格。:%retab!替换当前文件的所有tab为4空格。写makefile时需注意设置set noexpandtab
set ic          "忽略大小写
set nu          "显示行号
set noswapfile  "没有交换文件
set shiftwidth=4 "缩进宽度
set pastetoggle=<F11> 
set nowrap  "不自动换行
set laststatus=2     "显示状态栏
set statusline=[%n][f=%F][%l/%L\ %c][hex=%B]
"set mouse=a "支持鼠标，不太好用
syntax on

set t_Co=256
hi Search term=reverse ctermfg=154 ctermbg=8 guibg=#808080 guifg=#af00ff
hi Visual term=reverse ctermfg=0 ctermbg=15 guibg=#ffffff guifg=#000000
hi SpellBad term=reverse ctermfg=0 ctermbg=7 guibg=#c0c0c0 guifg=#000000
hi MatchParen term=reverse ctermfg=0 ctermbg=14 guibg=#00ffff guifg=#000000
highlight Comment ctermfg=lightblue

match Todo /\vREADME:/

"打开文件回到上次位置
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

"vundle配置
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'           " 插件管理
Plugin 'Valloric/YouCompleteMe'         " ycm
Plugin 'kien/ctrlp.vim'                 " 文件搜索，ctrl+p
Plugin 'Yggdroot/LeaderF'               " 模糊搜索，替代ctrlp
Plugin 'inkarkat/vim-ingo-library'      " 
Plugin 'inkarkat/vim-mark'              " dependent on vim-ingo-library. 多颜色高亮，mark插件增强版
Plugin 'luochen1990/rainbow'            " 彩虹括号
Plugin 'easymotion/vim-easymotion'      " 移动光标插件
Plugin 'thaerkh/vim-workspace'          " workspace
Plugin 'scrooloose/nerdtree'            " file tree
Plugin 'dominikduda/vim_current_word'   " hilight current word and underline same word
Plugin 'fatih/vim-go'
"Plugin 'Asheq/close-buffers.vim'
Plugin 'schickling/vim-bufonly'
call vundle#end()            " required
filetype plugin indent on    " required

"ycm配置
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>

let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_key_list_select_completion = ['<Tab>', '<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_semantic_triggers =  {
            \   'c' : ['->', '.'],
            \   'objc' : ['->', '.'],
            \   'ocaml' : ['.', '#'],
            \   'cpp,objcpp' : ['->', '.', '::'],
            \   'perl' : ['->'],
            \   'php' : ['->', '::', '(', 'use ', 'namespace ', '\'],
            \   'cs,java,typescript,d,python,perl6,scala,vb,elixir,go' : ['.', 're!(?=[a-zA-Z]{3,4})'],
            \   'html': ['<', '"', '</', ' '],
            \   'vim' : ['re![_a-za-z]+[_\w]*\.'],
            \   'ruby' : ['.', '::'],
            \   'lua' : ['.', ':'],
            \   'erlang' : [':'],
            \   'haskell' : ['.', 're!.'],
            \   'css': [ 're!^\s{2,4}', 're!:\s+' ],
            \   'javascript': ['.', 're!(?=[a-zA-Z]{3,4})'],
            \   'python': ['.']
            \ }
"颜色配置，适用ycm
highlight Pmenu ctermfg=15 ctermbg=8 guifg=#ffffff guibg=#808080

fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

autocmd BufNewFile *.js,*.[ch],*.sh,*.py exec ":call SetTitle()" 
func! SetTitle() 
    if &filetype == 'sh' 
        call setline(1,"\#!/bin/bash")
        call append(line("."), "") 
        call append(line("."), "") 
    elseif &filetype == 'javascript'
        call setline(1,"\"use strict\";")
        call append(line("."), "") 
        call append(line("."), "")
    elseif &filetype == 'python'
        call setline(1,"# -*- coding:utf-8 -*-")
        call append(line("."), "") 
        call append(line("."), "")
    endif
endfunc 
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G

nnoremap <leader>r :call RunFile() <CR>
func! RunFile()
    exec "wa"
    if &filetype == 'javascript'
        exec "!./node_modules/.bin/mocha %"
    elseif &filetype == 'go'
        exec "GoRun"
    endif
endfunc
nnoremap <leader>e :call RunEslint() <CR>
func! RunEslint()
    exec "w"
    exec "!./node_modules/.bin/eslint %"
endfunc

let mapleader=","
",q 取消高亮
map <leader>q :nohl<Cr>
"\f显示函数名
nnoremap <leader>a :call ShowFuncName() <CR>
let mapleader="\\"

"set foldmethod=indent
"au FileType * normal zR
"au BufEnter * normal zR

let g:rainbow_active = 1  "彩虹括号生效。和vim-js冲突 

"移动半页, C-k与tmux冲突
nmap <C-j> <C-d>
nmap <C-k> <C-u>

"easymotion
let g:EasyMotnon_smartcase = 1
map <Leader><leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><leader>l <Plug>(easymotion-lineforward)
nmap s <Plug>(easymotion-s)

"leaderF
" let g:Lf_ShortcutF = '<leader>P'
nmap <C-s> :LeaderfBufTagAll<Cr>
let g:Lf_UseVersionControlTool = 0
let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg', 'build'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.txt']
        \}

"ctrlp
"让ctrlp使用ag, leaderf重复了
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

"好像不需要这些映射
"imap <A-j> <Down>
"imap <A-k> <Up>
"imap <A-h> <Left>
"imap <A-l> <Right>
"source ~/.vim/force.vim

"cscope
if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
endif
"set cscopequickfix=s-,c-,d-,i-,t-,e-
let mapleader=","
nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nmap <leader>x :cn<CR>
nmap <leader>z :cp<CR>
let mapleader="\\"


"workspace
nnoremap <leader>s :ToggleWorkspace<CR>
let g:workspace_session_disable_on_args = 1

"
function! Offhlsyn()
    set filetype=
    set syntax=
    syntax off
endfunction
nnoremap <F9> :call Offhlsyn()<CR>


"search list
function! FindAll()
    call inputsave()
    let p = input('Enter pattern:')
    call inputrestore()
    execute 'vimgrep "'.p.'" % |copen'
endfunction
nnoremap <F8> :call FindAll()<CR>


if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

"nerdtree
map <F10> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"current word color
hi CurrentWord ctermbg=237 ctermfg=2
hi CurrentWordTwins ctermbg=237 cterm=underline gui=underline ctermfg=117

