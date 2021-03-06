push.vim
========

Introduction
------------

*push.vim* is a plugin to push text in the current line to a "push stop" in a
line above the current one (called a reference line).
Its purpose is to align text with the text in some line above (or below).

Depending on the actual function a "push stop" may either be the beginning of
a word or the end of a word in a reference line.

To find a "push stop" this plugin looks in the lines above the current one
until it finds a push stop that is further to the right than the cursor (or
the start of the current word, respectively).


Mappings
--------

All mappings exist for normal mode and insert mode. They differ slightly in
that the normal mode mappings push whole words around, while the insert mode
mappings always push from the current cursor position, even if the cursor is
inside a word (and therefore it splits the word at the cursor position).

All the mappings have support for [tpope/vim-repeat] and are therefore
repeatable with the dot command.

  - `<Plug>(PushToNextWord)`
  - `<Plug>(PushToNextWORD)`

    Push the current word (in normal mode) or the cursor (in insert mode)
    to the next push stop.

    Both mappings differ only in what they consider a 'word'.
    The first mapping considers a word to be a number of keyword-characters
    preceded by at least one non-keyword character.
    The second mapping considers a word to be a number of word-characters
    preceded by at least one whitespace character. Therefore they are in
    line with vims use of "word" and "WORD".
    See `:h word` and `:h WORD`.

    Example:

    ```
      Nunc         habeo        feugiat               albucius
      Quo     lorem                      pro
      Nibh integre eros debet dicta.
    ```

    If the cursor is on the word 'integre' at the last line, calling
    `<Plug>(PushToNext)` in normal mode aligns it with the next word in the
    line above, 'lorem'.

    ```
      Nunc         habeo        feugiat               albucius
      Quo     lorem                      pro
      Nibh    integre eros debet dicta.
    ```

    Calling it a second time aligns it with the next word in the line above,
    'pro'.

    ```
      Nunc         habeo        feugiat               albucius
      Quo     lorem                      pro
      Nibh                               integre eros debet dicta.
    ```

    Calling it a third time will align it with the next word two lines
    above, 'albucius', as the line directly above does not contain any more
    push stops.

    ```
      Nunc         habeo        feugiat               albucius
      Quo     lorem                      pro
      Nibh                                            integre eros debet dicta.
    ```

    Push to Next in normal mode:
    ![push-to-next normal mode](pushnext-n.gif)

    Push to Next in insert mode:
    ![push-to-next insert mode](pushnext-i.gif)

  - `<Plug>(PushToNextWordBelow)`
  - `<Plug>(PushToNextWORDBelow)`

    Those mappings are the same as `<Plug>(PushToNextWord)` and
    `<Plug>(PushToNextWORD)`, but push to the push stop in the lines _below_
    the current one instead of the lines above.

  - `<Plug>(PushFarthest)`

    Push the content of the line from the current word (in normal mode)
    or the cursor (in insert mode) to right align with a reference line
    above.

    Example:
    ```
      <Plug>(MyPlugMap)                                       *my-plug-map*
      <Plug>(OtherPlugMap) *other-plug-map*
    ```

    If the cursor is on the word \*other-plug-map* in the second line,
    calling `<Plug>(PushFarthest)` will push the word to right align with
    the line above.

    ```
      <Plug>(MyPlugMap)                                       *my-plug-map*
      <Plug>(OtherPlugMap)                                 *other-plug-map*
    ```

    Push Farthest:
    ![push-farthest](pushfarthest.gif)

  - `<Plug>(PushCursorBack)`
  - `<Plug>(PushCursorBACK)`
  - `<Plug>(PushCursorBackBelow)`
  - `<Plug>(PushCursorBACKBelow)`
  - `<Plug>(PushCursorForward)`
  - `<Plug>(PushCursorFORWARD)`
  - `<Plug>(PushCursorForwardBelow)`
  - `<Plug>(PushCursorFORWARDBelow)`

    Push the cursor to the corresponding push stop without doing
    modifications to the text in the buffer. The nomenclature is the same as
    for the other mappings described above. The cursor may be pushed forward
    or backward. The uppercase variants jump WORD-wise. If the mapping name
    ends in "Below", the push stop is search in the lines _below_ the
    current one instead of the lines above.

    Even though those mappings are actually motions and do not change
    anything in the buffer, they are repeatable via the dot command by
    integrating with [tpope/vim-repeat].

### Default mappings

Unless `g:push_no_default_mappings` is set to `v:true` the following
mappings will be applied (for normal mode as well as for insert mode):

|           |                                  |
|-----------|----------------------------------|
| `<Leader>w`  | `<Plug>(PushToNextWord)`         |
| `<Leader>W`  | `<Plug>(PushToNextWORD)`         |
| `<Leader>dw` | `<Plug>(PushToNextWordBelow)`    |
| `<Leader>dW` | `<Plug>(PushToNextWORDBelow)`    |
| `<Leader>e`  | `<Plug>(PushFarthest)`           |
| `<Leader>b`  | `<Plug>(PushCursorBack)`         |
| `<Leader>B`  | `<Plug>(PushCursorBACK)`         |
| `<Leader>db` | `<Plug>(PushCursorBackBelow)`    |
| `<Leader>dB` | `<Plug>(PushCursorBACKBelow)`    |
| `<Leader>f`  | `<Plug>(PushCursorForward)`      |
| `<Leader>F`  | `<Plug>(PushCursorFORWARD)`      |
| `<Leader>df` | `<Plug>(PushCursorForwardBelow)` |
| `<Leader>dF` | `<Plug>(PushCursorFORWARDBelow)` |


Commands
--------

  - `:PushHelp`

    Open a help window displaying the current key mappings and settings
    of push.vim

    This command is only available if [vimpl/vim-pluginhelp] is installed.

    If [skywind3000/vim-quickui] is available the help content will be
    shown in a popup dialog. Otherwise a normal split window will be
    used.
    The split window can be closed with either `q` or `gq`.

    Help window with `vim-quickui` (from an older version with much fewer mappings):
    ![push-help](pushhelp.png)


Settings
--------

- `g:push_no_default_mappings`

  Set to `v:true` to to avoid the default-mappings.


Complementary plugins
---------------------

  - [tpope/vim-repeat]

    To support repeating push mappings with the dot command, vim-repeat needs
    to be installed.

  - [vimpl/vim-pluginhelp]

    To display the help window, vim-quickui needs to be installed.

  - [skywind3000/vim-quickui]

    To display the help window in a floating window, vim-quickui needs to be
    installed.


License
-------

This plugin is licensed under the terms of the MIT License.

http://opensource.org/licenses/MIT


[tpope/vim-repeat]: https://github.com/tpope/vim-repeat
[vimpl/vim-pluginhelp]: https://github.com/vimpl/vim-pluginhelp
[skywind3000/vim-quickui]: https://github.com/skywind3000/vim-quickui
