(import-macros {: nmap : vmap} :own.macros)
(local {: autoload} (require :nfnl.module))

(local t (autoload :telescope.builtin))
(local gitsigns (autoload :gitsigns))
(local scratch (autoload :own.scratch))

(fn cmd [expression]
  (.. :<cmd> expression :<cr>))

; helpers
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

(fn find-files []
  (t.find_files {:find_command [:fd
                                :--hidden
                                :--type :f
                                :--exclude :.git]}))

(fn opts [desc]
  {:silent true
   :nowait true
   : desc})

; normal mode mappings
(nmap :<leader><leader> find-files (opts "find files"))
(nmap :<leader>/b grep-buffer-content (opts "find in open buffers"))
(nmap :<leader>/p #(t.live_grep) (opts "find in project"))
(nmap :<leader>/w #(t.grep_string) (opts "find word under cursor"))

(nmap :<leader>so scratch.show (opts "open scratch buffer"))
(nmap :<leader>sk scratch.kill (opts "kill scratch buffer"))

(nmap :<leader>vp browse-plugins (opts "vim plugins"))
(nmap :<leader>vr browse-runtime (opts "vim runtime"))

;; toggles
(nmap :<leader>tb toggle-blame-line (opts "toggle blame line"))
(nmap :<leader>td (cmd "Trouble document_diagnostics") (opts "toggle diagnostics"))

;; buffers
(nmap :<leader>bb #(t.buffers) (opts "list buffers"))
(nmap :<leader>bk (cmd "bprevious <bar> bdelete! #") (opts "kill buffer"))
(nmap :<leader>bo (cmd :BufOnly!) (opts "kill other buffers"))

;; orgmode
(nmap :<leader>ob #(telescope-file-browser "~/Documents/org/") (opts "org browse"))

;; less used commands, grouped by feature

(nmap :<localleader>c #(telescope-file-browser "~/.config/home-manager") (opts "home manager config"))
(nmap :<localleader>d (cmd :DBUIToggle) (opts "dadbod ui"))

;; lazy
(nmap :<localleader>ls (cmd "Lazy show") (opts "lazy show"))
(nmap :<localleader>lc (cmd "Lazy clean") (opts "lazy clean"))
(nmap :<localleader>lu (cmd "Lazy update") (opts "lazy update"))

;; notifications
(nmap :<localleader>no (cmd "Telescope notify") (opts "open notifications"))
(nmap :<localleader>nd #(vim.notify.dismiss) (opts "dismiss notifications"))

;; single key mappings
(nmap :L (cmd :LToggle) (opts "list toggle"))
(nmap :Q (cmd :QToggle) (opts "quickfix toggle"))
(nmap :<M-s> (cmd "write silent!") (opts "write file"))
(nmap :z= (cmd "Telescope spell_suggest theme=get_cursor") (opts "suggest spelling"))
;; diagnostics
(nmap "[d" #(vim.diagnostic.goto_prev) (opts "next diagnostic"))
(nmap "]d" #(vim.diagnostic.goto_next) (opts "previous diagnostic"))

; On-demand OS clipboard sharing
;
; Creates a map of handful of actions to share with
; the system clipbpard using the + registry.
(each [_ action (ipairs [:y :x :p :c])]
   (let [Action (string.upper action)]
      (nmap (.. :<leader> action) (.. "\"+" action))
      (vmap (.. :<leader> action) (.. "\"+" action))
      (nmap (.. :<leader> Action) (.. "\"+" Action))
      (vmap (.. :<leader> Action) (.. "\"+" Action))))
