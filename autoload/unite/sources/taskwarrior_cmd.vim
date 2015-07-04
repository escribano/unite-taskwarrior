let s:save_cpo = &cpo
set cpo&vim

call unite#taskwarrior#init()

let s:source = {
      \ 'name': 'taskwarrior/cmd',
      \ 'default_kind': 'taskwarrior_cmd'
      \ }

function! s:source.gather_candidates(args, context)
  let candidates = []
  let commands = split(unite#taskwarrior#call('', '_commands'), "\n")
  for command in commands
    call add(candidates, {
          \ 'word': command,
          \ 'source__data': command
          \ })
  endfor
  return reverse(sort(candidates))
endfunction

function! s:source.change_candidates(args, context)
  return [{"word": a:context.input}]
endfunction

function! unite#sources#taskwarrior_cmd#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
