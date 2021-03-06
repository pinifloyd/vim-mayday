" ============================================================================
" File:        vim-mayday.vim
" Description: Run rspec in ConqueTerm using colorized output
" Maintainer:  Sergey Hanchar <hanchar.sergey@gmail.com>
" Last Change: September 3, 2013
" Version:     0.0.4
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
" By default uses 'rspec' if you have rspec2 installed, or 'spec' for 'rspec1'.
" You can override this by setting up your .vimrc like this:
"
"   let g:spec_runner_command = 'spec'
"
function! DefaultSpecRunners()
    return [
      \ 'rspec', 'bundle exec rspec',
      \ 'spec',  'bundle exec spec' ]
endfunction

" By default uses only '--color' spec option. If you need more you can override
" this by setting up your .vimrc like this:
"
"   let g:spec_runner_options = ' --color'
"
function! DefaultSpecRunnerOptions()
  return ' --color'
endfunction

" By default uses this settings for positioning message buffer but of course you
" can override this and create your own by setting up your .vimrc like this:
"
" let g:spec_message_buffer_positions = {
"   \ 'split' : ['topleft split'],
"   \ 'myown' : ['belowright split'] }
"
function! DefaultSpecMessageBufferPositions()
  return {
    \ 'current' : [],
    \ 'split'   : ['botright split'],
    \ 'vsplit'  : ['botright vsplit'],
    \ 'tab'     : ['tabnew'] }
endfunction

" By default uses this settings for resize message buffer but of course you can
" override this and set your own sizes by setting up your .vimrc like this:
"
" let g:spec_message_buffer_sizes = {
"   \ 'split' : [],
"   \ 'myown' : ['res 10'] }
"
function! DefaultSpecMessageBufferSizes()
  return {
    \ 'current' : [],
    \ 'split'   : ['res 20'],
    \ 'vsplit'  : [],
    \ 'tab'     : [] }
endfunction

" If you have the same default settings as above, you will get this:
"
" l:options = {
"   \ 'current' : [],
"   \ 'split'   : ['botright split', 'res 20'],
"   \ 'vsplit'  : ['botright vsplit'],
"   \ 'tab'     : ['tabnew'] }
"
" It may differ because you may have other settings in your .vimrc.
" And of course you can set up your own options by putting something
" like this in your .vimrc
"
" let g:spec_message_buffer_options ={
"   \ 'split' : ['split', 'res 30'],
"   \ 'myown' : [] }
"
function! DefaultSpecMessageBufferOptions()
  let l:positions = GetSpecMessageBufferPositions()
  let l:sizes     = GetSpecMessageBufferSizes()
  let l:options   = {}

  for l:key in keys(l:positions)
    call extend(l:options, {l:key : l:positions[l:key]})
    if has_key(l:sizes, l:key)
      let l:options[l:key] += l:sizes[l:key]
    endif
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

function! GetLastSpecCommand()
  return g:last_spec_command
endfunction

function! GetLastBufferOption()
  return g:last_buffer_option
endfunction

" ============================================================================
" SETTERS SECTION
" ============================================================================
"
function! SetSpecRunnerCommand()
  if !exists('g:spec_runner_command')
    for l:command in DefaultSpecRunners()
      if executable(l:command)
        let g:spec_runner_command = l:command
        break
      endif
    endfor
  endif
endfunction
call SetSpecRunnerCommand()

function! SetSpecRunnerOptions()
  if !exists('g:spec_runner_options')
    let g:spec_runner_options
      \ = DefaultSpecRunnerOptions()
  endif
endfunction
call SetSpecRunnerOptions()

function! SetSpecMessageBufferPositions()
  if exists('g:spec_message_buffer_positions')
    let g:spec_message_buffer_positions = extend(
      \ DefaultSpecMessageBufferPositions(),
      \ g:spec_message_buffer_positions)
  else
    let g:spec_message_buffer_positions
      \ = DefaultSpecMessageBufferPositions()
  endif
endfunction
call SetSpecMessageBufferPositions()

function! SetSpecMessageBufferSizes()
  if exists('g:spec_message_buffer_sizes')
    let g:spec_message_buffer_sizes = extend(
      \ DefaultSpecMessageBufferSizes(),
      \ g:spec_message_buffer_sizes)
  else
    let g:spec_message_buffer_sizes
      \ = DefaultSpecMessageBufferSizes()
  endif
endfunction
call SetSpecMessageBufferSizes()

function! SetSpecMessageBufferOptions()
  if exists('g:spec_message_buffer_options')
    let g:spec_message_buffer_options = extend(
      \ DefaultSpecMessageBufferOptions(),
      \ g:spec_message_buffer_options)
  else
    let g:spec_message_buffer_options
      \ = DefaultSpecMessageBufferOptions()
  endif
endfunction
call SetSpecMessageBufferOptions()

function! SetLastCommandAndOption(command, option)
  let g:last_spec_command   = a:command
  let g:last_buffer_option  = a:option
endfunction

" ============================================================================
" MESSAGE BUFFER SECTION
" ============================================================================
"
" Before show new message buffer we need clear old. So, we do it here by closing
" old message buffer and terminating process.
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

function! ProcessSpecMessageBuffer(command, option)
  call CloseSpecMessageBuffer()
  call SetLastCommandAndOption(a:command, a:option)
  call OpenSpecMessageBuffer(a:command, a:option)
endfunction

" ============================================================================
" FULL SPEC RUNNER COMMAND SECTION
" ============================================================================
"
" Just mapping needed command
"
function! RunSpecFileCommand()
  return GetSpecRunnerCommand().' '.bufname('%').GetSpecRunnerOptions()
endfunction

function! RunSpecLineCommand()
  return GetSpecRunnerCommand().' '.bufname('%').' -l '.line('.').GetSpecRunnerOptions()
endfunction

function! RunSpecAllCommand()
  return GetSpecRunnerCommand().' '.'spec'.GetSpecRunnerOptions()
endfunction

" ============================================================================
" FUNCTION DEFINITION SECTION
" ============================================================================
"
function! RunSpecFile(option)
  call ProcessSpecMessageBuffer(RunSpecFileCommand(), GetSpecMessageBufferOption(a:option))
endfunction

function! RunSpecLine(option)
  call ProcessSpecMessageBuffer(RunSpecLineCommand(), GetSpecMessageBufferOption(a:option))
endfunction

function! RunSpecAll(option)
  call ProcessSpecMessageBuffer(RunSpecAllCommand(), GetSpecMessageBufferOption(a:option))
endfunction

function! RunLastSpecCommand()
  if exists('g:last_spec_command') && exists('g:last_buffer_option')
    call ProcessSpecMessageBuffer(GetLastSpecCommand(), GetLastBufferOption())
  endif
endfunction

" ============================================================================
" COMMAND DEFINITION SECTION
" ============================================================================
"
" command! -nargs=* RunSpecFile call RunSpecFile(<args>)
" command! -nargs=* RunSpecLine call RunSpecLine(<args>)
" command! -nargs=* RunSpecAll  call RunSpecAll(<args>)
" command! RunLastSpecCommand   call RunLastSpecCommand()

" ============================================================================
" MAPS SECTION
" ============================================================================
"
nmap <silent> <leader>rf  :call RunSpecFile('current')<cr>
nmap <silent> <leader>rfs :call RunSpecFile('split')<cr>
nmap <silent> <leader>rfv :call RunSpecFile('vsplit')<cr>
nmap <silent> <leader>rft :call RunSpecFile('tab')<cr>
nmap <silent> <leader>rl  :call RunSpecLine('current')<cr>
nmap <silent> <leader>rls :call RunSpecLine('split')<cr>
nmap <silent> <leader>rlv :call RunSpecLine('vsplit')<cr>
nmap <silent> <leader>rlt :call RunSpecLine('tab')<cr>
nmap <silent> <leader>ra  :call RunSpecAll('current')<cr>
nmap <silent> <leader>ras :call RunSpecAll('split')<cr>
nmap <silent> <leader>rav :call RunSpecAll('vsplit')<cr>
nmap <silent> <leader>rat :call RunSpecAll('tab')<cr>
nmap <silent> <leader>rlc :call RunLastSpecCommand()<cr>
