""
" @section lang#rust, layers-lang-rust
" @parentsection layers
" `lang#rust` layers provides rust programming language support for SpaceVim.
" This layers includes syntax highlighting, code runner, REPL for rust.
"
" @subsection Layer options
" 
" The following layer options are supported when loading this layer:
"
" 1. `recommended_style`: `true`/`false` (Enable/Disable) recommended code
" style for rust. This option is disabled by default.
" 2. `format_on_save`: `true`/`false` (Enable/Disable) format current buffer
" after save. This option is disabled by default.
" 3. `racer_cmd`: The path of `racer` binary. This option is `racer` by
" default.
" 4. `rustfmt_command`: The path of `rustfmt` binary. This option is `rustfmt`
" by default.
"
" @subsection Mappings
" >
"   Key         Function
"   -----------------------------------------------
"   g d         rust-definition
"   SPC l d     rust-doc
"   SPC l r     run current file
"   SPC l e     rls-rename-symbol
"   SPC l u     rls-show-references
"   SPC l c b   cargo-build
"   SPC l c c   cargo-clean
"   SPC l c f   cargo-fmt
"   SPC l c t   cargo-test
"   SPC l c u   cargo-update
"   SPC l c B   cargo-bench
"   SPC l c D   cargo-docs
"   SPC l c r   cargo-run
"   SPC l c l   cargo-clippy
" <
"
" This layer also provides REPL support for rust, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"
" If the lsp layer is enabled for python, the following key bindings can
" be used:
" >
"   key binding     Description
"   g D             jump to type definition
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l h         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <

if exists('s:rustfmt_command')
  finish
else
  let s:recommended_style = 0
  let s:format_on_save = 0
  let s:rustfmt_command = 'rustfmt'
endif

function! SpaceVim#layers#lang#rust#plugins() abort
  let plugins = []
  call add(plugins, ['rust-lang/rust.vim'])
  return plugins
endfunction

function! SpaceVim#layers#lang#rust#config() abort
  call SpaceVim#plugins#runner#reg_runner('rust', [
        \ 'rustc %s -o #TEMP#',
        \ '#TEMP#'])
  call SpaceVim#plugins#repl#reg('rust', 'evcxr')

  let g:rust_recommended_style = s:recommended_style
  let g:rustfmt_command = s:rustfmt_command
  let g:rustfmt_autosave = s:format_on_save

  call SpaceVim#mapping#space#regesit_lang_mappings('rust', function('s:language_specified_mappings'))
  call add(g:spacevim_project_rooter_patterns, 'Cargo.toml')

  if SpaceVim#layers#lsp#check_filetype('rust')
    call SpaceVim#mapping#gd#add('rust', function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('rust', function('s:gotodef'))
  endif
endfunction

function! SpaceVim#layers#lang#rust#set_variable(var) abort
  let s:recommended_style = get(a:var, 'recommended_style', s:recommended_style)
  let s:format_on_save = get(a:var, 'format_on_save', s:format_on_save)
  let s:rustfmt_command = get(a:var, 'rustfmt_command', s:rustfmt_command)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.c = {'name' : '+Cargo'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'r'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo run"])',
        \ 'cargo-run', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'b'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo build"])',
        \ 'cargo-build', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'c'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo clean"])',
        \ 'cargo-clean', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo test"])',
        \ 'cargo-test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'l'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo clippy"])',
        \ 'cargo-clippy', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'u'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo update"])',
        \ 'update-external-dependencies', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'B'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo bench"])',
        \ 'run the benchmarks', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'D'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo doc"])',
        \ 'build-docs', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'f'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo fmt"])',
        \ 'format project files', 1)

  if SpaceVim#layers#lsp#check_filetype('rust')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<Cr>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'h'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call SpaceVim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call SpaceVim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call SpaceVim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)
  else
    nmap <silent><buffer> K <Plug>(rust-doc)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'd'],
          \ '<Plug>(rust-doc)', 'show documentation', 1)
    " change it to SPC l g and SPC l v, just same as s g and s v
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g'],
          \ '<Plug>(rust-def-split)', 'rust-def-split', 0)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'v'],
          \ '<Plug>(rust-def-vertical)', 'rust-def-vertical', 0)

  endif
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("rust")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction

function! s:gotodef() abort
  try
    call racer#GoToDefinition()
  catch
    exec 'normal! gd'
  endtry
endfunction

function! s:execCMD(cmd) abort
  call SpaceVim#plugins#runner#open(a:cmd)
endfunction

function! SpaceVim#layers#lang#rust#health() abort
  call SpaceVim#layers#lang#rust#plugins()
  call SpaceVim#layers#lang#rust#config()
  return 1
endfunction