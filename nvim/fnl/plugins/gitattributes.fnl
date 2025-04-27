(import-macros {: use} :own.macros)
(local {: assoc-in} (require :nfnl.core))

(fn on-match [params]
  (local {: attributes : buffer} params)

  (when attributes.linguist-generated
    (assoc-in vim.bo [buffer :readonly] true)
    (assoc-in vim.bo [buffer :modifiable] false))

  (when attributes.linguist-language
    (assoc-in vim.bo [buffer :filetype] attributes.linguist-language))

  ; print all the params
  (vim.notify (vim.inspect params)
              vim.log.levels.DEBUG
              {:title "Gitattributes"
               :icon :󰊢}))

(use :davidmh/gitattributes.nvim {:opts {:on_match on-match}})
