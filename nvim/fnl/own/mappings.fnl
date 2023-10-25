(import-macros {: nmap : vmap : map} :own.macros)
(local {: autoload} (require :nfnl.module))

(local t (autoload :telescope.builtin))
(local gitsigns (autoload :gitsigns))
(local scratch (autoload :own.scratch))
(local toggle-term (autoload :toggleterm))
(local terminal (autoload :toggleterm.terminal))

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

(fn find-files []
  (t.find_files {:find_command [:fd
                                :--hidden
                                :--type :f
                                :--exclude :.git]}))

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


(fn opts [desc] {:silent true :nowait true : desc})

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

;; neog
(nmap :<leader>ob #(telescope-file-browser "~/Documents/neorg/") (opts "org browse"))

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
