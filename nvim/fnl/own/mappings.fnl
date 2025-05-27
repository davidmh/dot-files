(import-macros {: nmap
                : vmap
                : tmap
                : map
                : autocmd
                : augroup} :own.macros)
(local {: autoload} (require :nfnl.module))

(local git (autoload :own.git))
(local gitsigns (autoload :gitsigns))
(local navic (autoload :nvim-navic))
(local projects (autoload :own.projects))
(local core (autoload :nfnl.core))
(local snacks (autoload :snacks))
(local notifications (autoload :own.notifications))

(local error-filter {:severity vim.diagnostic.severity.ERROR})
(local warning-filter {:severity vim.diagnostic.severity.WARNING})

; helpers

(fn cmd [expression]
  (.. :<cmd> expression :<cr>))

(fn grep-buffer-content []
  (snacks.picker.grep_buffers {:title "Find in open buffers"}))

(fn browse-plugins []
  (snacks.picker.files {:rtp true
                        :title :plugins}))

(fn toggle-blame-line []
  (let [enabled? (gitsigns.toggle_current_line_blame)]
    (vim.notify
      (.. "Git blame line " (if enabled? :on :off))
      vim.log.levels.INFO
      {:title :toggle :timeout 1000})))

(fn toggle-quickfix []
  ; The vim.g.qf_bufnr is set in after/ftplugin/qf.fnl
  (if (= vim.g.qf_bufnr nil)
      (vim.cmd.copen)
      (vim.cmd.cclose)))

(fn toggle-zellij []
  (snacks.terminal.toggle "direnv exec . zellij attach || direnv exec . zellij"
                          {:win {:position :float}}))

; Zellij uses ctrl-t to enter the tab mode
; This function makes sure we fire the right command depending on the context
(fn ctrl-t []
  (if (string.find (vim.fn.expand "%") "zellij")
    (vim.system [:zellij :action :switch-mode :tab])
    (snacks.terminal.toggle "direnv exec . zsh")))

(fn opts [desc] {:silent true : desc})

(fn get-git-root []
  (core.get-in vim [:b :gitsigns_status_dict :root]))

(nmap :<leader><leader> #(projects.find-files (get-git-root)) (opts "find files"))
(nmap :<leader>/ :<ignore> {:desc :find})
(nmap :<leader>/b grep-buffer-content (opts "find in open buffers"))
(nmap :<leader>/p #(snacks.picker.grep) (opts "find in project"))
(nmap :<leader>/w #(snacks.picker.grep_word) (opts "find current word"))

(nmap :<leader>m #(snacks.picker.marks) (opts "list marks"))

(nmap :<leader>s ":botright split /tmp/scratch.fnl<cr>" (opts "open scratch buffer"))

(nmap :<leader>vp browse-plugins (opts "vim plugins"))

;; toggles
(nmap :<leader>t :<ignore> {:desc :toggle})
(nmap :<leader>tb toggle-blame-line (opts "blame line"))

;; buffers
(nmap :<leader>b :<ignore> {:desc :buffer})
(nmap :<leader>bb #(snacks.picker.buffers) (opts "list buffers"))
(nmap :<leader>bk #(snacks.bufdelete.delete) (opts "kill buffer"))
(nmap :<leader>bo #(snacks.bufdelete.other) (opts "kill other buffers"))

;; toggle term
(map [:n :t] :<C-t> #(ctrl-t) (opts "split term"))
(map [:n :t] :<M-z> toggle-zellij (opts "zellij"))

;; less used commands, grouped by feature

(nmap :<localleader>c #(snacks.picker.files {:dirs ["~/.config/home-manager"]
                                             :title "home manager config"}) (opts "home manager config"))

;; lazy ui
(nmap :<localleader>l (cmd "Lazy show") (opts "lazy ui"))

; mason
(nmap :<localleader>m (cmd :Mason) (opts :mason))

;; notifications
(nmap :<localleader>n :<ignore> {:desc :notifications})
(nmap :<localleader>no #(notifications.open) (opts "open notifications"))
(nmap :<localleader>nd #(notifications.discard) (opts "dismiss notifications"))

;; projects
(nmap :<localleader>p #(projects.select-project) (opts "switch projects"))

;; single key mappings
(nmap :Q toggle-quickfix (opts "quickfix toggle"))
(nmap :z= #(snacks.picker.spelling) (opts "suggest spelling"))

;; diagnostics
(nmap "[d" #(vim.diagnostic.jump (core.merge {:float true :count -1} error-filter)) (opts "next diagnostic"))
(nmap "]d" #(vim.diagnostic.jump (core.merge {:float true :count 1} error-filter)) (opts "previous diagnostic"))
(nmap "[w" #(vim.diagnostic.jump (core.merge {:float true :count -1} warning-filter)) (opts "next warning"))
(nmap "]w" #(vim.diagnostic.jump (core.merge {:float true :count 1} warning-filter)) (opts "previous warning"))

(vim.api.nvim_create_augroup :eslint-autofix {:clear true})

; https://github.com/neovim/nvim-lspconfig/blob/da7461b596d70fa47b50bf3a7acfaef94c47727d/lua/lspconfig/server_configurations/eslint.lua#L141-L145
(fn set-eslint-autofix [bufnr]
  (autocmd :BufWritePre {:command :EslintFixAll
                         :group :eslint-autofix
                         :buffer bufnr}))

(fn buf-map [keymap callback desc]
  (nmap keymap callback {:buffer true
                         :silent true
                         : desc}))

; Set only to the buffer where the LSP client is attached
(fn lsp-mappings [args]
  (local bufnr args.buf)
  (local client (vim.lsp.get_client_by_id args.data.client_id))
  (vim.api.nvim_buf_set_option 0 :omnifunc :v:lua.vim.lsp.omnifunc)

  ;; Mappings
  (buf-map :K #(vim.lsp.buf.hover {:wrap false
                                   :max_width 130
                                   :max_height 20}) "lsp: hover")
  (buf-map :gd (cmd "Glance definitions") "lsp: go to definition")

  (buf-map :<leader>l :<ignore> :lsp)
  (buf-map :<leader>lf (cmd "Glance references") "lsp: find references")
  (buf-map :<leader>li (cmd "Glance implementations") "lsp: implementation")
  (buf-map :<leader>lt (cmd "Glance type_definitions") "lsp: type definition")
  (buf-map :<leader>le #(vim.diagnostic.setqflist error-filter)) "lsp: errors"
  (buf-map :<leader>la #(vim.lsp.buf.code_action) "lsp: code actions")
  (buf-map :<leader>lr #(vim.lsp.buf.rename) "lsp: rename")
  (buf-map :<leader>lR :<cmd>LspRestart<CR> "lsp: restart")

  (vmap :<leader>la #(vim.lsp.buf.code_action) {:buffer true
                                                :desc "lsp: code actions"})

  (when (= client.name :eslint) (set-eslint-autofix bufnr))

  (when client.server_capabilities.documentSymbolProvider
    (navic.attach client bufnr)))

(augroup :lsp-attach [:LspAttach {:callback lsp-mappings}])

;; git

(nmap :<leader>g :<ignore> {:desc :git})
(nmap :<leader>gg (cmd "Neogit") {:desc :status})
(nmap :<leader>gc (cmd "Neogit commit") {:desc :commit})
(nmap :<leader>gw #(git.write) {:desc :write})
(nmap :<leader>gr (cmd "Gread") {:desc :read})
(nmap :<leader>gb (cmd "Git blame") {:desc :blame})
(nmap :<leader>g- (cmd "Neogit branch") {:desc :branch})
(nmap :<leader>gd (cmd "Gvdiffsplit") {:desc :diff})
(nmap :<leader>gl #(snacks.picker.git_log {:confirm git.view-in-fugitive}) {:desc :log})
(nmap :<leader>gL #(snacks.picker.git_log_file {:confirm git.view-in-fugitive}) {:desc "log file"})
(nmap :<leader>g<space> #(git.files-in-commit :HEAD) {:desc "files in git HEAD"})
(nmap :<leader>gf (cmd "Neogit fetch" {:desc :fetch}))
(nmap :<leader>gp (cmd "Neogit pull" {:desc :pull}))
(nmap :<leader>gB (cmd "GBrowse") {:desc :browse})
(nmap :<leader>gh :<ignore> {:desc :hunk})
(nmap :<leader>ghs (cmd "Gitsigns stage_hunk") {:desc :stage})
(nmap :<leader>ghu (cmd "Gitsigns undo_stage_hunk") {:desc :unstage})
(nmap :<leader>ghr (cmd "Gitsigns reset_hunk") {:desc :reset})
(nmap :<leader>ghp (cmd "Gitsigns preview_hunk") {:desc :preview})
(nmap :<leader>ghb #(gitsigns.blame_line {:full true}) {:desc :blame})
(vmap :<leader>gl (cmd "'<,'>GBrowse") {:desc "current's selection git browse"
                                        :nowait true
                                        :silent true})
(vmap :<leader>gl (cmd "'<,'>NeogitLogCurrent") {:desc "current's selection git log"
                                                 :nowait true
                                                 :silent true})

(nmap "[h" (cmd "Gitsigns prev_hunk") {:desc "previous git hunk"
                                       :nowait true
                                       :silent true})
(nmap "]h" (cmd "Gitsigns next_hunk") {:desc "next git hunk"
                                       :nowait true
                                       :silent true})

(nmap :<M-x> #(snacks.picker.commands {:layout {:preset :dropdown}}) {:nowait true :silent true})
(nmap :<M-h> #(snacks.picker.help {:layout {:preset :dropdown}}) {:nowait true :silent true})
(nmap :<M-k> #(snacks.picker.keymaps {:layout {:preset :vscode}}) {:nowait true :silent true})
(nmap :<M-o> #(snacks.picker.recent) {:nowait true :silent true})
(nmap :<M-s> #(snacks.picker) {:nowait true :silent true})

(nmap :<leader>ff #(snacks.picker.explorer {:auto_close true}) {:desc "file explorer"})

; Windows
;
; in normal mode
;
; resize faster
(nmap "<M-,>" :<C-W>5<)
(nmap :<M-.> :<C-W>5>)
(nmap :<M--> :<C-W>5-)
(nmap :<M-=> :<C-W>5+)
; move faster
(nmap :<C-k> :<C-W>k)
(nmap :<C-j> :<C-W>j)
(nmap :<C-h> :<C-W>h)
(nmap :<C-l> :<C-W>l)
; in terminal mode
;
; resize faster
(tmap "<M-,>" :<C-\><C-n><C-W>5<)
(tmap :<M-.> :<C-\><C-n><C-W>5>)
(tmap :<M--> :<C-\><C-n><C-W>5-)
(tmap :<M-=> :<C-\><C-n><C-W>5+)
; move faster
(tmap :<C-k> :<C-\><C-n><C-W>k)
(tmap :<C-j> :<C-\><C-n><C-W>j)
(tmap :<C-h> :<C-\><C-n><C-W>h)
;(tmap :<C-l> :<C-\><C-n><C-W>l)

(augroup :auto-resize-windows [:VimResized {:pattern :* :command "wincmd ="}])

(local action-name {:y :yank
                    :Y "yank line"
                    :d :delete
                    :D "delete line"
                    :p :put
                    :P "put before"
                    :c :change
                    :C "change line"})

; On-demand OS clipboard sharing
;
; Creates a map of handful of actions to share with
; the system clipbpard using the + registry.
(each [_ action (ipairs [:y :d :p :c])]
  (local Action (string.upper action))
  (local desc (. action-name action))
  (local Desc (. action-name Action))
  (nmap (.. :<leader> action) (.. "\"+" action) {:desc desc})
  (vmap (.. :<leader> action) (.. "\"+" action) {:desc desc})
  (nmap (.. :<leader> Action) (.. "\"+" Action) {:desc Desc})
  (vmap (.. :<leader> Action) (.. "\"+" Action) {:desc Desc}))
