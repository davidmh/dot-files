-- [nfnl] after/ftplugin/rust.fnl
return vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>", {buffer = true, silent = true})
