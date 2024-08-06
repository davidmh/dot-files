(import-macros {: nmap
                : vmap
                : tmap
                : map
                : autocmd
                : augroup} :own.macros)
(local {: autoload} (require :nfnl.module))

(local t (autoload :telescope.builtin))
(local gitsigns (autoload :gitsigns))
(local toggle-term (autoload :toggleterm))
(local terminal (autoload :toggleterm.terminal))
(local navic (autoload :nvim-navic))
(local projects (autoload :own.projects))
(local core (autoload :nfnl.core))

(local error-filter {:severity vim.diagnostic.severity.ERROR})
(local warning-filter {:severity vim.diagnostic.severity.WARNING})

(local state {:tmux-term nil})

; helpers

(fn cmd [expression]
  (.. :<cmd> expression :<cr>))

(fn grep-buffer-content []
  (t.live_grep {:prompt_title "Find in open buffers"
                :grep_open_files true}))

(fn telescope-file-browser [path]
  (t.find_files {:depth 4 :cwd path}))

(fn browse-plugins []
  (telescope-file-browser (.. (vim.fn.stdpath :data) "/lazy")))

(fn browse-runtime []
  (telescope-file-browser (vim.fn.expand "$VIMRUNTIME/lua")))

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

(fn term-vsplit [id]
  (toggle-term.toggle_command (.. "direction=vertical dir=. size=" (/ vim.o.columns 2)) id))

(fn toggle-tmux []
  (local term terminal.Terminal)

  (if (= state.tmux-term nil)
     (tset state :tmux-term (term:new {:id 200
                                       :cmd "tmux -2 attach 2>/dev/null || tmux -2"
                                       :direction :tab
                                       :close_on_exit true
                                       :on_exit #(tset state :tmux-term nil)})))
  (state.tmux-term:toggle))

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

(nmap :<leader>s ":botright split /tmp/scratch.fnl<cr>" (opts "open scratch buffer"))

(nmap :<leader>vp browse-plugins (opts "vim plugins"))
(nmap :<leader>vr browse-runtime (opts "vim runtime"))

;; toggles
(nmap :<leader>tb toggle-blame-line (opts "toggle blame line"))
(nmap :<leader>td (cmd "Trouble diagnostics toggle") (opts "toggle diagnostics"))
(nmap :<leader>ts (cmd "Trouble lsp_document_symbols toggle") (opts "toggle lsp document symbols"))

;; buffers
(nmap :<leader>bb #(t.buffers) (opts "list buffers"))
(nmap :<leader>bk (cmd "bprevious <bar> bdelete! #") (opts "kill buffer"))
(nmap :<leader>bo (cmd :BufOnly!) (opts "kill other buffers"))

;; neog
(nmap :<leader>ni (cmd "Neog index") (opts "neog index"))
(nmap :<leader>nb #(telescope-file-browser "~/Documents/neorg/") (opts "neorg browse"))
(nmap :<leader>nj (cmd "Neorg journal") (opts "neorg journal"))
(nmap :<leader>nr (cmd "Neorg return") (opts "neorg return"))

;; toggle term
(map [:n :t] :<C-t> #(term-split 100) (opts "split term"))
(map [:n :t] :<C-1> #(term-split 1) (opts "split term 1"))
(map [:n :t] :<C-2> #(term-split 2) (opts "split term 2"))
(map [:n :t] :<C-3> #(term-split 3) (opts "split term 3"))
(map [:n :t] :<C-4> #(term-split 4) (opts "split term 4"))
(map [:n :t] :<C-5> #(term-split 5) (opts "split term 5"))
(map [:n :t] :<M-\> #(term-vsplit 100) (opts "vertical split term"))
(map [:n :t] :<M-1> #(term-tab 1) (opts "tab term 1"))
(map [:n :t] :<M-2> #(term-tab 2) (opts "tab term 2"))
(map [:n :t] :<M-3> #(term-tab 3) (opts "tab term 3"))
(map [:n :t] :<M-4> #(term-tab 4) (opts "tab term 4"))
(map [:n :t] :<M-5> #(term-tab 5) (opts "tab term 5"))
(map [:n :t] :<M-t> toggle-tmux (opts "tmux"))

;; less used commands, grouped by feature

(nmap :<localleader>c #(telescope-file-browser "~/.config/home-manager") (opts "home manager config"))
(nmap :<localleader>d (cmd :DBUIToggle) (opts "dadbod ui"))

;; lazy ui
(nmap :<localleader>l (cmd "Lazy show") (opts "lazy ui"))

; mason
(nmap :<localleader>m (cmd :Mason) (opts :mason))

;; notifications
(nmap :<localleader>no (cmd "Telescope notify") (opts "open notifications"))
(nmap :<localleader>nd #(vim.notify.dismiss) (opts "dismiss notifications"))

;; projects
(nmap :<localleader>p #(projects.select-project) (opts "switch projects"))

;; single key mappings
(nmap :L (cmd :LToggle) (opts "list toggle"))
(nmap :Q (cmd :QToggle) (opts "quickfix toggle"))
(nmap :<M-s> (cmd "silent! write") (opts "write file"))
(nmap :z= (cmd "Telescope spell_suggest theme=get_cursor") (opts "suggest spelling"))
;; diagnostics
(nmap "[d" #(vim.diagnostic.goto_prev error-filter) (opts "next diagnostic"))
(nmap "]d" #(vim.diagnostic.goto_next error-filter) (opts "previous diagnostic"))
(nmap "[w" #(vim.diagnostic.goto_prev warning-filter) (opts "next warning"))
(nmap "]w" #(vim.diagnostic.goto_next warning-filter) (opts "previous warning"))

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
  (buf-map :K #(vim.lsp.buf.hover) "lsp: hover")
  (buf-map :gd #(vim.lsp.buf.definition {:reuse_win true}) "lsp: go to definition")

  (buf-map :<leader>lf #(vim.lsp.buf.references) "lsp: find references")
  (buf-map :<leader>li #(vim.lsp.buf.implementation) "lsp: implementation")
  (buf-map :<leader>ls #(vim.lsp.buf.signature_help) "lsp: signature")
  (buf-map :<leader>lt #(vim.lsp.buf.type_definition) "lsp: type definition")
  (buf-map :<leader>la #(vim.lsp.buf.code_action) "lsp: code actions")
  (buf-map :<leader>lr #(vim.lsp.buf.rename) "lsp: rename")
  (buf-map :<leader>lR :<cmd>LspRestart<CR> "lsp: restart")

  (vmap :<leader>la #(vim.lsp.buf.code_action) {:buffer true
                                                :desc "lsp: code actions"})

  (when (= client.name :eslint) (set-eslint-autofix bufnr))

  (when client.server_capabilities.documentSymbolProvider
    (navic.attach client bufnr)))

(augroup :lsp-attach [:LspAttach {:callback on-attach}])

; Telescope
(nmap :<localleader>x ::Telescope<CR> {:nowait true :silent true})
(nmap :<localleader>h ":Telescope help_tags<CR>" {:nowait true :silent true})
(nmap :<localleader>k ":Telescope keymaps<CR>" {:nowait true :silent true})
(nmap :<localleader>o ":Telescope oldfiles<CR>" {:nowait true :silent true})

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
(tmap :<M-k> :<C-\><C-n><C-W>k)
(tmap :<M-j> :<C-\><C-n><C-W>j)
(tmap :<M-h> :<C-\><C-n><C-W>h)
(tmap :<M-l> :<C-\><C-n><C-W>l)

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
