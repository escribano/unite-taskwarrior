describe 'Dealing with configuration values'

  before
    call unite#taskwarrior#reset_config()
  end

  it 'can get a default value'
    Expect 'task' == unite#taskwarrior#config('command')
  end

  it 'can get a value that was set with a call'
    call unite#taskwarrior#config('command', 'run')
    Expect 'run' == unite#taskwarrior#config('command')
  end

  it 'can reset a config with reset_config'
    call unite#taskwarrior#config('command', 'other')
    call unite#taskwarrior#reset_config()
    Expect 'task' == unite#taskwarrior#config('command')
  end

  it 'can get a value that was set with a global variable'
    let g:unite_taskwarrior_command = 'bob'
    Expect 'bob' == unite#taskwarrior#config('command')
    unlet g:unite_taskwarrior_command
  end

  it 'prefers a value set by global variables over call'
    let g:unite_taskwarrior_command = 'bob'
    call unite#taskwarrior#config('command', 'run')
    Expect 'bob' == unite#taskwarrior#config('command')
    unlet g:unite_taskwarrior_command
  end

  it 'can be configured with a dictonary in a call'
    call unite#taskwarrior#config({
          \ 'command': 'something',
          \ 'note_directory': '~/.task/bob'
          \ })
    Expect 'something' == unite#taskwarrior#config('command')
  end

  it 'uses changes nothing if given empty dictonary'
    call unite#taskwarrior#config({})
    Expect 'task' == unite#taskwarrior#config('command')
  end

  it 'keeps default values that were not set'
    call unite#taskwarrior#config({
          \ 'command': 'something',
          \ 'note_directory': '~/.task/bob'
          \ })
    Expect 'mkd' == unite#taskwarrior#config('note_suffix')
  end

  it 'expands the note directory'
    call unite#taskwarrior#config('note_directory', '~/.notes')
    Expect expand('~/.notes') == unite#taskwarrior#config('note_directory')
  end
end
