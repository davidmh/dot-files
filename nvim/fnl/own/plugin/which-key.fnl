(module own.plugin.which-key
  {autoload {nvim aniseed.nvim
             str aniseed.string
             core aniseed.core
             config own.config
             wk which-key
             t telescope.builtin
             telescope telescope
             toggle-term toggleterm
             gitsigns gitsigns
             scratch own.scratch}})

(set vim.o.timeoutlen 2500)

(wk.setup {:plugins {:spelling {:enabled false}
                     :presets {:operators true
                               :motions true
                               :text_objects true
                               :windows true
                               :nav true
                               :z true}}
           :window {:border config.border
                    :margin [2 30 2 30]
                    :winblend 10}})

(defn- cmd [expression description]
  [(.. :<cmd> expression :<cr>) description])

; helpers
(defn- grep-buffer-content []
  (t.live_grep {:prompt_title "Find in open buffers"
                :grep_open_files true}))

(defn- telescope-file-browser [path]
  (t.find_files {:depth 4 :cwd path}))

(defn- browse-plugins []
  (telescope-file-browser (.. (vim.fn.stdpath :data) "/lazy")))

(defn- browse-runtime []
  (telescope-file-browser (vim.fn.expand "$VIMRUNTIME/lua")))

(defn- set-font-size [func]
  (let [font (str.split nvim.o.guifont ::h)]
   (set nvim.o.guifont (.. (core.first font) ::h (func (core.last font))))))

(defn- toggle-blame-line []
  (let [enabled? (gitsigns.toggle_current_line_blame)]
    (vim.notify
      (.. "Git blame line " (if enabled? :on :off))
      vim.log.levels.INFO
      {:title :toggle :timeout 1000})))

(defn- find-files []
  (t.find_files {:find_command [:fd
                                :--hidden
                                :--type :f
                                :--exclude :.git]}))

; normal mode mappings
(wk.register
  {:f [telescope-file-browser "file browser"]

   ; finders
   :<leader> [find-files "find files"]
   :/ {:name :search
       :b [grep-buffer-content "in open buffers"]
       :p [t.live_grep "in project"]
       :w [t.grep_string "word under cursor"]}

   :s {:name :scratch
       :o [scratch.show :open]
       :k [scratch.kill :kill]}

   :vp [browse-plugins "vim plugins"]
   :vr [browse-runtime "vim runtime"]

   :t {:name :toggle
       :b [toggle-blame-line "git blame"]
       :d (cmd "TroubleToggle document_diagnostics" :diagnostics)}

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

(wk.register {:c [(fn [] (telescope-file-browser "~/.config/home-manager")) :config]
              :d (cmd :DBUIToggle :db)
              :l {:name :lazy
                  :l (cmd "Lazy show" :show)
                  :i (cmd "Lazy install" :install)
                  :c (cmd "Lazy clean" :clean)
                  :u (cmd "Lazy update" :update)
                  :p (cmd "Lazy profile" :profile)
                  :s (cmd "Lazy sync" :sync)}
              :n {:name :notifications
                  :o (cmd "Telescope notify" :open)}}
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
