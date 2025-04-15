(import-macros {: nmap
                : vmap
                : tmap
                : map
                : autocmd
                : augroup} :own.macros)
(local {: autoload} (require :nfnl.module))

(local gitsigns (autoload :gitsigns))
(local toggle-term (autoload :toggleterm))
(local terminal (autoload :toggleterm.terminal))
(local navic (autoload :nvim-navic))
(local projects (autoload :own.projects))
(local core (autoload :nfnl.core))
(local snacks (autoload :snacks))

(local error-filter {:severity vim.diagnostic.severity.ERROR})
(local warning-filter {:severity vim.diagnostic.severity.WARNING})

(local state {:tmux-term nil})

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

(fn term-tab [id]
  (toggle-term.toggle_command "direction=tab dir=. size=0" id))

(fn term-split [id]
  (toggle-term.toggle_command "direction=horizontal dir=. size=0" id))

(fn toggle-tmux []
  (local term terminal.Terminal)

  (if (= state.tmux-term nil)
     (tset state :tmux-term (term:new {:id 200
                                       :cmd "tmux -2 attach 2>/dev/null || tmux -2"
                                       :direction :tab
                                       :close_on_exit true
                                       :on_exit #(tset state :tmux-term nil)})))
  (state.tmux-term:toggle))

(fn toggle-zellij []
  (local term terminal.Terminal)

  (if (= state.tmux-zellij nil)
      (tset state :tmux-zellij (term:new {:id 200
                                          :cmd "zellij attach || zellij"
                                          :direction :tab
                                          :close_on_exit true
                                          :on_exit #(tset state :tmux-zellij nil)}))
      (state.tmux-zellij:toggle)))

; Zellij uses ctrl-t to enter the tab mode
; This function makes sure we fire the righ command depending on the context
(fn ctrl-t [id]
  (if (string.find (vim.fn.expand "%") "zellij")
    (vim.system [:zellij :action :switch-mode :tab])
    (term-split id)))

(fn opts [desc] {:silent true : desc})

(fn get-git-root []
  (core.get-in vim [:b :gitsigns_status_dict :root]))

(fn search-cword []
  (vim.cmd "normal! yiw")
  (vim.cmd "GrugFar")
  (vim.schedule #(vim.cmd "normal! p$")))

(nmap :<leader><leader> #(projects.find-files (get-git-root) (opts "find files")))
(nmap :<leader>/b grep-buffer-content (opts "find in open buffers"))
(nmap :<leader>/p (cmd :GrugFar) (opts "find in project"))
(nmap :<leader>/w search-cword (opts "find current word"))

(nmap :<leader>m #(snacks.picker.marks) (opts "list marks"))

(nmap :<leader>s ":botright split /tmp/scratch.fnl<cr>" (opts "open scratch buffer"))

(nmap :<leader>vp browse-plugins (opts "vim plugins"))

;; toggles
(nmap :<leader>tb toggle-blame-line (opts "toggle blame line"))

;; buffers
(nmap :<leader>bb #(snacks.picker.buffers) (opts "list buffers"))
(nmap :<leader>bk #(snacks.bufdelete.delete) (opts "kill buffer"))
(nmap :<leader>bo #(snacks.bufdelete.other) (opts "kill other buffers"))

;; toggle term
(map [:n :t] :<C-t> #(ctrl-t 100) (opts "split term"))
(map [:n :t] :<C-1> #(term-split 1) (opts "split term 1"))
(map [:n :t] :<C-2> #(term-split 2) (opts "split term 2"))
(map [:n :t] :<C-3> #(term-split 3) (opts "split term 3"))
(map [:n :t] :<C-4> #(term-split 4) (opts "split term 4"))
(map [:n :t] :<C-5> #(term-split 5) (opts "split term 5"))
(map [:n :t] :<M-1> #(term-tab 1) (opts "tab term 1"))
(map [:n :t] :<M-2> #(term-tab 2) (opts "tab term 2"))
(map [:n :t] :<M-3> #(term-tab 3) (opts "tab term 3"))
(map [:n :t] :<M-4> #(term-tab 4) (opts "tab term 4"))
(map [:n :t] :<M-5> #(term-tab 5) (opts "tab term 5"))
(map [:n :t] :<M-t> toggle-tmux (opts "tmux"))
(map [:n :t] :<M-z> toggle-zellij (opts "zellij"))

;; less used commands, grouped by feature

(nmap :<localleader>c #(snacks.picker.files {:dirs ["~/.config/home-manager"]
                                             :title "home manager config"}) (opts "home manager config"))

;; lazy ui
(nmap :<localleader>l (cmd "Lazy show") (opts "lazy ui"))

; mason
(nmap :<localleader>m (cmd :Mason) (opts :mason))

;; notifications
(nmap :<localleader>no #(snacks.picker.notifications) (opts "open notifications"))
(nmap :<localleader>nd #(snacks.notifier.hide) (opts "dismiss notifications"))

;; projects
(nmap :<localleader>p #(projects.select-project) (opts "switch projects"))

;; single key mappings
(nmap :L (cmd :LToggle) (opts "list toggle"))
(nmap :Q (cmd :QToggle) (opts "quickfix toggle"))
(nmap :<M-s> (cmd "silent! write") (opts "write file"))
(nmap :z= #(snacks.picker.spelling) (opts "suggest spelling"))

;; diagnostics
(nmap "[d" #(vim.diagnostic.jump (core.merge {:count -1} error-filter)) (opts "next diagnostic"))
(nmap "]d" #(vim.diagnostic.jump (core.merge {:count 1} error-filter)) (opts "previous diagnostic"))
(nmap "[w" #(vim.diagnostic.jump (core.merge {:count -1} warning-filter)) (opts "next warning"))
(nmap "]w" #(vim.diagnostic.jump (core.merge {:count 1} warning-filter)) (opts "previous warning"))

; LSP mappings
; Set only to the buffer where the LSP client is attached

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

(fn on-attach [args]
  (local bufnr args.buf)
  (local client (vim.lsp.get_client_by_id args.data.client_id))
  (vim.api.nvim_buf_set_option 0 :omnifunc :v:lua.vim.lsp.omnifunc)

  ;; Mappings
  (buf-map :gd (cmd "Glance definitions") "lsp: go to definition")
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

(augroup :lsp-attach [:LspAttach {:callback on-attach}])

(nmap :<M-x> #(snacks.picker.commands {:layout {:preset :dropdown}}) {:nowait true :silent true})
(nmap :<M-h> #(snacks.picker.help {:layout {:preset :dropdown}}) {:nowait true :silent true})
(nmap :<M-k> #(snacks.picker.keymaps {:layout {:preset :vscode}}) {:nowait true :silent true})
(nmap :<M-o> #(snacks.picker.recent) {:nowait true :silent true})

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

; On-demand OS clipboard sharing
;
; Creates a map of handful of actions to share with
; the system clipbpard using the + registry.
(each [_ action (ipairs [:y :d :p :c])]
   (let [Action (string.upper action)]
      (nmap (.. :<leader> action) (.. "\"+" action))
      (vmap (.. :<leader> action) (.. "\"+" action))
      (nmap (.. :<leader> Action) (.. "\"+" Action))
      (vmap (.. :<leader> Action) (.. "\"+" Action))))
