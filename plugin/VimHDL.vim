if exists("g:loaded_vimhdl")
    echom "loaded"
    finish
endif
let g:loaded_vimhdl = 1

" Commands
command! -range VimHDLIndent <line1>,<line2>call VimHDL#indent()

" Mappings
vnoremap <silent> <plug>(VimHDLIndent) :VimHDLIndent<cr>
nnoremap <silent> <plug>(VimHDLIndent) :VimHDLIndent<cr>
