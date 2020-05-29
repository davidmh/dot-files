let g:mapleader = "\<SPACE>"

" Show white spaces at the end of a line
" set list listchars=tab:▸\ ,eol:¬,trail:·
set list listchars=tab:▸\ ,trail:·

set mouse=a

" edit this nvim config
command! Vimrc tabedit $HOME/.config/nvim/init.vim
command! CocConfig tabedit $HOME/.config/nvim/coc-settings.json
" auto-reload
augroup VimConfig
  au!
  au BufWritePost ~/.config/nvim/init.vim source <afile>
augroup END

" tabs as 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" avoid wrapping long lines by default
set nowrap

set cursorline

" allows modified-unsaved buffers to go into the background
set hidden

" be case-sensitive only when the search inclides upper-case characters
set ignorecase
set smartcase

" preview replace changes in a split window
set inccommand=split

set termguicolors

" share the clipboard with the OS
let s:actions = ['y', 'x', 'p', 'c']
let s:modes = ['n', 'v']
for action in s:actions
    let Action = toupper(action)
    for mode_target in s:modes
        exec printf('%snoremap <leader>%s "+%s', mode_target, action, action)
        exec printf('%snoremap <leader>%s "+%s', mode_target, Action, Action)
    endfor
endfor

let $TERM='dumb'

" Load vim-plug

let s:plug_target = '~/.vim/autoload/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:VtrUseVtrMaps = 1

if has('nvim')
  let s:plug_target = '~/.local/share/nvim/site/autoload/plug.vim'
endif

if empty(glob(s:plug_target))
  execute '!curl -fLo ' . s:plug_target . ' --create-dirs ' . s:plug_url
endif

let g:lt_location_list_toggle_map = 'L'
let g:lt_quickfix_list_toggle_map = 'Q'

" resize faster
nnoremap <M-,> <C-W>5<
nnoremap <M-.> <C-W>5>
nnoremap <M--> <C-W>5-
nnoremap <M-=> <C-W>5+
" from a terminal
tnoremap <M-,> <C-\><C-n><C-W>5<a
tnoremap <M-.> <C-\><C-n><C-W>5>a
tnoremap <M--> <C-\><C-n><C-W>5-a
tnoremap <M-=> <C-\><C-n><C-W>5+a

" move faster
nnoremap <M-up> <C-W>k
nnoremap <M-down> <C-W>j
nnoremap <M-left> <C-W>h
nnoremap <M-right> <C-W>l
" from a terminal
tnoremap <M-up>    <C-\><C-n><C-W>k
tnoremap <M-down>  <C-\><C-n><C-W>j
tnoremap <M-left>  <C-\><C-n><C-W>h
tnoremap <M-right> <C-\><C-n><C-W>l


" install plugins
call plug#begin('~/.config/nvim/bundle')
  " linting, autocompletion, LSP features
  " Plug 'neoclide/coc.nvim', {'tag': 'v0.0.78'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Plug 'davidhalter/jedi-vim'

  " the pope
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dadbod'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-projectionist'
  " Plug 'tpope/vim-rails'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-scriptease'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-vinegar'

  " javascript
  Plug 'pangloss/vim-javascript'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'galooshi/vim-import-js'

  " ruby
  Plug 'joker1007/vim-ruby-heredoc-syntax'
  Plug 'lucapette/vim-ruby-doc'

  " tmux integration
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'christoomey/vim-tmux-runner'

  " colorschemes
  Plug 'gruvbox-community/gruvbox'
  Plug 'liuchengxu/space-vim-dark'
  Plug 'kaicataldo/material.vim'
  Plug 'arcticicestudio/nord-vim'
  Plug 'junegunn/seoul256.vim'

  " other
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-slash'
  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/gv.vim'
  Plug 'Valloric/ListToggle'
  Plug 'tommcdo/vim-exchange'
  Plug 'vimwiki/vimwiki'
  Plug 'vim-scripts/BufOnly.vim'
  Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
  Plug 'ElmCast/elm-vim'
  Plug 'rhysd/vim-grammarous'
  Plug 'AndrewRadev/switch.vim'

  Plug 'yasuhiroki/circleci.vim'
call plug#end()

let g:space_vim_dark_background = 234
colorscheme gruvbox

" Remove the background from the current colorscheme to fallback to the
" colorscheme in the terminal
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

" vim-fugitive
" open the latest committed version of the current file
nnoremap <leader>ge :Gedit<cr>
" git blame for the current file
nnoremap <leader>gb :Gblame<cr>
" how git diff on the current changes
nnoremap <leader>gd :Gdiff<cr>
" show git status
nnoremap <leader>gs :Gstatus<cr>
" git log viewer
nnoremap <leader>gl :GV<CR>
" git log viewer for the current file
nnoremap <leader>gL :GV!<CR>
" stage/unstage
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gr :Gread<cr>
" open file in github
nnoremap <leader>go :Gbrowse<CR>
vnoremap <leader>go :'<,'>Gbrowse<CR>
nnoremap <leader>gp :Gpull<cr>

" Open buffers
nnoremap <leader>bb :Buffers<CR>
let g:fzf_buffers_jump = 1
" buffer kill
nnoremap <leader>bk :bprevious <bar> bdelete #<CR>
" Close all other buffers
nnoremap <leader>bo :BufOnly<CR>

augroup GitFormatType
  au!
  au BufEnter gitcommit set spell
augroup END

" Conquer of Completion
let g:coc_global_extensions = ['coc-json', 'coc-python', 'coc-tsserver', 'coc-solargraph', 'coc-eslint']
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
nmap <silent> <M-h> :call CocActionAsync('doHover')<CR>
nmap <silent> <M-d> <Plug>(coc-definition)
nmap <silent> <M-t> <Plug>(coc-type-definition)
nmap <silent> <M-i> <Plug>(coc-implementation)
nmap <silent> <M-f> <Plug>(coc-references)
nmap <silent> <M-r> <Plug>(coc-rename)

nmap <silent> <M-s> <Plug>(coc-range-select)
vmap <silent> <M-s> <Plug>(coc-range-select)

nmap <silent> <M-S> <Plug>(coc-range-select-backward)
vmap <silent> <M-S> <Plug>(coc-range-select-backward)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <silent> <M-x> :CocCommand<CR>


" EasyAlign 
" Start in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" use ripgrep to find in project
set grepprg=rg\ -S\ --vimgrep
autocmd QuickFixCmdPost *grep* cwindow
nnoremap <leader>gg :silent! grep <C-R><C-W>

" fzf configuration
let $FZF_DEFAULT_COMMAND = 'fd -t f -H'
let $FZF_DEFAULT_OPTS = '--border --reverse --inline-info'
let g:fzf_layout = { 'window': 'FzfFloatingCenteredWindow' }
let g:fzf_buffers_jump = 1
nnoremap <silent> <leader><leader> :Files<CR>
nnoremap <M-l> :Lines <C-R><C-w><CR>

" refine quickfix results
command! RefineQuickfix call fzf#run({
      \ 'source': map(getqflist(), function('<sid>qf_to_fzf')),
      \ 'down':   '20',
      \ 'sink*':   function('<sid>fzf_to_qf'),
      \ 'options': '--border sharp --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all --prompt "quickfix> "',
      \ 'window': 'FzfQuickfixFloatingWindow',
      \ })

command! FzfFloatingCenteredWindow call s:fzf_floating_window({
      \ 'width': 150,
      \ 'height': 20,
      \ 'relative': 'editor',
      \ 'anchor': 'SW',
      \ 'row': (&lines/2) + 10,
      \ 'col': (&columns/2) - 75,
      \})

" Matches the height of the quickfix window and places the floating window at
" the bottom of the screen.
" The idea is to make it look like the quickfix window itself is being edited
command! FzfQuickfixFloatingWindow call s:fzf_floating_window({
      \ 'height': min([20, len(getqflist())]) + 1,
      \ 'width': &columns,
      \ 'relative': 'editor',
      \ 'anchor': 'SW',
      \ 'row': &lines,
      \ 'col': 0,
      \})

command! -nargs=* Find call fzf#run({
\ 'source':  printf('rg -a --vimgrep --color always "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110 -x',
\ 'sink*': function('<sid>rg_handler'),
\ 'down':    '50%',
\ })

" Find string inside the CWD
nnoremap <leader>p/ :silent! Find <C-R><C-W><CR>
vnoremap <leader>p/ y:silent Find <C-R>"<CR>

" helpers

" auto-adjust window height to a max of N lines
function! AdjustWindowHeight(minheight, ...)
    exe max([min([line("$"), (a:0 >= 1) ? a:1 : a:minheight]), a:minheight]) . "wincmd _"
endfunction
augroup WindowSizing
  au!
  au FileType qf       call AdjustWindowHeight(1,  20)
augroup END

function! s:rg_handler(lines)
  if len(a:lines) < 2 | return | endif
  let cmd = get({ 'ctrl-x': 'split'
                \,'ctrl-v': 'vertical split'
                \,'ctrl-t': 'tabe'
                \ } , a:lines[0], 'e' )
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')
  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'
  if len(list) > 1
    call setqflist(list)
    copen
  endif
endfunction

function! s:qf_to_fzf(key, line) abort
  let l:filepath = expand('#' . a:line.bufnr . ':p')
  return l:filepath . ':' . a:line.lnum . ':' . a:line.col . ':' . a:line.text
endfunction

function! s:fzf_to_qf(filtered_list) abort
  let list = map(a:filtered_list, 's:ag_to_qf(v:val)')
  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

" ({ 'width': number,
"    'height': number,
"    'message': array<string>,
"    'relative': 'editor' | 'cursor',
"    'anchor': 'NW' | 'NE' | 'SW' | 'SE',
"    'enter': 0 | 1,
"    'border': 'rounded' | 'sharp' | 'horizontal' | 'vertical' | 'top' | 'bottom' | 'left' | 'right',
"    'centered': boolean }) -> window_id
function! s:fzf_floating_window(opts) abort
  let l:buff = nvim_create_buf(v:false, v:true)

  let l:message = get(a:opts, 'message', [])

  " Window size
  " TODO: get the width from the longest line in l:message
  let l:width = get(a:opts, 'width', 150)
  let l:height = max([get(a:opts, 'height', 1), len(l:message)])

  let l:col = get(a:opts, 'col', 1)
  let l:row = get(a:opts, 'row', 0)
  let l:anchor = get(a:opts, 'anchor', 'SW')
  let l:relative = get(a:opts, 'relative', 'cursor')

  let l:win_opts = {
        \ 'relative': l:relative,
        \ 'anchor': l:anchor,
        \ 'col': l:col,
        \ 'row': l:row,
        \ 'width': l:width,
        \ 'height': l:height,
        \ 'style': 'minimal'
        \ }

  let l:enter = get(a:opts, 'enter', 0)

  if len(l:message) > 0
    call nvim_buf_set_lines(l:buff, 0, -1, v:true, l:message)
  else
    " force the enter option if we're operating on the current buffer
    let l:enter = 1
  endif

  " Window position
  if get(a:opts, 'centered', v:false)
    let l:win_opts.relative = 'editor'
    let l:win_opts.anchor = 'NW'
    let l:win_opts.col = (&columns/2) - (l:width/2)
    let l:win_opts.row = (&lines/2) - (l:height/2)
  endif

  " Window id
  let l:win_id = nvim_open_win(l:buff, l:enter, l:win_opts)


  doautocmd User FloatingWindowEnter

  return l:win_id
endfunction

function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return { 'filename': parts[0],
         \ 'lnum': parts[1],
         \ 'col': parts[2],
         \ 'text': join(parts[3:], ':')
         \ }
endfunction

let g:vimwiki_list = [{'path': '~/Documents/vimwiki',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

let g:vimwiki_folding='syntax'
let g:switch_mapping='!'
