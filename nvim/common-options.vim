set expandtab
set tabstop=4
set shiftwidth=4
set textwidth=80
set formatoptions=oqnj
set conceallevel=2
set splitright
set foldlevelstart=99

autocmd FileType rst setlocal formatoptions=oqnj

autocmd FileType javascript
	\ setlocal ts=2 sw=2

autocmd FileType mail
	\ setlocal tw=72

autocmd FileType python
	\ setlocal foldnestmax=2 foldmethod=indent
