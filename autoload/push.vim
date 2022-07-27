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
"                       'd': align with the lines below (downwards) rather
"                            than with the lines above the current one.
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
    if a:search_flags =~# 'd'
      silent! call repeat#set("\<Plug>(PushToNextWORDBelow)")
    else
      silent! call repeat#set("\<Plug>(PushToNextWORD)")
    endif
  else
    if a:search_flags =~# 'd'
      silent! call repeat#set("\<Plug>(PushToNextWordBelow)")
    else
      silent! call repeat#set("\<Plug>(PushToNextWord)")
    endif
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
" Push the cursor to the next push stop without modifying the buffer.
"
" @param {search_flags} a list of search_flags. Currently supported flags:
"                       'W': search WORD-wise instead of word-wise
"                            (see :h word and :h WORD)
"                       'd': align with the lines below (downwards) rather
"                            than with the lines above the current one.
"                       'b': push backwards
function! push#cursor(search_flags) abort
  " Find the reference line above
  let l:push_cols = s:get_ref_col(a:search_flags)
  if l:push_cols !=# 0
    if a:search_flags =~# 'b'
      execute "normal! " . repeat('h', virtcol('.') - l:push_cols - 1)
    else
      execute "normal! " . repeat('l', l:push_cols + 1)
    endif
  endif

  " prepare vim-repeat
  if a:search_flags =~# 'W'
    if a:search_flags =~# 'b'
      if a:search_flags =~# 'd'
        silent! call repeat#set("\<Plug>(PushCursorBACKBelow)")
      else
        silent! call repeat#set("\<Plug>(PushCursorBACK)")
      endif
    else
      if a:search_flags =~# 'd'
        silent! call repeat#set("\<Plug>(PushCursorFORWARDBelow)")
      else
        silent! call repeat#set("\<Plug>(PushCursorFORWARD)")
      endif
    endif
  else
    if a:search_flags =~# 'b'
      if a:search_flags =~# 'd'
        silent! call repeat#set("\<Plug>(PushCursorBackBelow)")
      else
        silent! call repeat#set("\<Plug>(PushCursorBack)")
      endif
    else
      if a:search_flags =~# 'd'
        silent! call repeat#set("\<Plug>(PushCursorForwardBelow)")
      else
        silent! call repeat#set("\<Plug>(PushCursorForward)")
      endif
    endif
  endif
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
"                       'd': align with the lines below (downwards) rather
"                            than with the lines above the current one.
"                       'b': search backwards
"
" @return the number of characters to push to reach the next push stop
function! s:get_ref_col(search_flags) abort
  let l:pushcol = -1

  let l:col = virtcol('.')
  let l:reflnum = line('.')
  if a:search_flags =~# 'd'
    let l:lastline = line('$')
    while l:reflnum <= l:lastline
      let l:reflnum += 1
      let l:pushcol = s:get_push_stop(l:reflnum, l:col, a:search_flags)
      if l:pushcol !=# 0
        break
      endif
    endwhile
  else
    while l:reflnum > 0
      let l:reflnum -= 1
      let l:pushcol = s:get_push_stop(l:reflnum, l:col, a:search_flags)
      if l:pushcol !=# 0
        break
      endif
    endwhile
  endif

  return l:pushcol
endfunction


""
" Find the next push stop in the given {line}.
"
" The search starts at {start_col}.
"
" @param {lnum}         The line in which to search the next push stop.
"        {start_col}    Start the search at this column.
"        {search_flags} The search flags to use. Currently supported flags:
"                       'W': search WORD-wise instead of word-wise
"                            (see :h word and :h WORD)
"                       'b': search backwards
"
" @returns the column of the next pushstop or 0 if no further push stop was found
function! s:get_push_stop(lnum, start_col, search_flags) abort
  let l:line = getline(a:lnum)

  if l:line =~# '^\s*$'
    return 0
  endif

  if a:search_flags =~# 'b'
    let l:line_before_cursor = strcharpart(l:line, 0, a:start_col - 1)
    let l:pushcol = s:prev_push_stop(l:line_before_cursor, a:search_flags)
    return l:pushcol
  else
    let l:line_after_cursor = strcharpart(l:line, a:start_col)
    let l:pushcol = s:next_push_stop(l:line_after_cursor, a:search_flags)
    return l:pushcol
  endif
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


""
" Find the column of the previous push stop in the given line.
"
" If the {flags} contains a 'W' the search is done by 'WORD', that means a
" push stop starts after whitespace. Otherwise a push stop start after a
" non-keyword character (see :h \k).
"
" @param {line} the line in which to search for the previous push stop
" @param {flags} a list of search flags. Currently supported flags:
"                'W': search WORD-wise instead of word-wise
"                     (see :h word and :h WORD)
"
" @returns the char index of he next push stop or 0 if no push stop was found
function! s:prev_push_stop(line, flags) abort
  let l:chars = split(a:line, '\zs')

  if a:flags =~# 'W'
    let l:charpattern = '\S'
  else
    let l:charpattern = '\k'
  endif

  let l:chars_found = v:false
  for i in reverse(range(len(l:chars)))
    if l:chars[i] !~# l:charpattern
      if !l:chars_found
        continue
      else
        return i + 1
      endif
    else
      let l:chars_found = v:true
    endif
  endfor
endfunction
