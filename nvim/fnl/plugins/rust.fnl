(import-macros {: use} :own.macros)

(set vim.g.rustaceanvim {:tools {:test_executor :background}})
(set vim.g.rustfmt_autosave true)

(use :mrcjkb/rustaceanvim {:version :^4
                           :ft :rust})
