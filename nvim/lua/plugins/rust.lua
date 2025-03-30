-- [nfnl] Compiled from fnl/plugins/rust.fnl by https://github.com/Olical/nfnl, do not edit.
vim.g.rustaceanvim = {tools = {test_executor = "background"}, server = {default_settings = {["rust-analyzer"] = {files = {excludeDirs = {".direnv", ".devenv"}}}}}}
vim.g.rustfmt_autosave = true
return {"mrcjkb/rustaceanvim", version = "^5", ft = "rust"}
