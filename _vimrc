" Last Change: 2026-02-24.
"
" System name
if has('win32') || has('win64')
  let g:uname = 'WINDOWS'
else
  let g:uname = system('uname')
endif

let s:backupdir = $HOME . '/.vimbackup'
if !isdirectory(s:backupdir)
  call mkdir(s:backupdir, "p")
endif

" for backupfile dirctory
let  &backupdir=s:backupdir . ',.'
" for swapfile dirctory
let &dir=s:backupdir . ',.'
" for undofile dirctory
let &undodir=s:backupdir . ',.'
set backup
set writebackup
set swapfile

"---------------------------------------------------------------------------
" encoding に関する設定
set encoding=utf-8
let &termencoding = &encoding
set fileencodings=utf-8,cp932,euc-jp,iso-2011-jp,utf-16
scriptencoding utf-8
set matchpairs+=「:」,『:』,【:】,（:）

"---------------------------------------------------------------------------
" 前回編集していた場所にカーソルを移動させる
if g:uname =~? 'Linux'
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"---------------------------------------------------------------------------
" 新規ファイルを作る場合, utf-8 で。
autocmd BufNewFile * set fileencoding=utf-8
if &fileencoding == ''
  set fileencoding=utf-8
endif

" ○などの文字を全角として扱う
if &encoding == 'utf-8'
  set ambiwidth=double
endif

"---------------------------------------------------------------------------
" 基本的な設定
set nowrapscan
set visualbell
set smartindent
set hlsearch
set ignorecase
packadd! matchit
set scrolloff=0
set completeopt=menuone

"---------------------------------------------------------------------------
" 整形に関するオプション
set formatoptions+=ro2M

"---------------------------------------------------------------------------
" Git Bash の vim も vimfiles を使う
if 0
  if g:uname =~? 'MINGW'
    set runtimepath+=~/vimfiles
    set runtimepath+=~/vimfiles/after
  endif
endif

"---------------------------------------------------------------------------
" 香り屋のプラグインと日本語ヘルプを利用する
if &runtimepath !~ 'kaoriya'
  if isdirectory('/opt/vim-kaoriya/kaoriya/vim/plugins/kaoriya')
    set runtimepath+=/opt/vim-kaoriya/kaoriya/vim/plugins/kaoriya
  elseif isdirectory('/c/vim/plugins/kaoriya')
    set runtimepath+=/c/vim/plugins/kaoriya
  endif
endif
if &runtimepath !~ 'vimdoc-ja'
  if isdirectory('/opt/vimdoc-ja')
    set runtimepath+=/opt/vimdoc-ja
  elseif isdirectory('/c/vim/plugins/vimdoc-ja')
    set runtimepath+=/c/vim/plugins/vimdoc-ja
  endif
endif

"---------------------------------------------------------------------------
" カラー設定:
if &term =~ 'xterm'
  set t_Co=256
endif
" terminal でも GUI の色指定を可能にする
set termguicolors

"--------------------------------------------------------------------------
" for syntax highlighting (カラーキーワード)
function! SetHicolors()
    set background=light

    colorscheme default
    " 'flazz/vim-colorschemes' をインストールすれば以下も有効になる。
    "colorscheme Dev_Delight
    "colorscheme DevC++
    "colorscheme buttercream
    "colorscheme khaki
    "colorscheme mellow

    " Normal の ctermbg の色が全体の背景色になる。
    " black は コマンドプロンプトでは「プロパティ」-「画面の色」で設定した背景
    " 色になる。
    if (&t_Co < 256) && !has('gui_running')
      highlight Normal ctermfg=blue ctermbg=lightgrey
    else
      "highlight Normal ctermfg=black ctermbg=229 guifg=black guibg=Cornsilk1
      "highlight Normal ctermfg=black ctermbg=229 guifg=black guibg=Khaki1
      "highlight Normal ctermfg=black ctermbg=229 guifg=black guibg=LightYellow
      if &term != 'xterm-256color'
        highlight Normal guibg=#f0f0d0
      endif
    endif
    highlight CursorIM guibg=magenta

    " 以下 クリーム色の背景色を前提とした設定
    "for diff
    highlight DiffAdd ctermfg=darkblue  ctermbg=lightgreen guifg=darkblue guibg=lightgreen
    highlight DiffChange ctermfg=black ctermbg=lightgreen guifg=black guibg=lightgreen
    highlight DiffDelete ctermfg=red ctermbg=lightred guifg=red guibg=lightred
    highlight DiffText cterm=NONE ctermfg=black ctermbg=cyan gui=NONE guifg=black guibg=skyblue

    highlight StatusLine cterm=bold ctermfg=black ctermbg=lightmagenta guifg=black guibg=lightmagenta
    highlight StatusLineNC ctermfg=black ctermbg=yellow guifg=black guibg=yellow
    highlight Statement cterm=bold
    highlight Type cterm=bold
    highlight Title cterm=bold ctermfg=magenta
    highlight SpellBad cterm=undercurl,italic guifg=red guibg=lightGray
    highlight SpellCap cterm=undercurl,italic guifg=red guibg=lightGray
    highlight PmenuSbar  ctermfg=yellow ctermbg=darkcyan
    highlight PmenuThumb guifg=yellow guibg=darkcyan
    highlight Ignore  guifg=white guibg=darkred
    highlight Error gui=bold cterm=bold guifg=black guibg=Red1
    syntax match  HttpUrl /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
    highlight HttpUrl ctermfg=blue guifg=blue

    if g:uname =~? 'CYGWIN'
      highlight ModeMsg guifg=darkgray
      highlight VisualNOS guifg=darkgray
      highlight TabLineSel guifg=darkgray
    endif
endfunction

"-------------------------------------------------------------
" カラーのテスト
" :call Colortest()
function! Colortest()
    edit $VIMRUNTIME/syntax/colortest.vim
    source %
endfunction

" ハイライトのテスト
" :call Hitest()
function! Hitest()
    source $VIMRUNTIME/syntax/hitest.vim
endfunction

if has ("syntax")
  syntax on
  autocmd VimEnter,ColorScheme * call SetHicolors()
endif

"---------------------------------------------------------------------------
" バイナリファイルを編集
" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

"---------------------------------------------------------------------------
" tag ジャンプ で複数候補を表示
map  g
set tags=./tags;

"---------------------------------------------------------------------------
" ステータスラインに文字コードと改行コードを表示させる
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set laststatus=2
"---------------------------------------------------------------------------
" Taglist での 更新時間
set updatetime=1000

"---------------------------------------------------------------------------
" メモ用の色づけが可能
map \m i vim:set ts=8 sts=2 sw=2 tw=78 et ft=memo:
"---------------------------------------------------------------------------
" Last change: . を挿入する
map ,la i Last Change: .
"---------------------------------------------------------------------------
" タイムスタンプの自動更新
" 'Last Change: . ' と先頭から50行以内に記述してあれば有効。
let autodate_format='%Y-%m-%d'

"---------------------------------------------------------------------------
" 罫線描画  (keisen.vim)
let keisen_type=0

"---------------------------------------------------------------------------
" 差分表示する際、スペースの数の違いは無視する。
set diffopt=iwhite
set diffopt+=filler    " 削除行を ---- で表示
set diffopt+=context:10000    " 変更のない行も表示する

"---------------------------------------------------------------------------
" grep  関連
"" grep プログラムの指定
if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor
else
  set grepprg=grep\ -rnIH\ --exclude=*.so\ --exclude=*.o\ --exclude=tags\ --exclude=.git
endif

autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen

"" short cut キーによる grep の起動 (カレントディレクトリ以下を再帰的に検索する)
"   space,g でカーソル下のワードを vim の内部grep で検索
"   space,G でカーソル下のワードを 外部 grep プログラムで検索
nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*.' . expand('%:e')
nnoremap <expr> <Space>G ':sil grep! ' . expand('<cword>') . ' .'

"---------------------------------------------------------------------------
" bccalc.vim (vim 上での bc による計算) の設定
"" 全角文字の入力を許す
let bccalc_input_allow_zenkaku = 1
"" 全角での出力
"let bccalc_output_zenkaku = 1
"" 出力を 3桁ずつカンマで区切る
"let bccalc_output_comma = 1
"" 小数部の出力桁数 (デフォルト 3桁)
"let bccalc_output_decimals = 5
"" bc プログラム
" let bccalc_bc_prog = "c:\\UnxUtils\\usr\\local\\wbin\\bc"
"
"  ※全角文字の入力を許すには $VIMRUNTIM/plugin/hz_ja.vim が文字化けするこ
"    となく動作することが必要。
"    文字化けする場合は、hz_ja.vim の先頭で 'source $VIM/encode_japan.vim' す
"    ると良い。

"---------------------------------------------------------------------------
" 外部プログラム GNU indent による C ソースの整形 (Berkeley 風や K&R 風にする)
" 操作方法：
"   (1) Visual モードで整形範囲を選択し、,i とキーインする。
"       下記 indent_options のオプション指定でで整形する
"   (2) Visual モードで整形範囲を選択し、,I とキーインする。
"       下記 indent_options2 のオプション指定でで整形する
"   (3) コマンドラインで範囲を選択し、Indent とキーインする。
"       下記 indent_options のオプション指定でで整形する
"   (4) コマンドラインで範囲を選択し、Indent2 とキーインする。
"       下記 indent_options2 のオプション指定でで整形する
"
" GNU indent のオプション設定：
"let g:indent_options = "-bad -bap -nbc -npsl -di8 -l78 -orig"
let g:indent_options = "-bad -bap -nbc -di8 -l78 -orig"
let g:indent_options2 = "-c49 -cd49 -bad -bap -nbc -npsl -di8 -l78 -orig"
let g:indent_options_kr = "-bad -ncs -fca -sc -di8 -l78 -kr"
let g:indent_options_kr2 = "-c49 -cd49 -bad -ncs -fca -sc -di8 -l78 -kr"
"  -cdn : 宣言の右側のコメント開始位置 
"  -cn : コードの右側のコメント開始位置
"    ※値の代入を伴う enum 文を整形する際はこの二つ値を同じにすると良い。
" indent プログラムの指定
let g:indentprog = "indent"
"let g:indentprog = "c:/VimExBin/indent.exe"
"let g:indentprog = "c:/cygwin/bin/indent"
" (整形用の i/F は vimfiles/after/indent/c.vim に入れてある。)

"---------------------------------------------------------------------------
" 外部プログラム Artistic Style による C ソースの整形
vnoremap ,a !AStyle<CR>
" AStyle で "Cannot set native locale..." を出さないようにする。
if &encoding == 'utf-8'
  let $LC_ALL="ja_JP.utf-8"
endif

"---------------------------------------------------------------------------
" make プログラムの指定
if g:uname == 'WINDOWS'
    set makeprg=mingw32-make
else
    "  cygwin の make
    set makeprg=make
end

" Quickfix
" for AdLint
"set errorformat=%t\\,%f\\,%l\\,%c\\,W%n\\,%m
" for cppcheck
"set errorformat=[%f:%l]\ %m,[%f:%l]:%m
" for mingw
"set errorformat=%f:%l:%c:\ %m
" for mingw + cppcheck
"set errorformat=%f:%l:%c:\ %m,[%f:%l]\ %m,[%f:%l]:%m
map _c :make %.chk.txt:cgetfile %.chk.txt:copen

"---------------------------------------------------------------------------
" :history によって表示した過去のコマンドを
"      :H 履歴番号
" にて再度実行するコマンドを定義する。
" (履歴表示中に q で表示を止め、: による履歴編集画面で Enter の方が早いかも)
command! -nargs=1 H execute histget("cmd",0+<args>)

"---------------------------------------------------------------------------
" 現在の日時を '2014-05-16 16:09' の書式で挿入する
map ,dt :call InsertDatetime()<CR>
func! InsertDatetime()
  if g:uname == 'WINDOWS'
    let date_str = system("date /t") . system("time /t")
    let date_str = substitute(date_str, '/', '-', 'g')
  else
    let date_str = system("date +'\%F \%R'")
  endif
  let date_str = substitute(date_str, '\n', '', 'g')
  exec "normal i" . "'" . date_str ."'"
endfunc

" 現在の日付けを 2014-05-16 の書式で挿入する
map ,d :call InsertDate()<CR>
func! InsertDate()
  if g:uname == 'WINDOWS'
    let date_str = system("date /t")
    let date_str = substitute(date_str, '/', '-', 'g')
  else
    let date_str = system("date +'\%F'")
  endif
  let date_str = substitute(date_str, '\n', '', 'g')
  exec "normal i" . date_str
endfunc

"---------------------------------------------------------------------------
" visual mode で選択した範囲の文字数を表示する。
set showcmd

"---------------------------------------------------------------------------
" 挿入モードでのIME状態を記憶させない
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

"--------------------------------------------------------------------------
" Vim plugin 管理ツール dein
"
" 変数 s:use_dein
"    0 : dein を使わない。
"    1 : dein を使う。
let s:use_dein = 1

" dein と 各プラグインをインストールする場所
"if g:uname == 'WINDOWS' || g:uname =~? 'MINGW'
if g:uname == 'WINDOWS'
  let g:vimfiles_dir =expand("~/vimfiles")
else
  let g:vimfiles_dir =expand("~/.vim")
endif

if s:use_dein != 0
  let s:dein_dir = g:vimfiles_dir . "/dein"
  let s:dein_toml = g:vimfiles_dir . '/rc/dein.toml'
  let s:dein_lazy_toml = g:vimfiles_dir . '/rc/dein_lazy.toml'

  " dein 自体をインストールする
  if has('vim_starting')
    if &compatible
      set nocompatible
    endif
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
    " dein をインストールしていない場合は自動インストール
    if !isdirectory(s:dein_repo_dir)
      echomsg "Installing dein.vim ..."
      set shellredir=>%s\ 2>&1
      let s:git_result=system('git clone -q https://github.com/Shougo/dein.vim.git ' . s:dein_repo_dir)
      if v:shell_error != 0
        let s:git_result = substitute(s:git_result, '\n', "", "g")
        echohl Error
        if g:uname == 'WINDOWS'
          echomsg iconv(s:git_result, 'cp932', &encoding)
        else
          echomsg s:git_result
        endif
        if match(s:git_result, "Couldn't resolve host 'github.com'") >= 0
          echomsg 'Configure Git proxy setting as follows in Git Bash!'
          echomsg ' $ git config --global http.proxy YOUR_PROXY_SERVER:PORT_NUMBER'
        endif
        echohl None
        finish
      endif
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
  endif

  if !filereadable(s:dein_toml) || !filereadable(s:dein_lazy_toml)
    echohl Error
    echomsg 'dein.toml and/or dein_lazy.toml not found in ' . g:vimfiles_dir . '/rc'
    echohl None
    finish
  endif

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:dein_toml, {'lazy': 0})
    call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
  endif

  if dein#check_install()
    " vimrc に記述されたプラグインでインストールされていないものがないかチェックする
    echomsg "Installing plugins..."
    call dein#install()
  endif

  filetype plugin indent on
endif  "if s:use_dein != 0

"--------------------------------------------------------------------------
" プロジェクト固有の設定 _vimrc.local を読み込む
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('_vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
