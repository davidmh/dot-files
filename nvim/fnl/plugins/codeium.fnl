(import-macros {: use : imap} :own.macros)
(local {: autoload} (require :nfnl.module))
(local parpar (autoload :parpar))
(local codeium-virtual-text (autoload :codeium.virtual_text))

(fn codeium/accept []
  (-> (parpar.pause)
      (vim.schedule))
  (codeium-virtual-text.accept))

(use :Exafunction/codeium.nvim {:event :InsertEnter
                                :dependencies [:nvim-lua/plenary.nvim]
                                :init #(imap :<M-y> codeium/accept {:expr true :silent true})
                                :opts {:enable_cmp_source false
                                       :virtual_text {:enabled true
                                                      :filetypes {:zsh false
                                                                  :TelescopePrompt false}
                                                      :default_filetype_enabled true
                                                      :key_bindings {:accept false
                                                                     :clear :<M-c>
                                                                     :next :<M-n>
                                                                     :prev :<M-p>}}}})
