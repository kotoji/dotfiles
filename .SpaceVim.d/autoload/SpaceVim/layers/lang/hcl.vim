scriptencoding utf-8

if exists('s:terraform_binary_path')
  finish
else
  let s:terraform_align = 0
  let s:terraform_binary_path = 'terraform'
  let s:terraform_fmt_on_save = 0
  let s:terraform_fold_sections = 0
  let s:hcl_align = 0
  let s:hcl_fold_sections = 0
endif

function! SpaceVim#layers#lang#hcl#plugins() abort
  let plugins = []
  call add(plugins, ['hashivim/vim-terraform'])
  return plugins
endfunction

function! SpaceVim#layers#lang#hcl#config() abort
  let g:terraform_align         = s:terraform_align
  let g:terraform_binary_path   = s:terraform_binary_path
  let g:terraform_fmt_on_save   = s:terraform_fmt_on_save
  let g:terraform_fold_sections = s:terraform_fold_sections
  let g:hcl_align               = s:hcl_align
  let g:hcl_fold_sections       = s:hcl_fold_sections
endfunction

function! SpaceVim#layers#lang#hcl#set_variable(var) abort
  let s:terraform_align         = get(a:var, 'terraform_align', s:terraform_align)
  let s:terraform_binary_path   = get(a:var, 'terraform_binary_path', s:terraform_binary_path)
  let s:terraform_fmt_on_save   = get(a:var, 'terraform_fmt_on_save', s:terraform_fmt_on_save)
  let s:terraform_fold_sections = get(a:var, 'terraform_fold_sections', s:terraform_fold_sections)
  let s:hcl_align               = get(a:var, 'hcl_align', s:hcl_align)
  let s:hcl_fold_sections       = get(a:var, 'hcl_fold_sections', s:hcl_fold_sections)
endfunction
