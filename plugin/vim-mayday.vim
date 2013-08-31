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
" DEFAULTS SECTION
" ============================================================================
"
function! DefaultSpecRunners()
    return [
      \ 'rspec', 'bundle exec rspec',
      \ 'spec',  'bundle exec spec' ]
endfunction

function! DefaultSpecMessageBufferPositions()
  return {
    \ 'current' : [],
    \ 'split'   : ['botright split'],
    \ 'vsplit'  : ['botright vsplit'],
    \ 'tab'     : ['tabnew'] }
endfunction

function! DefaultSpecMessageBufferSizes()
  return {
    \ 'current' : [],
    \ 'split'   : ['res 20'],
    \ 'vsplit'  : [],
    \ 'tab'     : [] }
endfunction

function! DefaultSpecMessageBufferOptions()
  let l:positions = GetSpecMessageBufferPositions()
  let l:sizes     = GetSpecMessageBufferSizes()
  let l:options   = {}

  for l:key in keys(l:positions)
    call extend(l:options, {l:key : l:positions[l:key] + l:sizes[l:key]})
  endfor
  return l:options
endfunction

" ============================================================================
" GETTERS SECTION
" ============================================================================
"
function! GetSpecRunnerCommand()
  return g:spec_runner_command
endfunction

function! GetSpecRunnerOptions()
  return g:spec_runner_options
endfunction

function! GetSpecMessageBufferPositions()
  return g:spec_message_buffer_positions
endfunction

function! GetSpecMessageBufferSizes()
  return g:spec_message_buffer_sizes
endfunction

function! GetSpecMessageBufferOption(option)
  return g:spec_message_buffer_options[a:option]
endfunction

" ============================================================================
" SETTERS SECTION
" ============================================================================
"
" By default uses 'rspec' if you have rspec2 installed, or 'spec' for 'rspec1'.
" You can override this by setting up your .vimrc like this:
"
"   let g:spec_runner_command='spec'
"
function! SetDefaultSpecRunnerCommand()
  if !exists('g:spec_runner_command')
    for l:command in DefaultSpecRunners()
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
function! SetSpecRunnerOptions()
  if !exists('g:spec_runner_options')
    let g:spec_runner_options = ' --color'
  endif
endfunction
call SetSpecRunnerOptions()

function! SetSpecMessageBufferPositions()
  if exists('g:spec_mesage_buffer_positions')
    call extend(g:spec_message_buffer_positions, DefaultSpecMessageBufferPositions())
  else
    let g:spec_message_buffer_positions = DefaultSpecMessageBufferPositions()
  endif
endfunction
call SetSpecMessageBufferPositions()

function! SetSpecMessageBufferSizes()
  if exists('g:spec_message_buffer_sizes')
    call extend(g:spec_message_buffer_sizes, DefaultMessageBufferSizes())
  else
    let g:spec_message_buffer_sizes = DefaultSpecMessageBufferSizes()
  endif
endfunction
call SetSpecMessageBufferSizes()

function! SetSpecMessageBufferOptions()
  if exists('g:spec_message_buffer_options')
    call extend(g:spec_message_buffer_options, DefaultSpecMessageBufferOptions())
  else
    let g:spec_message_buffer_options = DefaultSpecMessageBufferOptions()
  endif
endfunction
call SetSpecMessageBufferOptions()

" ============================================================================
" MESSAGE BUFFER SECTION
" ============================================================================
"
" Clear log buffer prior to running the next one.
"
function! CloseSpecMessageBuffer()
  if(exists('g:spec_message_buffer'))
    call g:spec_message_buffer.close()
    call DeleteSpecMessageBuffer()
  endif
endfunction

function! DeleteSpecMessageBuffer()
  exec 'bdelete '.g:spec_message_buffer.buffer_name
endfunction

function! OpenSpecMessageBuffer(command, option)
  let g:spec_message_buffer = conque_term#open(a:command, a:option)
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
function! RunSpecFile(option)
  call CloseSpecMessageBuffer()
  call OpenSpecMessageBuffer(RunSpecFileCommand(), GetSpecMessageBufferOption(a:option))
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
" rls (run last spec)
