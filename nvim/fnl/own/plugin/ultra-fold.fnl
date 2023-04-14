(module own.plugin.ultra-fold
  {autoload {ufo ufo}})

(defn fold-virt-text-fn [virt-text lnum end-lnum width truncate]
  (let [new-virt-text {}]
    (var suffix (: "  %d " :format (- end-lnum lnum)))
    (local suf-width (vim.fn.strdisplaywidth suffix))
    (local target-width (- width suf-width))
    (var cur-width 0)
    (each [_ chunk (ipairs virt-text)]
      (var chunk-text (. chunk 1))
      (var chunk-width (vim.fn.strdisplaywidth chunk-text))
      (if (> target-width (+ cur-width chunk-width))
        (table.insert new-virt-text chunk)
        (do
          (set chunk-text (truncate chunk-text (- target-width cur-width)))
          (local hl-group (. chunk 2))
          (table.insert new-virt-text [chunk-text hl-group])
          (set chunk-width (vim.fn.strdisplaywidth chunk-text))
          (when (< (+ cur-width chunk-width) target-width)
            (set suffix
                 (.. suffix
                     (string.rep " " (- target-width cur-width chunk-width)))))
          (lua :break)))
      (set cur-width (+ cur-width chunk-width)))
    (table.insert new-virt-text [suffix :MoreMsg])
    new-virt-text))

(ufo.setup {:fold_virt_text_handler fold-virt-text-fn
            :max_lines 4
            :provider :lsp
            :preview {:win_config {:winblend 0}}})

(comment
  (set vim.o.foldcolumn :1))
(set vim.o.foldlevel 99)
(set vim.o.foldlevelstart 99)
(set vim.o.foldenable true)

(vim.keymap.set :n :zO ufo.openAllFolds {:desc "Open all folds"})
(vim.keymap.set :n :zC ufo.closeAllFolds {:desc "Close all folds"})
(vim.keymap.set :n :zp ufo.peekFoldedLinesUnderCursor {:desc "Preview fold"})
