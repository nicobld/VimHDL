" Local functions

function! s:EqualizeIndent(first_line, last_line)
    let l:firstline = getline(a:first_line)
    let indent_str = matchstr(l:firstline, '^\s\+')

    for lnum in range(a:first_line + 1, a:last_line)
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
    " first equalize line indenting to the first line
    call s:EqualizeIndent(a:firstline, a:lastline)

    let delim = matchstr(getline(a:firstline), ':\|<\|=')

    " no delim found
    " TODO maybe try the next lines
    if delim ==# ""
        return
    endif

    " will contain every valid line
    let lineList = []

    " find the biggest line from its begining to delim
    let maxval = 0
    let maxline = a:firstline
    for lnum in range(a:firstline, a:lastline)
        " check that the line is valid
        if matchstr(getline(lnum), delim) ==# ""
            continue
        else
            call add(lineList, lnum)
        endif

        let splitcolumn = substitute(split(getline(lnum), delim)[0], '\s\+$', "", "")
        let length = len(splitcolumn)
        if length > maxval
            let maxline = lnum
            let maxval = length
        endif
    endfor

    " write one tab before the delimiter
    execute maxline . "normal! 0f" . delim . "beldt" . delim
    execute maxline . "normal! 0f" . delim . "i\<tab>"

    let biggestLineLen = s:ColumnLineLen(maxline, delim)

    for lnum in lineList
        " don't change the biggest reference line
        if lnum == l:maxline
            continue
        endif
        " remove trailing spaces before delimiter
        execute lnum . "normal! 0f" . delim . "beldt" . delim
        let linelen = s:ColumnLineLen(lnum, delim)
        " add tabs until the line is the same size as the reference one
        while linelen < biggestLineLen
            execute lnum . "normal! 0f" . delim . "i\<tab>"
            let linelen = s:ColumnLineLen(lnum, delim)
        endwhile
    endfor

endfunction
