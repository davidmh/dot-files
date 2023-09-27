(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(set vim.o.cmdheight 0)
(set vim.o.cursorline true)
(set vim.o.expandtab true)
(set vim.o.grepprg "ag -S --vimgrep")
(set vim.o.guifont "Hasklug Nerd Font:h14")
(set vim.o.hidden true)
(set vim.o.ignorecase true)
(set vim.o.inccommand :split)
(set vim.o.laststatus 3)
(set vim.o.list true)
(set vim.o.listchars "tab:▸ ,trail:·")
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
(set vim.g.GuiWindowFrameless true)

(when vim.g.neovide
  (set vim.g.neovide_cursor_animate_command_line false)
  (set vim.g.neovide_input_use_logo true)
  (set vim.g.neovide_padding_top 20)
  (set vim.g.neovide_padding_bottom 5)
  (set vim.g.neovide_padding_right 20)
  (set vim.g.neovide_padding_left 20)
  (set vim.g.neovide_input_macos_alt_is_meta true)
  (vim.schedule #(when (= (vim.loop.cwd) :/)
                    (vim.cmd "Telescope oldfiles"))))

(fn os-open [url]
  (vim.fn.system (.. "xdg-open " url " || open " url)))

; I'm disabling netrw, and Fugitive needs a :Browse command
(vim.api.nvim_create_user_command :Browse (fn [opts] (os-open opts.args)) {:nargs 1})

(vim.api.nvim_create_augroup :auto-resize-windows {:clear true})
(vim.api.nvim_create_autocmd :VimResized {:pattern :*
                                          :group :auto-resize-windows
                                          :command "wincmd ="})

(require :own.plugins)
(require :own.window-mappings)
(require :own.confirm-quit)
(require :own.package)
