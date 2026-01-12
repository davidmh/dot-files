-- [nfnl] fnl/plugins/rust.fnl
vim.g.rustaceanvim = {tools = {test_executor = "background"}, server = {default_settings = {["rust-analyzer"] = {files = {excludeDirs = {".direnv", ".devenv"}}}}}}
vim.g.rustfmt_autosave = 1
return {"mrcjkb/rustaceanvim", version = "^6"}
