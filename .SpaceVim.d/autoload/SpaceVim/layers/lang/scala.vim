"=============================================================================
" scala.vim --- SpaceVim lang#scala layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8


""
" @section lang#scala, layers-lang-scala
" @parentsection layers
" This layer is for Scala development.
"
" @subsection Mappings
" >
"   Sbt key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l b c     sbt continuous compile
"   normal    SPC l b C     sbt clean compile
"   normal    SPC l b r     sbt run
"   normal    SPC l b t     sbt test
"   normal    SPC l b p     sbt package
"   normal    SPC l b d     sbt show project dependencies tree
"   normal    SPC l b l     sbt reload project build definition
"   normal    SPC l b u     sbt update external dependencies
"   normal    SPC l b e     run sbt to generate .ensime config file
"
"   Execute key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l r       run main class
"
"   REPL key bindings:
"
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l s i     start a scala inferior REPL process
"   normal    SPC l s b     send buffer and keep code buffer focused
"   normal    SPC l s l     send line and keep code buffer focused
"   normal    SPC l s s     send selection text and keep code buffer focused
"
" <
"


if exists('s:scala_layer_var')
  finish
endif

let s:scala_layer_var = ''

function! SpaceVim#layers#lang#scala#plugins() abort
  let plugins = []
  call add(plugins, ['nvim-lua/plenary.nvim']) " nvim-metals requires this
  call add(plugins, ['scalameta/nvim-metals'])
  return plugins
endfunction


function! SpaceVim#layers#lang#scala#config() abort
  let g:scala_use_default_keymappings = 0
  call s:lsp_setup()
  call SpaceVim#mapping#space#regesit_lang_mappings('scala', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('scala', 'scala')
  call SpaceVim#plugins#runner#reg_runner('scala', 'sbt run')
  call add(g:spacevim_project_rooter_patterns, 'build.sbt')
  augroup SpaceVim_lang_scala
    au!
    autocmd BufRead,BufNewFile *.sbt set filetype=scala
  augroup END
endfunction


function! s:lsp_setup() abort
  "------------------------------------------------
  "-- global
  "------------------------------------------------
  lua vim.opt_global.completeopt = { "menu", "noinsert", "noselect" }
  " lua vim.opt_global.shortmess:remove("F"):append("c")
  " ↑ が動かないので代わりに↓
  set shortmess-=F
  set shortmess+=c
  "------------------------------------------------
  "-- LSP mapping
  "------------------------------------------------
  " TODO: あとでちゃんとキーマップを設定する
  " (現状は動作確認のために動きさえすればと適当に割り振っています)
  lua vim.api.nvim_set_keymap("n", "<space>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true})
  lua vim.api.nvim_set_keymap("n", "<space>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true })
  lua vim.api.nvim_set_keymap("n", "<space>lr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
  lua vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })
  lua vim.api.nvim_set_keymap("n", "<space>lls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true })
  lua vim.api.nvim_set_keymap("n", "<space>llc", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true })
  lua vim.api.nvim_set_keymap("n", "<space>llf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap = true })
  "------------------------------------------------
  "-- command
  "------------------------------------------------
  augroup lsp
    autocmd!
    autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)
  augroup END
  "------------------------------------------------
  "-- Metals Settings
  "-------------------------------------------
  lua metals_config = require("metals").bare_config()
  lua metals_config.settings = {
    \ excludedPackages = { "akka.actor.typed.javadsl" },
    \ showImplicitArguments = true,
    \ showInferredType = true,
  \ }
  " TVP
  :command TVP  lua require("metals.tvp").toggle_tree_view()
  :command TVPR lua require("metals.tvp").reveal_in_tree()
endfunction


function! s:language_specified_mappings() abort
  " code runner
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)

  " Sbt
  let g:_spacevim_mappings_space.l.b = {'name' : '+Sbt'}

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'c'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt ~compile"])',
        \ 'continuous-compile', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'C'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt clean compile"])',
        \ 'clean-compile', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt test"])',
        \ 'sbt-test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'p'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt package"])',
        \ 'sbt-package-jar', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'd'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt inspect tree compile:sources"])',
        \ 'show-dependencies-tree', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'l'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt reload"])',
        \ 'reload-build-definition', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'u'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt update"])',
        \ 'update-external-dependencies', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','b', 'r'], 'call call('
        \ . string(function('s:execCMD')) . ', ["sbt run"])',
        \ 'sbt-run', 1)

  " REPL
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("scala")',
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


function! s:execCMD(cmd) abort
  call SpaceVim#plugins#runner#open(a:cmd)
endfunction

" vim:set et sw=2 cc=80:

function! SpaceVim#layers#lang#scala#set_variable(var) abort
  let s:scala_layer_var = get(a:var, 'scala_layer_var', s:scala_layer_var)
endfunction

function! SpaceVim#layers#lang#scala#health() abort
  call SpaceVim#layers#lang#scala#plugins()
  call SpaceVim#layers#lang#scala#config()
  return 1
endfunction
