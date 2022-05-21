" setting
" use UTF-8 character set
set fenc=utf-8
" do Not create backup files
set nobackup
" do Not create swap files
set noswapfile
" re-read a file being edited automatically while the file was changed
set autoread
" enable to open files while a buffer has been edited
set hidden
" show the running command in the status
set showcmd


" spacemacs-like keybind
let mapleader = "\<Space>"
inoremap fd <Esc>
vnoremap fd <Esc>
nnoremap fd <Esc>
map <leader>fs :w!<cr>
map <leader>qq :q!<cr>


" view
" show row numbers
set number
" emphasize a current row
set cursorline
" enable the cursor to move the next of end-of-line
set virtualedit=onemore
" use smartindent
set smartindent
" show corresponding parenthesis
set showmatch
" show status line always
set laststatus=2
" autocomplete command
set wildmode=list:longest
" enable to move by lines as seen
nnoremap j gj
nnoremap k gk


" tabs
" visualize invisible character(tab is expressed by ▸-)
set list listchars=tab:\▸\-
" use spaces instead of tabs
set expandtab
" indent by the number of 'shiftwidth' when typing Tab at the beginning of the line
set smarttab
" tabstop
set tabstop=4
" tabstop at top-of-line
set shiftwidth=4


" search
" ignore cases
set ignorecase
" not ignore cases when captal letters is included 
set smartcase
" incremental search
set incsearch
" return to the first result after the last
set wrapscan
" highlight search results
set hlsearch
