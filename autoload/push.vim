silent! let s:log = log#getLogger(expand('<sfile>:t'))

""
" Push the cursor or the current word to the next push stop.
"
" @param {split_words} If v:true, the cursor will be pushed to the next
"                      push stop. If the cursor is inside a word, that word
"                      will be split for that purpose.
"                      Otherwise, the word the cursor is on will be pushed.
"                      The word will remain intact and start at the next
"                      push stop.
"
" @param {search_flags} a list of search flags. Currently supported flags:
"                       'W': search WORD-wise instead of word-wise
"                            (see :h word and :h WORD)
function! push#to_next(split_words, search_flags) abort
  if !a:split_words
    let l:chars_left = s:start_of_cword()
    silent! call s:log.debug("<cword> begins " . l:chars_left . " chars to the left")
    if l:chars_left > 0
      execute "normal! " . repeat('h', l:chars_left)
    endif
  endif

  " Now find the reference line above
  let l:push_cols = s:get_ref_col(a:search_flags)
  if l:push_cols !=# 0
    execute "normal! i" . repeat(' ', l:push_cols + 1)
    execute 'normal! l'
  endif

  if !a:split_words
    if l:chars_left > 0
      execute "normal! " . repeat('l',  l:chars_left)
    endif
  endif

  if a:search_flags =~# 'W'
    silent! call repeat#set("\<Plug>(PushToNextWORD)")
  else
    silent! call repeat#set("\<Plug>(PushToNextWord)")
  endif
endfunction


""
" Push the current word as far as possible to right-align with the line above.
"
" @param {split_words} If v:true, the word will be split at the current
"                      cursor position.
"                      Otherwise, the word the cursor is on will be pushed
"                      without getting split..
function! push#farthest(split_words) abort
  if !a:split_words
    let l:chars_left = s:start_of_cword()
    silent! call s:log.debug("<cword> begins " . l:chars_left . " chars to the left")
    if l:chars_left > 0
      execute "normal! " . repeat('h', l:chars_left)
    endif
  endif

  " Now find the reference line above
  let l:push_cols = s:get_farthest_ref_col()
  if l:push_cols !=# 0
    execute "normal! i" . repeat(' ', l:push_cols)
    execute 'normal! l'
  endif

  if !a:split_words
    if l:chars_left > 0
      execute "normal! " . repeat('l',  l:chars_left)
    endif
  endif

  silent! call repeat#set("\<Plug>(PushFarthest)")
endfunction


""
" Show a short help regarding the current mappings and settings.
function! push#help() abort
  let l:a = @a

  " Find all normal mode mappings to this plugins <Plug>-Mappings
  redir @a
  silent map
  silent imap
  redir END
  let l:mappings = split(@a, "\n")
  call filter(l:mappings, 'v:val =~ "<Plug>(Push"')
  call map(l:mappings, 'split(v:val)')
  call filter(l:mappings, 'v:val[-1] =~ "<Plug>(Push"')
  "call map(l:mappings, 'v:val[1:]')
  call  sort(l:mappings, 's:compare_mappings')

  let @a = l:a

  " calculate the max length of all mappings
  let l:mappings_max_length = 0
  for m in l:mappings
    let l:mappings_max_length = max([l:mappings_max_length, len(m[1])])
  endfor

  " Prepare the help content
  let content = ['See `:help push` for more details and the hardcoded defaults.']
  call extend(content, ['', 'MAPPINGS', ''])
  for m in l:mappings
    let l:map = s:pad('*' . m[1] . '*', l:mappings_max_length + 2)
    call add(content, '  ' . m[0] . '  ' . l:map . '  ' . m[2])
  endfor
  call extend(content, ['', 'SETTINGS', ''])
  call add(content, '  *g:push_no_default_mappings* = ' . get(g:, 'push_no_default_mappings', '<unset>'))

  " Open the dialog
  let opts = {'syntax': 'help'}
  if exists('g:quickui_version')
    call quickui#textbox#open(content, opts)
  else
    call s:show_in_window(content)
  endif
endfunction


""
" Compare two lists with mapping information.
"
" Both lists must have exactly 3 items:
"
"   1. mode
"   2. {lhs}
"   3. {rhs}
"
" Comparison will compare from the last to the first item. That means first the
" {rhs} is compared, if they are equal, the {lhs} is compared and only if
" that is equal the mode will be compared.
"
" @returns - a positive integer if 'm1' is considered "after" 'm2'
"          - a negative integer if 'm1' is considered "before" 'm2'
"          - 0 if both are considered equal
function! s:compare_mappings(m1, m2) abort
  let l:result = s:compare(a:m1[2], a:m2[2])
  if l:result !=# 0
    return l:result
  endif

  let l:result = s:compare(a:m1[1], a:m2[1])
  if l:result !=# 0
    return l:result
  endif

  return s:compare(a:m1[0], a:m2[0])
endfunction


""
" Compare two values.
"
" @return -1 if the first argument is considered smaller
"          1 if the first argument is considered  larger
"          0 if both arguments are considered equal
function! s:compare(v1, v2) abort
  if a:v1 < a:v2
    return -1
  elseif a:v1 > a:v2
    return 1
  else
    return 0
  endif
endfunction


""
" Display the given lines of text in a new split window.
"
" The window will be resized to display the whole text.
" The windows will get settings for a temporary buffer and can be closed
" with either 'q' or 'gq'.
function! s:show_in_window(content) abort
  if bufexists('pushhelp')
    " if the help buffer already exists, jump to it
    let l:winnr = bufwinnr('pushhelp')
    execute l:winnr . "wincmd w"
  else
    " otherwise create the help buffer
    execute len(a:content) + 1 . 'new'
    call append(0, a:content)
    setlocal syntax=help nomodifiable nomodified buftype=nofile bufhidden=wipe nowrap nonumber
    file pushhelp
    nnoremap <buffer> q  :close<cr>
    nnoremap <buffer> gq :close<cr>
  endif
endfunction


""
" Left-pad the given 'string' to the given 'length'.
function! s:pad(string, length) abort
  return a:string . repeat(' ', a:length - len(a:string))
endfunction


""
" Calculate the column of a reference line above the current one to which to push to.
"
" This searches for all possible push stops in the lines above. The
" nearest one is preferred, but if it does not contain another push stop,
" the search goes on on the lines above it.
"
" @param {search_flags} a list of search flags. Currently supported flags:
"                       'W': search WORD-wise instead of word-wise
"                            (see :h word and :h WORD)
"
" @return the number of characters to push to reach the next push stop
function! s:get_ref_col(search_flags) abort
  let l:pushcol = -1

  let l:col = virtcol('.')
  let l:reflnum = line('.')
  while l:reflnum > 0
    let l:reflnum -= 1
    let l:refline = getline(l:reflnum)

    if l:refline =~# '^\s*$'
      continue
    endif

    let l:refline_after_cursor = strcharpart(l:refline, l:col)
    let l:pushcol = s:next_push_stop(l:refline_after_cursor, a:search_flags)
    if l:pushcol !=# 0
      break
    endif
  endwhile

  return l:pushcol
endfunction


""
" Calculate the amount of spaces necessary to right-align the current word with a reference line.
"
" This searches for all possible push stops in the lines above. The
" nearest one is preferred, but if it does not contain a push stop,
" the search goes on on the lines above it.
"
" @return the number of characters to push to right-align with the next
"         push stop
function! s:get_farthest_ref_col() abort
  let l:pushcol = -1

  let l:col = virtcol('.')
  let l:rightmost_char_at = strchars(matchstr(getline('.'), '^.\{-}\ze\s*$'))
  let l:reflnum = line('.')
  while l:reflnum > 0
    let l:reflnum -= 1
    let l:refline = getline(l:reflnum)

    let l:rightmost_ref_char_at = strchars(matchstr(l:refline, '^.\{-}\ze\s*$'))
    if l:rightmost_ref_char_at > l:rightmost_char_at
      return l:rightmost_ref_char_at - l:rightmost_char_at
    endif
  endwhile
endfunction


""
" Get the number of characters between the start of  <cword> and the cursor position.
"
" @return The number of characters between the start of <cword> and the
"         cursor position.
"         If the cursor is on the first character of the <cword> 0 is
"         returned.
"         If the cursor in not a <cword> at all, -1 is returned.
function! s:start_of_cword() abort
  let l:chars_left = strchars(matchstr(getline('.'), '\S*\ze\%'. col('.') .'c.'))
  if l:chars_left > 0
    return l:chars_left
  else
    return 0
  endif
endfunction


""
" Find the column of the next push stop in the given line.
"
" If the {flags} contains a 'W' the search is done by 'WORD', that means a
" push stop starts after whitespace. Otherwise a push stop start after a
" non-keyword character (see :h \k).
"
" @param {line} the line in which to search for the next push stop
" @param {flags} a list of search flags. Currently supported flags:
"                'W': search WORD-wise instead of word-wise
"                     (see :h word and :h WORD)
"
" @returns the char index of he next push stop or 0 if no push stop was found
function! s:next_push_stop(line, flags) abort
  let l:chars = split(a:line, '\zs')

  if a:flags =~# 'W'
    let l:charpattern = '\S'
  else
    let l:charpattern = '\k'
  endif

  let l:nonmatch_found = v:false
  for i in range(len(l:chars))
    if l:chars[i] =~# l:charpattern
      if !l:nonmatch_found
        continue
      else
        return i
      endif
    else
      let l:nonmatch_found = v:true
    endif
  endfor
endfunction
