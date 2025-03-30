(import-macros {: use} :own.macros)

(set vim.g.rustaceanvim {:tools {:test_executor :background}
                         :server {:default_settings {:rust-analyzer {:files {:excludeDirs [:.direnv
                                                                                           :.devenv]}}}}})
(set vim.g.rustfmt_autosave true)

(use :mrcjkb/rustaceanvim {:version :^5
                           :ft :rust})
