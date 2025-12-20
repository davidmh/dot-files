(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local cfg (autoload :own.config))

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(set vim.o.conceallevel 2)
(set vim.o.cursorline false)
(set vim.o.expandtab true)
(set vim.o.foldlevel 99)
(set vim.o.grepprg "ag -S --vimgrep")
(set vim.o.guifont "Hasklug Nerd Font:h14")
(set vim.o.hidden true)
(set vim.o.ignorecase true)
(set vim.o.inccommand :split)
(set vim.o.number false)
(set vim.o.laststatus 3)
(set vim.o.list true)
(set vim.o.listchars "tab: ,trail:·")
(set vim.o.mouse :a)
(set vim.o.scrolloff 0)
(set vim.o.shiftwidth 2)
(set vim.o.smartcase true)
(set vim.o.softtabstop 2)
(set vim.o.tabstop 2)
(set vim.o.timeoutlen 500)
(set vim.o.termguicolors true)
(set vim.o.updatetime 100)
(set vim.wo.wrap false)
(set vim.o.splitright true)
(set vim.o.winborder :solid)
(set vim.o.confirm true)

(fn get-source-name [diagnostic]
  (or diagnostic.source
      (-?> diagnostic.namespace
           (vim.diagnostic.get_namespace)
           (. :name))
     (.. "ns:" (tostring diagnostic.namespace))))

(fn diagnostic-format [diagnostic]
  (..
    (. cfg.icons diagnostic.severity)
    " [" (get-source-name diagnostic) "] "
    diagnostic.message))

(vim.diagnostic.config {:underline true
                        :signs false
                        :virtual_text false
                        :virtual_lines false
                        :update_in_insert false
                        :severity_sort true
                        :float {:format diagnostic-format
                                :header []}})
