let s:save_cpo = &cpo
set cpo&vim

call unite#taskwarrior#init()

let s:parent = unite#sources#file#get_file_source()

let s:source = {
      \ 'name': 'taskwarrior/notes',
      \ 'description': 'get a listing of all note files',
      \ 'default_kind': 'file',
      \ 'action_table': {},
      \ 'hooks': {}
      \ }

function! s:source.gather_candidates(args, context)
  let candidates = []
  let filt = unite#taskwarrior#filters#from_source(a:args, a:context)

  for file in unite#taskwarrior#notes#select(filt.str())
    call add(candidates, {
          \ 'word': file.preview,
          \ 'source__data': file,
          \ 'action__path': file.path,
          \ 'is_multiline': 1,
          \ })
    unlet file
  endfor

  return candidates
endfunction

function! s:source.hooks.on_syntax(args, context) abort
  if unite#taskwarrior#config('define_mappings') == 0
    return
  endif

  call unite#taskwarrior#base_mappings() 
endfunction

let s:source.action_table.view = {'description': 'show the associated task'}
function! s:source.action_table.view.func(candidate) abort
  let uuid = a:candidate.source__data.uuid
  echo unite#taskwarrior#call([uuid, 'information'])
endfunction

function! unite#sources#taskwarrior_notes#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
