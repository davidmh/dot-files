(import-macros {: nmap} :own.macros)

(fn get-font-size []
  (-> vim.o.guifont
      (string.match "h(%d+)$")
      (tonumber)))

(fn set-font-size [n]
  (->> (get-font-size)
       (+ n)
       (string.format "h%d")
       (string.gsub vim.o.guifont "h%d+")
       (tset vim.o :guifont)))

(when vim.g.neovide
  (set vim.g.neovide_padding_top 25)
  (set vim.g.neovide_padding_bottom 25)
  (set vim.g.neovide_padding_right 25)
  (set vim.g.neovide_padding_left 25)
  (set vim.g.neovide_input_macos_alt_is_meta true)
  (set vim.g.neovide_remember_window_size true)

  (nmap :<D-=> #(set-font-size +1))
  (nmap :<D--> #(set-font-size -1)))

[]
