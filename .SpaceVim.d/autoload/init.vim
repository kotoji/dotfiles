function! init#before() abort
  set clipboard+=unnamedplus

  inoremap fd <esc>
  vnoremap fd <esc>
  nnoremap fd <esc>
endf
function! init#after() abort
  call s:coc_config()
endf

function! s:coc_config() abort
  " Directory where coc-settings.json is
  let g:coc_config_home = '~/.SpaceVim.d'

  " Extensions that will be installed automatically if not exist 
  let g:coc_global_extensions = [
    \'coc-highlight',
    \'coc-metals', 
  \]

  " Remap for do action format
  nnoremap <silent> F :call CocAction('format')<CR>

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endf
endf
