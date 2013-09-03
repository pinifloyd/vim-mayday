Run your spec inside vim.
============

 * Colorized RSpec output in vim using ConqueTerm
 * Sensible keybindings (feel free to change), all prefixed with 'r':

```vim
nmap <silent> <leader>rf  :RunSpecFile 'current'<cr>
nmap <silent> <leader>rfs :RunSpecFile 'split'<cr>
nmap <silent> <leader>rfv :RunSpecFile 'vsplit'<cr>
nmap <silent> <leader>rft :RunSpecFile 'tab'<cr>
nmap <silent> <leader>rl  :RunSpecLine 'current'<cr>
nmap <silent> <leader>rls :RunSpecLine 'split'<cr>
nmap <silent> <leader>rlv :RunSpecLine 'vsplit'<cr>
nmap <silent> <leader>rlt :RunSpecLine 'tab'<cr>
nmap <silent> <leader>ra  :RunSpecAll  'current'<cr>
nmap <silent> <leader>ras :RunSpecAll  'split'<cr>
nmap <silent> <leader>rav :RunSpecAll  'vsplit'<cr>
nmap <silent> <leader>rat :RunSpecAll  'tab'<cr>
nmap <silent> <leader>rlc :RunLastSpecCommand<cr>
```

Requires
--------------

 * http://code.google.com/p/conque/
 * https://github.com/basepi/vim-conque

Installation
--------------

 * Copy ```plugin/*``` to ```~/.vim/plugin```
 * If using pathogen, copy the whole directroy to ```~/.vim/bundle```

Configuration
--------------

By default uses 'rspec' if you have rspec2 installed, or 'spec' for 'rspec1'.
You can override this by setting up your .vimrc like this:

    let g:spec_runner_command='spec'

By default uses only '--color' spec option. If you need more you can override
this by setting up your .vimrc like this:

    let g:spec_runner_options = ' --color'

By default uses ```'botright split'``` and ```'botright vsplit'``` settings 
for positioning message buffer but of course you can override this and create
your own by setting up your .vimrc like this:

    let g:spec_message_buffer_positions = {
      \ 'split' : ['topleft split'],
      \ 'myown' : ['belowright split'] }

By default uses ```'res 20'``` (for split) settings for resize message buffer
but of course you can override this and set your own sizes by setting up
your .vimrc like this:

    let g:spec_message_buffer_sizes = {
      \ 'split' : [],
      \ 'myown' : ['res 10'] }

If you have the same default settings, you will get this:

    'current' : []
    'split'   : ['botright split', 'res 20']
    'vsplit'  : ['botright vsplit']
    'tab'     : ['tabnew']

It may differ because you may have other settings in your .vimrc.  And of course
you can set up your own options by putting something like this in your .vimrc:

    let g:spec_message_buffer_options ={
      \ 'split' : ['split', 'res 30'],
      \ 'myown' : [] }
