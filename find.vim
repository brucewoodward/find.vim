" Vim plugin to find files and buffers similar to textmate.
" Last Change:	2007 Jun 22
" Maintainer:	Bruce Woodward <bruce.woodward@gmail.com>
" License:	Same license as vim
"


" If there are a lot of files or subdirectories this code may take some
" time to finish. As vim searches subdirectories and files the user
" will not be able to type anything, vim will appear slow and the user
" experience will be poor.
" Use with caution.

" This code couldn't be compatible.
if exists("g:file_finder") || &cp
  finish
endif

" If g:file_finder is set to 0 the :Find command will only look at the
" names of buffers. Set g:file_finder to 0 if there are a lot directories
" or files in the current directory, or if you hate this plugin.
let g:file_finder = 1

" s:List_buffers
" Return a list of the file names of all the current listed buffers.
"
function! s:List_buffers()
  let buffer_names = []
  for i in range(1, bufnr('$'))
    if (bufexists(i) && buflisted(i))
      call extend(buffer_names, [ bufname(i) ])
    endif
  endfor
  return buffer_names
endfunc

" s:Fd_Finder
" Find ArgLead in the list of file name of the currently loaded buffers
" and then all directories before the current.
"
function! s:Fd_Finder(ArgLead, CmdLine, CursorPos)
  if a:ArgLead == ""
    return []
  endif
  let files = []
  " Search through the currently loaded buffers first.
  for buffer in s:List_buffers()
    if buffer =~ a:ArgLead 
      call extend(files, [ buffer ])
    endif
  endfor
  " Short circuit at the user's request.
  if g:file_finder == 0 
    return files
  end
  " Hash buffer names.
  let buffer_names_hash = {}
  for file in files
    let buffer_names_hash[file] = 1
  endfor
  let matching = "**/*".a:ArgLead."*"
  let possible_files = expand(matching)
  " if matching doesn't expand into anything then matching will equal
  " possible_files, i.e. expand returns the pattern if nothing matches.
  if possible_files != matching
    for file in split(possible_files,"\n")
      " add file to the files list if the file isn't already loaded
      if !has_key(buffer_names_hash, file)
        call extend(files, [ file ])
      endif
    endfor
  endif
  " remove the buffers from the list of possible files.
  return files
endfunc

" s:Fd_Finding
" Input: filename
" If the filename is already loaded then use :b to switch 
" but if not, then :edit filename.
function! s:Fd_Finding(filename)
  let buffers = s:List_buffers()
  let use_buffer = 0
  " search for filename in existing buffers
  for buffer in buffers
    if buffer == a:filename
      let use_buffer = 1
      break
    endif
  endfor
  if use_buffer 
    execute "b " . a:filename
  else
    execute "edit " . a:filename
  endif
endfunc

command! -nargs=1 -complete=customlist,s:Fd_Finder Find call s:Fd_Finding(<q-args>)
