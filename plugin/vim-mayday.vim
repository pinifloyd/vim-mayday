" ============================================================================
" File:        vim-mayday.vim
" Description: Run rspec in ConqueTerm using colorized output
" Maintainer:  Sergey Hanchar <hanchar.sergey@gmail.com>
" Last Change: August 30, 2013
" Version:     0.0.2
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
" OPTIONS SECTION
" ============================================================================

function! GetSpecRunnerCommand()
  return g:spec_runner_command
endfunction

function! GetSpecRunnerOptions()
  return g:spec_runner_options
endfunction

function! GetMessageBufferOptions(key)
  return g:message_buffer_options[a:key]
endfunction

" By default uses 'rspec' if you have rspec2 installed, or 'spec' for 'rspec1'.
" You can override this by setting up your .vimrc like this:
"
"   let g:spec_runner_command='spec'
"
function! SetDefaultSpecRunnerCommand()
  if !exists('g:spec_runner_command')
    let l:commands = [
      \ 'rspec', 'bundle exec rspec',
      \ 'spec',  'bundle exec spec' ]

    for l:command in l:commands
      if executable(l:command)
        let g:spec_runner_command = l:command
        break
      endif
    endfor
  endif
endfunction
call SetDefaultSpecRunnerCommand()

" By default uses '--color' spec option. You can override this by setting up your
" .vimrc like this:
"
"   let g:spec_runner_options=' --color'
"
function! SetDefaultSpecRunnerOptions()
  if !exists('g:spec_runner_options')
    let g:spec_runner_options = ' --color'
  endif
endfunction
call SetDefaultSpecRunnerOptions()

" TODO: write somthing helpfull
"
function! SetDefaultMessageBufferOptions()
  " , ['belowright split', 'res 20'])
  let g:message_buffer_options = {
    \ 'current': [],
    \ 'split':   ['botright split'],
    \ 'vsplit':  ['botright vsplit'],
    \ 'tab':     ['tabnew'] }
endfunction
call SetDefaultMessageBufferOptions()

" ============================================================================
" MESSAGE BUFFER SECTION
" ============================================================================
"
" Clear log buffer prior to running the next one.
"
function! ShowMessageBuffer(command, options)
  call CloseMessageBuffer()
  call OpenMessageBuffer(a:command, a:options)
endfunction

function! CloseMessageBuffer()
  if(exists('g:message_buffer'))
    call g:message_buffer.close()
    call DeleteMessageBuffer()
  endif
endfunction

function! DeleteMessageBuffer()
  exec 'bdelete '.g:message_buffer.buffer_name
endfunction

function! OpenMessageBuffer(command, options)
  let g:message_buffer = conque_term#open(a:command, a:options)
endfunction

" ============================================================================
" FULL SPEC RUNNER COMMAND SECTION
" ============================================================================
"
function! RunSpecFileCommand()
  return GetSpecRunnerCommand()." ". bufname('%').GetSpecRunnerOptions()
endfunction

" ============================================================================
" FUNCTION DEFINITION SECTION
" ============================================================================
"
function! RunSpecFile(position)
  call ShowMessageBuffer(RunSpecFileCommand(), GetMessageBufferOptions(a:position))
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
nmap <silent> <leader>rfv :RunSpecFile 'vsplit'<cr>
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
