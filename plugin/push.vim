" Plugin folklore "{{{1
if v:version < 700 || exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
"}}}1

inoremap <Plug>(PushToNextWord)        <c-o>:call push#to_next(v:true,  '' )<cr>
inoremap <Plug>(PushToNextWORD)        <c-o>:call push#to_next(v:true,  'W')<cr>
nnoremap <Plug>(PushToNextWord)             :call push#to_next(v:false, '' )<cr>
nnoremap <Plug>(PushToNextWORD)             :call push#to_next(v:false, 'W')<cr>
inoremap <Plug>(PushToNextWordBelow)   <c-o>:call push#to_next(v:true,  'd' )<cr>
inoremap <Plug>(PushToNextWORDBelow)   <c-o>:call push#to_next(v:true,  'dW')<cr>
nnoremap <Plug>(PushToNextWordBelow)        :call push#to_next(v:false, 'd' )<cr>
nnoremap <Plug>(PushToNextWORDBelow)        :call push#to_next(v:false, 'dW')<cr>
inoremap <Plug>(PushFarthest)          <c-o>:call push#farthest(v:true )<cr>
nnoremap <Plug>(PushFarthest)               :call push#farthest(v:false)<cr>

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
endif

command PushHelp :call push#help()

" Plugin folklore "{{{1
let &cpo = s:cpo_save
unlet s:cpo_save
"}}}1

" Vim Modeline " {{{2
" vim: set foldmethod=marker :
