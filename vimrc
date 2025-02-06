set cindent
set list
set listchars=trail:.,tab:>-

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load a plugin and indent file for the detected file type.
filetype plugin indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Set shift width to 4 spaces.
set shiftwidth=4 smarttab
" Set tab width to 4 columns.
set tabstop=4
" Use space characters instead of tabs.
set expandtab

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=4

" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*.d,*.o

" syntax highlighting for glsl
au BufNewFile,BufRead *.comp,*.frag,*.tese,*.tesc,*.geom,*.vert,*.glsl setf glsl

" enable permanent highlight on seach
set hlsearch

" convert tabs to 4 spaces and vice versa
command Spaces :%s/	/    /g | :noh
command Tabs :%s/    /	/g | :noh

"C++ Class Generator
function! Class(ClassName)
    "==================  editing header file =====================
    let header = "".a:ClassName.".hpp"
    :execute "tabnew" header
    call append( 0,"#ifndef ".toupper(a:ClassName)."_HPP")
    call append( 1,"# define ".toupper(a:ClassName)."_HPP")
    call append( 2,"")
    call append( 3,"class ".a:ClassName." {")
    call append( 4,"	public:")
    call append( 5,"		".a:ClassName."();")
    call append( 6,"		".a:ClassName."(const ".a:ClassName." &rhs);")
    call append( 7,"		".a:ClassName."& operator = (const ".a:ClassName." &rhs);")
    call append( 8,"		~".a:ClassName."();")
    call append( 9,"	protected:")
    call append(10,"	private:")
    call append(11,"};")
    call append(12,"")
    call append(13,"#endif")
	normal dd
	normal gg
	normal j
    :execute 'write' header
   	"================== editing source file ========================
    let src = "".a:ClassName.".cpp"
    :execute "tabnew" src
    call append( 0,"#include \"".a:ClassName.".hpp\"")
    call append( 1,"")
    call append( 2,a:ClassName."::".a:ClassName."() {")
    call append( 3,"	// ctor")
    call append( 4,"}")
    call append( 5,"")
    call append( 6,a:ClassName."::".a:ClassName."(const ".a:ClassName." &rhs) {")
    call append( 7,"	*this = rhs;")
    call append( 8,"}")
    call append( 9,"")
    call append(10,a:ClassName."& ".a:ClassName."::operator=(const ".a:ClassName." &rhs) {")
    call append(11,"	if (this != &rhs) {")
    call append(12,"		// copy assignment operator")
    call append(13,"	}")
    call append(14,"	return *this;")
    call append(15,"}")
    call append(16,"")
    call append(17,a:ClassName."::~".a:ClassName."() {")
    call append(18,"	// dtor")
    call append(19,"}")
	normal dd
	normal gg
    :execute 'write' src
	normal gT
endfunction
command! -nargs=1 Class call Class(<f-args>)
