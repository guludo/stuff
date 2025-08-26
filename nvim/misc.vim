" Workaround to get a prompt when resuming to nvim and the file has been
" externally modified. See https://github.com/neovim/neovim/issues/2127
set noautoread
autocmd BufEnter,FocusGained,VimResume * checktime

highlight DiffAdd cterm=none ctermfg=none ctermbg=Green
highlight DiffDelete cterm=none ctermfg=none ctermbg=Red
highlight DiffChange cterm=none ctermfg=none ctermbg=Yellow
highlight DiffText cterm=none ctermfg=none ctermbg=Magenta

highlight Folded ctermbg=none

match Error /\s\+$/
