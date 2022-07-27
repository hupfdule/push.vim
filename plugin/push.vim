" Plugin folklore "{{{1
if v:version < 700 || exists('g:loaded_push')
  finish
endif
let g:loaded_push = 1

let s:cpo_save = &cpo
"}}}1

inoremap <Plug>(PushToNextWord)           <c-o>:call push#to_next(v:true,  '' )<cr>
inoremap <Plug>(PushToNextWORD)           <c-o>:call push#to_next(v:true,  'W')<cr>
nnoremap <Plug>(PushToNextWord)                :call push#to_next(v:false, '' )<cr>
nnoremap <Plug>(PushToNextWORD)                :call push#to_next(v:false, 'W')<cr>
inoremap <Plug>(PushToNextWordBelow)      <c-o>:call push#to_next(v:true,  'd' )<cr>
inoremap <Plug>(PushToNextWORDBelow)      <c-o>:call push#to_next(v:true,  'dW')<cr>
nnoremap <Plug>(PushToNextWordBelow)           :call push#to_next(v:false, 'd' )<cr>
nnoremap <Plug>(PushToNextWORDBelow)           :call push#to_next(v:false, 'dW')<cr>
inoremap <Plug>(PushFarthest)             <c-o>:call push#farthest(v:true )<cr>
nnoremap <Plug>(PushFarthest)                  :call push#farthest(v:false)<cr>
inoremap <Plug>(PushCursorBack)           <c-o>:call push#cursor('b')<cr>
inoremap <Plug>(PushCursorBACK)           <c-o>:call push#cursor('bW')<cr>
nnoremap <Plug>(PushCursorBack)                :call push#cursor('b')<cr>
nnoremap <Plug>(PushCursorBACK)                :call push#cursor('bW')<cr>
inoremap <Plug>(PushCursorBackBelow)      <c-o>:call push#cursor('db')<cr>
inoremap <Plug>(PushCursorBACKBelow)      <c-o>:call push#cursor('dbW')<cr>
nnoremap <Plug>(PushCursorBackBelow)           :call push#cursor('db')<cr>
nnoremap <Plug>(PushCursorBACKBelow)           :call push#cursor('dbW')<cr>
inoremap <Plug>(PushCursorForward)        <c-o>:call push#cursor('')<cr>
inoremap <Plug>(PushCursorFORWARD)        <c-o>:call push#cursor('W')<cr>
nnoremap <Plug>(PushCursorForward)             :call push#cursor('')<cr>
nnoremap <Plug>(PushCursorFORWARD)             :call push#cursor('W')<cr>
inoremap <Plug>(PushCursorForwardBelow)   <c-o>:call push#cursor('d')<cr>
inoremap <Plug>(PushCursorFORWARDBelow)   <c-o>:call push#cursor('dW')<cr>
nnoremap <Plug>(PushCursorForwardBelow)        :call push#cursor('d')<cr>
nnoremap <Plug>(PushCursorFORWARDBelow)        :call push#cursor('dW')<cr>

if !get(g:, 'push_no_default_mappings', 0)
  imap <Leader>w    <Plug>(PushToNextWord)
  imap <Leader>W    <Plug>(PushToNextWORD)
  nmap <Leader>w    <Plug>(PushToNextWord)
  nmap <Leader>W    <Plug>(PushToNextWORD)
  imap <Leader>dw   <Plug>(PushToNextWordBelow)
  imap <Leader>dW   <Plug>(PushToNextWORDBelow)
  nmap <Leader>dw   <Plug>(PushToNextWordBelow)
  nmap <Leader>dW   <Plug>(PushToNextWORDBelow)
  imap <Leader>e    <Plug>(PushFarthest)
  nmap <Leader>e    <Plug>(PushFarthest)
  imap <Leader>b    <Plug>(PushCursorBack)
  imap <Leader>B    <Plug>(PushCursorBACK)
  nmap <Leader>b    <Plug>(PushCursorBack)
  nmap <Leader>B    <Plug>(PushCursorBACK)
  imap <Leader>db   <Plug>(PushCursorBackBelow)
  imap <Leader>dB   <Plug>(PushCursorBACKBelow)
  nmap <Leader>db   <Plug>(PushCursorBackBelow)
  nmap <Leader>dB   <Plug>(PushCursorBACKBelow)
  imap <Leader>f    <Plug>(PushCursorForward)
  imap <Leader>F    <Plug>(PushCursorFORWARD)
  nmap <Leader>f    <Plug>(PushCursorForward)
  nmap <Leader>F    <Plug>(PushCursorFORWARD)
  imap <Leader>df   <Plug>(PushCursorForwardBelow)
  imap <Leader>dF   <Plug>(PushCursorFORWARDBelow)
  nmap <Leader>df   <Plug>(PushCursorForwardBelow)
  nmap <Leader>dF   <Plug>(PushCursorFORWARDBelow)
endif

" Prepare the short help (via vimpl/vim-pluginhelp)
autocmd VimEnter * :call s:prepare_help()
function! s:prepare_help() abort
  if exists('g:loaded_pluginhelp')
    let s:plugin_spec = {
      \ 'help_topic': 'push',
      \ 'mappings':  [
      \    {'plugmap': '<Plug>(PushToNextWord)',         'desc': 'Push to next word'},
      \    {'plugmap': '<Plug>(PushToNextWORD)',         'desc': 'Push to next WORD'},
      \    {'plugmap': '<Plug>(PushToNextWordBelow)',    'desc': 'Push to next word below'},
      \    {'plugmap': '<Plug>(PushToNextWORDBelow)',    'desc': 'Push to next WORD below'},
      \    {'plugmap': '<Plug>(PushFarthest)',           'desc': 'Push to right align'},
      \    {'plugmap': '<Plug>(PushCursorBack)',         'desc': 'Move Cursor to prev word'},
      \    {'plugmap': '<Plug>(PushCursorBACK)',         'desc': 'Move Cursor to prev WORD'},
      \    {'plugmap': '<Plug>(PushCursorBackBelow)',    'desc': 'Move Cursor to prev word below'},
      \    {'plugmap': '<Plug>(PushCursorBACKBelow)',    'desc': 'Move Cursor to prev WORD below'},
      \    {'plugmap': '<Plug>(PushCursorForward)',      'desc': 'Move Cursor to next word'},
      \    {'plugmap': '<Plug>(PushCursorFORWARD)',      'desc': 'Move Cursor to next WORD'},
      \    {'plugmap': '<Plug>(PushCursorForwardBelow)', 'desc': 'Move Cursor to next word below'},
      \    {'plugmap': '<Plug>(PushCursorFORWARDBelow)', 'desc': 'Move Cursor to next WORD below'},
      \  ],
      \ 'settings':  [
      \    {'setting': 'g:push_no_default_mappings', 'desc': 'Do not bind any default mappings'},
      \  ],
      \ }
    command PushHelp :call pluginhelp#show(s:plugin_spec)
  endif
endfunction

" Plugin folklore "{{{1
let &cpo = s:cpo_save
unlet s:cpo_save
"}}}1

" Vim Modeline " {{{2
" vim: set foldmethod=marker :
