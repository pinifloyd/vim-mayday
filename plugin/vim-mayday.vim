" ============================================================================
" File:        vim-mayday.vim
" Description: Run rspec in ConqueTerm using colorized output
" Maintainer:  Sergey Hanchar <hanchar.sergey@gmail.com>
" Last Change: August 30, 2013
" Version:     0.0.1
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
" OPTIONS SECTION
" ============================================================================
"
" By default uses 'rspec' if you have rspec2 installed, or 'spec' for 'rspec1'.
" You can override this by setting up your .vimrc like this:
"
"   let g:spec_runner_command='spec'
"
function! GetSpecRunnerCommand()
  if !exists('g:spec_runner_command')
    let g:spec_runner_command = SetDefaultSpecRunnerCommand()
  endif

  return g:spec_runner_command
endfunction

function! SetDefaultSpecRunnerCommand()
    let l:commands = [
      \ 'rspec', 'bundle exec rspec',
      \ 'spec',  'bundle exec spec' ]

    for l:command in l:commands
      if executable(l:command)
        return l:command
      endif
    endfor
endfunction

" By default uses '--color' spec option. You can override this by setting up your
" .vimrc like this:
"
"   let g:spec_runner_options=' --color'
"
function! GetSpecRunnerOptions()
  if !exists('g:spec_runner_options')
    let g:spec_runner_options = ' --color'
  endif

  return g:spec_runner_options
endfunction

function! GetMessageBufferOptions(key)
  call SetDefaultMessageBufferOptions()
  return g:message_buffer_options[a:key]
endfunction

function! SetDefaultMessageBufferOptions()
  let g:message_buffer_options = {
    \ 'current':  [],
    \ 'split':    ['split'],
    \ 'vertical': ['vertical'],
    \ 'tab':      ['tabnew'] }
endfunction
" botright   split
" botright   vsplit
" belowright split
" belowright vsplit
" split
" vsplit

" ============================================================================
" MESSAGE BUFFER SECTION
" ============================================================================
"
" Clear log buffer prior to running the next one.
"
function! ShowMessageBuffer(command, position)
  call CloseMessageBuffer()
  call OpenMessageBuffer(a:command, a:position)
endfunction

function! CloseMessageBuffer()
  if(exists('g:message_buffer'))
    call g:message_buffer.close()
    call DeleteMessageBuffer()
  endif
endfunction

function! DeleteMessageBuffer()
  exec 'bdelete ' . g:message_buffer.buffer_name
endfunction

function! OpenMessageBuffer(command, position)
  let g:message_buffer = conque_term#open(a:command, GetMessageBufferOptions(a:position))
endfunction

" ============================================================================
" FULL SPEC RUNNER COMMAND SECTION
" ============================================================================
"
function! RunSpecFileCommand()
  return GetSpecRunnerCommand() . " " . bufname('%') . GetSpecRunnerOptions()
endfunction

" ============================================================================
" FUNCTION DEFINITION SECTION
" ============================================================================
"
function! RunSpecFile(position)
  call ShowMessageBuffer(RunSpecFileCommand(), a:position)
endfunction

" ============================================================================
" COMMAND DEFINITION SECTION
" ============================================================================
"
command! -nargs=* RunSpecFile call RunSpecFile(<args>)

" ============================================================================
" MAPS SECTION
" ============================================================================
"
nmap <silent> <leader>rf  :RunSpecFile 'current'<cr>
nmap <silent> <leader>rfs :RunSpecFile 'split'<cr>
nmap <silent> <leader>rfv :RunSpecFile 'vertical'<cr>
nmap <silent> <leader>rft :RunSpecFile 'tab'<cr>

" botright/belowright/nil
" rl  (run line current)
" rls (run line split)
" rlv (run line vertical)
" rlt (run line tab)
" ra  (run all  current)
" ras (run all  split)
" rav (run all  vertical)
" rat (run all  tab
" , ['belowright split', 'res 20'])
" command! -nargs=* PutBlah call PutBlah(<args>)
" map <silent> <leader>rf :PutBlah 'split'<cr>
