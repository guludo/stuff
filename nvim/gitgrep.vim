" Hackish way of integrating git-grep in nvim:
"
" - We map Ctrl-Space to call git-grep on using the word under the cursor.
" - In the buffer containing the output of git-grep, "q" is mapped to return to
"   the original buffer.
" - It is possible to use this recursively, meaning that Ctrl-Space in the
"   git-grep buffer will invoke git-grep again, "stacking" another git-grep
"   buffer on top of the existing one.
"
" Available commands:
"
" - GitGrep: This is the command that is called by the Ctrl-Space mapping. The
"   arguments are passed as a single pattern to git-grep. You can call with no
"   arguments to use the word under the cursor.
"
" - GitGrepQuickfix: Similar to GitGrep, but start a quickfix with the results.

let g:GitGrepBufferInfo = {}

function GitGrep(search_str)
    let l:options = ["-W", "-n"]
    let l:search_str = a:search_str
    let l:is_cword = 0
    let l:original_buffer = bufnr()
    let l:original_search_pattern = @/

    if empty(l:search_str)
        let l:is_cword = 1
        let l:search_str = expand('<cword>')
        let l:options += ["-w", "-F"]
    endif

    if empty(l:search_str)
        echoerr "Empty search string"
        return
    endif

    let l:gitgrep_cmd = "git -P grep " .. join(l:options, " ") .. " '" .. l:search_str .. "'"

    " Let's avoid using terminal until
    " https://github.com/neovim/neovim/issues/26543 gets fixed.
    " execute "terminal " .. l:gitgrep_cmd
    enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    call setline(1, systemlist(gitgrep_cmd))

    if l:is_cword
        let l:vim_search_pattern = "\\<" .. l:search_str .. "\\>"
    else
        let l:vim_search_pattern = l:search_str
    endif
    call wait(2000, "search(\"" .. escape(l:vim_search_pattern, "\\") .. "\", \"wn\")")
    execute "normal gg/" .. l:vim_search_pattern .. "\<cr>"
    let @/ = l:vim_search_pattern

    let g:GitGrepBufferInfo[bufnr()] = {
        \ "original_buffer": l:original_buffer,
        \ "original_search_pattern": l:original_search_pattern,
        \ }

    execute "nmap <buffer> q :call GitGrepQuit()<CR>"
    nmap <buffer> <C-]> :call GitGrep("")<CR>
    nmap <buffer> <C-W><C-]> :vs<Bar>call GitGrep("")<CR>
    nmap <buffer> gf :call GitGrepGoToFile()<CR>
endfunction

function GitGrepQuit()
    let l:buffer_number = bufnr()
    let l:buffer_info = g:GitGrepBufferInfo[l:buffer_number]
    execute "b " .. l:buffer_info["original_buffer"]
    bd #
    let @/ = l:buffer_info["original_search_pattern"]
    unlet g:GitGrepBufferInfo[l:buffer_number]
endfunction

function GitGrepGoToFile()
    let l:buffer_number = bufnr()
    let l:buffer_info = g:GitGrepBufferInfo[l:buffer_number]
    let l:line = getline(".")
    let l:m = matchlist(l:line, '^\([^-:]\+\)\(-\d\+-\|:\d\+:\)')
    call GitGrepQuit()
    execute "edit " fnameescape(l:m[1])
    call cursor(slice(l:m[2], 1, -1), 0)
endfunction

function GitGrepQuickfix(search_str)
    let l:options = ["-n", "--column"]
    let l:search_str = a:search_str
    let l:is_cword = 0

    if empty(l:search_str)
        let l:is_cword = 1
        let l:search_str = expand('<cword>')
        let l:options += ["-w", "-F"]
    endif

    if empty(l:search_str)
        echoerr "Empty search string"
        return
    endif

    let l:gitgrep_cmd = "git -P grep " .. join(l:options, " ") .. " '" .. l:search_str .. "'"

    call setqflist([], ' ', {'lines': systemlist(gitgrep_cmd)})
    copen
    cfirst
endfunction

command -nargs=* GitGrep :call GitGrep('<args>')
command -nargs=* GitGrepQuickfix :call GitGrepQuickfix('<args>')

nmap <C-Space> :GitGrep<CR>
nmap <C-W><C-Space> :vs<Bar>GitGrep<CR>
