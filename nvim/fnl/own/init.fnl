(module own.init
  {autoload {nvim aniseed.nvim
             core aniseed.core
             package own.package}
   require [own.plugins
            own.window-mappings
            own.confirm-quit]})

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(set vim.o.cmdheight 1)
(set vim.o.cursorline true)
(set vim.o.expandtab true)
(set vim.o.grepprg "ag -S --vimgrep")
(set vim.o.guifont "Dank Mono:h11")
(set vim.o.hidden true)
(set vim.o.ignorecase true)
(set vim.o.inccommand :split)
(set vim.o.laststatus 3)
(set vim.o.list true)
(set vim.o.listchars "tab:▸ ,trail:·")
(set vim.o.mouse :a)
(set vim.o.scrolloff 0)
(set vim.o.shiftwidth 2)
(set vim.o.signcolumn :yes)
(set vim.o.smartcase true)
(set vim.o.softtabstop 2)
(set vim.o.tabstop 2)
(set vim.o.timeoutlen 500)
(set vim.o.termguicolors true)
(set vim.o.updatetime 100)
(set vim.wo.wrap false)
(set vim.o.splitright true)
(set vim.g.neovide_input_use_logo true)
(set vim.g.GuiWindowFrameless true)

(nvim.ex.hi :WinSeparator :guibg=None)
(package.setup)

(defn- os-open [url]
  (vim.fn.system (.. "xdg-open " url " || open " url)))

; I'm disabling netrw, and Fugitive needs a :Browse command
(nvim.create_user_command :Browse (fn [opts] (os-open opts.args)) {:nargs 1})
