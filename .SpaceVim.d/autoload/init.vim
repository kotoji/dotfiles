function! init#before() abort
  set clipboard+=unnamedplus

  inoremap fd <esc>
  vnoremap fd <esc>
  nnoremap fd <esc>
endf
function! init#after() abort
endf
