(module own.plugin.which-key
  {autoload {nvim aniseed.nvim
             str aniseed.string
             core aniseed.core
             wk which-key
             t telescope.builtin
             telescope telescope
             toggle-term toggleterm
             gitsigns gitsigns
             scratch own.scratch}})

(wk.setup {:plugins {:spelling {:enabled false}
                     :presets {:operators true
                               :motions true
                               :text_objects true
                               :windows true
                               :nav true
                               :z true}}
           :window {:border :rounded
                    :margin [2 30 2 30]
                    :winblend 10}})

(defn- cmd [expression description]
  [(.. :<cmd> expression :<cr>) description])

; helpers
(defn- grep-buffer-content []
  (t.live_grep {:prompt_title "Find in open buffers"
                :grep_open_files true}))

(defn- telescope-file-browser [path]
  (telescope.extensions.menufacture.find_files {:depth 4 :cwd path}))

(defn- browse-plugins []
  (telescope-file-browser (.. (vim.fn.stdpath :data) "/lazy")))

(defn- set-font-size [func]
  (let [font (str.split nvim.o.guifont ::h)]
   (set nvim.o.guifont (.. (core.first font) ::h (func (core.last font))))))

(defn- toggle-zen []
  (if (core.empty? nvim.o.winbar)
    (do
      (gitsigns.toggle_current_line_blame true)
      (set nvim.o.cmdheight 1)
      (set nvim.o.laststatus 3)
      (set nvim.o.winbar "%{%v:lua.require'feline'.generate_winbar()%}"))
    (do
      (gitsigns.toggle_current_line_blame false)
      (set nvim.o.cmdheight 0)
      (set nvim.o.laststatus 0)
      (set nvim.o.winbar ""))))

(fn toggle-blame-line []
  (let [enabled? (gitsigns.toggle_current_line_blame)]
    (vim.notify
      (.. "Git blame line " (if enabled? :on :off))
      vim.log.levels.INFO
      {:title :toggle :timeout 1000})))

(defn term-tab []
  (toggle-term.toggle_command "direction=tab dir=. size=0" 200))

(defn term-split []
  (toggle-term.toggle_command "direction=horizontal dir=. size=0" 100))

; normal mode mappings
(wk.register
  {:f [telescope-file-browser "file browser"]

   ; finders
   :<leader> (cmd "Telescope find_files hidden=true no_ignore=false" "find files")
   :/ {:name :search
       :b [grep-buffer-content "in open buffers"]
       :p [telescope.extensions.menufacture.live_grep "in project"]
       :w [telescope.extensions.menufacture.grep_string "word under cursor"]}

   :s {:name :scratch
       :o [scratch.show :open]
       :k [scratch.kill :kill]}

   :j (cmd "Telescope jumplist" "jumplist")

   :vp [browse-plugins "vim plugins"]

   :t {:name :toggle
       :b [toggle-blame-line "git blame"]
       :d (cmd "TroubleToggle" :diagnostics)
       :z [toggle-zen :zen]
       :t {:name :terminal
           :s [term-split :split]
           :t [term-tab :tab]}}

   ; buffers
   :b {:name :buffer
       :b (cmd "Telescope buffers" "buffer list")
       :k (cmd "bprevious <bar> bdelete! #" "kill buffer")
       :o (cmd :BufOnly! "kill other buffers")}

   ; tmux runner
   :r {:name :runner
       :F (cmd :VtrFlushCommand :flush)
       :a (cmd :VtrAttachToPane :attach)
       :c (cmd :VtrClearRunner :clear)
       :f (cmd :VtrFocusRunner :focus)
       :k (cmd :VtrKillRunner :kill)
       :o (cmd :VtrOpenRunner :open)
       :s {:name :send}
         :c (cmd :VtrSendCommandToRunner :command)
         :f (cmd :VtrSendFile :file)
         :l (cmd :VtrSendLinesToRunner :lines)}

   :o {:name :orgmode
       :a :agenda
       :b [(fn [] (telescope-file-browser "~/Documents/org/"))
           :browse]
       :c :capture}

   :w {:name :window
       :z (cmd "tabnew %" :zoom)}}
  {:prefix :<leader>})

(wk.register {:c [(fn [] (telescope-file-browser "~/.config/nixpkgs")) :config]
              :d [:<cmd>DBUIToggle<cr> :db]
              :l {:name :lazy
                  :l (cmd "Lazy show" :show)
                  :i (cmd "Lazy install" :install)
                  :c (cmd "Lazy clean" :clean)
                  :u (cmd "Lazy update" :update)
                  :p (cmd "Lazy profile" :profile)
                  :s (cmd "Lazy sync" :sync)}
              :t {:name :toggle
                  :m (cmd :MindOpenMain :main)}
              :n {:name :notifications
                  :o ["<cmd>Telescope notify<cr>" :open]}}
             {:prefix :<localleader>})

(wk.register {:L (cmd :LToggle "list toggle")
              :Q (cmd :QToggle "quickfix toggle")
              :<M-s> (cmd "write" "silent! write")
              ;; spelling
              :z= (cmd "Telescope spell_suggest theme=get_cursor" "suggest spelling")
              ;; font size
              :<D-=> [(fn [] (set-font-size core.inc)) "increase font size"]
              :<D--> [(fn [] (set-font-size core.dec)) "increase font size"]
              ;; diagnostics
              "[d" (cmd "lua vim.diagnostic.goto_prev()" "next diagnostic")
              "]d" (cmd "lua vim.diagnostic.goto_next()" "prev diagnostic")})

(wk.register {:<C-t> [term-split :split]
              :<M-t> [term-tab :tab]}
             {:mode [:n :t]
              :nowait true})

; On-demand OS clipboard sharing
;
; Creates a map of handful of actions to share with
; the system clipbpard using the + registry.
;
; It would be the equivalent of mapping all the
; iterations of the actions in normal and visual mode
; and their uppercase versions
(def- shared-actions
  {:y {:name :yank    :dir :into}
   :x {:name :delete  :dir :into}
   :p {:name :paste   :dir :from}
   :c {:name :change  :dir :into}})

(defn- os-clipboard-cmd [action name direction]
  [(.. "\"+" action) (.. name " " direction " the OS clipboard")])

(let [os-mappings {}]
   (each [action data (pairs shared-actions)]
     (let [Action (string.upper action)]
       (tset os-mappings action (os-clipboard-cmd action data.name data.dir))
       (tset os-mappings Action (os-clipboard-cmd Action (string.upper data.name) data.dir))))
   (wk.register os-mappings {:prefix :<leader> :mode [:n :v]}))
