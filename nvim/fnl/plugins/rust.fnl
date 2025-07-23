(import-macros {: tx} :own.macros)

(set vim.g.rustaceanvim {:tools {:test_executor :background}
                         :server {:default_settings {:rust-analyzer {:files {:excludeDirs [:.direnv
                                                                                           :.devenv]}}}}})
(set vim.g.rustfmt_autosave true)

(tx :mrcjkb/rustaceanvim {:version :^6})
