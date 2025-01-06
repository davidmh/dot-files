(import-macros {: nmap} :own.macros)
(local {: find-index} (require :own.lists))

(local actions [:pick :reword :edit :squash :fixup :break :drop])

(fn cycle []
  "loop through the git rebase actions for the commit in the current line"
  (let [current-line (vim.api.nvim_get_current_line)
        current-index (find-index #(vim.startswith current-line $1) actions)]
    (when current-index
      (let [current-action (.. "^" (. actions current-index))
            next-action (or (. actions (+ current-index 1)) (. actions 1))
            next-line (string.gsub current-line current-action next-action)]
        (vim.api.nvim_set_current_line next-line)))))

(nmap :<tab> cycle {:silent true
                    :nowait true
                    :buffer 0})
