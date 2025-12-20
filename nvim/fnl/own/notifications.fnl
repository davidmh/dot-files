(local {: autoload : define} (require :nfnl.module))
(local M (define :own.notifications))
(local snacks (autoload :snacks))

;; open a notification from snacks in a floating window
(fn confirm [picker choice]
  (picker:close)
  (when choice
    (local text (.. "\n# "
                    (or choice.item.icon "󰍡 ")
                    (or
                      (and (= choice.item.title "") "no title")
                      choice.item.title)
                    "\n\n"
                    choice.item.msg))
    (snacks.win {:width 0.5
                 :height 0.4
                 :backdrop false
                 :border :solid
                 :wo {:spell false
                      :wrap true
                      :conceallevel 3
                      :signcolumn :no
                      :statuscolumn " "}
                 :bo {:filetype choice.preview.ft
                      :buftype :nofile
                      :modifiable false}
                 :text text
                 :keys {:<esc> :close}})))

(fn M.open []
  (snacks.picker.notifications {:confirm confirm}))

(fn M.discard []
  (snacks.notifier.hide))

M
