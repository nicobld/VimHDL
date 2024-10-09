" Local functions

function! s:EqualizeIndent(first_line, last_line, delim)
    let l:firstline = getline(a:first_line)
    let indent_str = matchstr(l:firstline, '^\s\+')

    for lnum in range(a:first_line + 1, a:last_line)
        if matchstr(getline(lnum), a:delim) ==# ""
            continue
        endif
        execute lnum . "normal! 0d^"
        execute "normal! i" . indent_str
    endfor
endfunction

function! s:ColumnLineLen(lnum, delim)
    let s = split(getline(a:lnum), a:delim)

    if len(s) != 2
        return 0
    else
        return len(s[0])
    endif
endfunction

" Public functions

function! VimHDL#indent() range abort
    let delim = matchstr(getline(a:firstline), ':\|<\|=')

    " first equalize line indenting to the first line
    call s:EqualizeIndent(a:firstline, a:lastline, delim)

    " no delim found
    " TODO maybe try the next lines
    if delim ==# ""
        return
    endif

    " find the biggest line from its begining to delim
    let maxval = 0
    let maxline = a:firstline
    for lnum in range(a:firstline, a:lastline)
        " check that the line is valid
        if matchstr(getline(lnum), delim) ==# ""
            continue
        endif

        " split line by delim
        let splitline = split(getline(lnum), delim)
        " remove trailing spaces of first part before the delim
        let splitline[0] = substitute(splitline[0], '\s\+$', "", "")
        call setline(lnum, join(splitline, delim))
        let length = len(splitline[0])
        if length > maxval
            let maxline = lnum
            let maxval = length
        endif
    endfor

    execute maxline . "normal! 0f" . delim . "i\<tab>"
    let biggestLineLen = s:ColumnLineLen(maxline, delim)

    for lnum in range(a:firstline, a:lastline)
        " check that the line is valid
        if matchstr(getline(lnum), delim) ==# ""
            continue
        endif
        " don't change the biggest reference line
        if lnum == l:maxline
            continue
        endif
        let linelen = s:ColumnLineLen(lnum, delim)
        " add tabs until the line is the same size as the reference one
        while linelen < biggestLineLen
            execute lnum . "normal! 0f" . delim . "i\<tab>"
            let linelen = s:ColumnLineLen(lnum, delim)
        endwhile
    endfor

endfunction
