" Plugin folklore "{{{1
if v:version < 700 || exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

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
  imap <Tab>w    <Plug>(PushToNextWord)
  imap <Tab>W    <Plug>(PushToNextWORD)
  nmap <Tab>w    <Plug>(PushToNextWord)
  nmap <Tab>W    <Plug>(PushToNextWORD)
  imap <Tab>dw   <Plug>(PushToNextWordBelow)
  imap <Tab>dW   <Plug>(PushToNextWORDBelow)
  nmap <Tab>dw   <Plug>(PushToNextWordBelow)
  nmap <Tab>dW   <Plug>(PushToNextWORDBelow)
  imap <Tab>e    <Plug>(PushFarthest)
  nmap <Tab>e    <Plug>(PushFarthest)
  imap <Tab>b    <Plug>(PushCursorBack)
  imap <Tab>B    <Plug>(PushCursorBACK)
  nmap <Tab>b    <Plug>(PushCursorBack)
  nmap <Tab>B    <Plug>(PushCursorBACK)
  imap <Tab>db   <Plug>(PushCursorBackBelow)
  imap <Tab>dB   <Plug>(PushCursorBACKBelow)
  nmap <Tab>db   <Plug>(PushCursorBackBelow)
  nmap <Tab>dB   <Plug>(PushCursorBACKBelow)
  imap <Tab>f    <Plug>(PushCursorForward)
  imap <Tab>F    <Plug>(PushCursorFORWARD)
  nmap <Tab>f    <Plug>(PushCursorForward)
  nmap <Tab>F    <Plug>(PushCursorFORWARD)
  imap <Tab>df   <Plug>(PushCursorForwardBelow)
  imap <Tab>dF   <Plug>(PushCursorFORWARDBelow)
  nmap <Tab>df   <Plug>(PushCursorForwardBelow)
  nmap <Tab>dF   <Plug>(PushCursorFORWARDBelow)
endif

command PushHelp :call push#help()

" Plugin folklore "{{{1
let &cpo = s:cpo_save
unlet s:cpo_save
"}}}1

" Vim Modeline " {{{2
" vim: set foldmethod=marker :
