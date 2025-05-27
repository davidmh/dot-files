(local {: autoload : define} (require :nfnl.module))
(local fs (autoload :nfnl.fs))
(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))
(local M (define :own.git))

(fn M.git-error [result]
  (vim.notify result.stderr
              vim.log.levels.ERROR
              {:icon :󰊢 :title "git error"}))

(fn M.git [...]
  (local process (vim.system [:git ...] {:text true}))
  (local result (process:wait))
  (if (= result.stderr "")
    (str.trim result.stdout)
    (M.git-error result)))

(fn M.git-remote-base-url []
  (let [remote (M.git :remote :get-url :origin)
        base-url (match (str.split remote ::)
                  ["git@github.com" path] (.. "https://github.com/" path)
                  ["https"] remote)]
      (.. (string.gsub base-url ".git$" ""))))

; Open the current file's remote URL
(fn M.git-url []
  (let [repo-root (M.git :rev-parse :--show-toplevel)
        absolute-path (vim.fn.expand :%:p)
        relative-path (string.sub absolute-path (+ 2 (length repo-root)))
        commit (M.git :rev-parse :HEAD)]
      (.. (M.git-remote-base-url) "/blob/" commit "/" relative-path)))

(fn M.git-url-with-range [opts]
  (if (= opts.range 2)
    (.. (M.git-url) "#L" opts.line1 "-L" opts.line2)
    (M.git-url)))

(fn M.write []
  (local current-file (vim.fn.expand :%:p))

  ; Write the current buffer and stage it
  (vim.cmd :write)
  (M.git :add :-- current-file)

  ; If this is a fennel file, also stage the corresponding lua file
  (if (vim.endswith current-file ".fnl")
      (vim.schedule #(let [lua-file (fs.fnl-path->lua-path current-file)]
                       (if (= (vim.fn.filereadable lua-file) 1)
                           (M.git :add :-- lua-file))))))

(fn M.files-in-commit [ref]
  (let [output (vim.fn.systemlist [:git :show :--name-only :--diff-filter :d :--oneline ref])
        title (core.first output)
        git-root (or (core.get-in vim.b [:gitsigns_status_dict :root])
                     (vim.trim (vim.fn.system "git rev-parse --show-toplevel")))
        files (->> output
                  (core.rest)
                  (vim.tbl_filter #(not (core.empty? $1))))
        next-commit (->> (vim.fn.systemlist [:git :log :-n 1 :--oneline (.. ref :^)])
                         (core.first)
                         (.. "next: "))
        next-ref (-> next-commit
                     (str.split " ")
                     (core.second))]
    (table.insert files next-commit)
    (vim.ui.select files {:prompt title} #(do
                                            (if (= $1 nil) (lua :return))
                                            (if (= $1 next-commit)
                                              (M.files-in-commit next-ref)
                                              (vim.cmd (.. "edit " git-root "/" $1)))))))

(fn M.copy-remote-url [opts]
  (local url (M.git-url-with-range (or opts {})))
  (vim.fn.setreg :+ url)
  (vim.notify url vim.log.levels.INFO {:title "Copied to clipboard"
                                       :icon :}))

; snack picker action
(fn M.view-in-fugitive [picker item]
   (picker:close)
   (if item (vim.schedule #(vim.cmd (.. "Gtabedit " item.commit)))))

M
