" Plugin folklore "{{{1
if v:version < 700 || exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
"}}}1

inoremap <Plug>(PushToNext)   <c-o>:call push#to_next(v:true)<cr>
nnoremap <Plug>(PushToNext)        :call push#to_next(v:false)<cr>
inoremap <Plug>(PushFarthest) <c-o>:call push#farthest(v:true)<cr>
nnoremap <Plug>(PushFarthest)      :call push#farthest(v:false)<cr>

if !get(g:, 'push_no_default_mappings', 0)
  imap <Tab>    <Plug>(PushToNext)
  nmap <Tab>    <Plug>(PushToNext)
  imap <S-Tab>  <Plug>(PushFarthest)
  nmap <S-Tab>  <Plug>(PushFarthest)
endif

command PushHelp :call push#help()

" Plugin folklore "{{{1
let &cpo = s:cpo_save
unlet s:cpo_save
"}}}1

" Vim Modeline " {{{2
" vim: set foldmethod=marker :
