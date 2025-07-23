-- [nfnl] after/ftplugin/fugitive.fnl
vim.keymap.set("n", "p", "<cmd>Neogit pull<cr>", {desc = "git pull", buffer = true, nowait = true})
vim.keymap.set("n", "P", "<cmd>Neogit push<cr>", {desc = "git push", buffer = true, nowait = true})
return vim.keymap.set("n", "b", "<cmd>Neogit branch<cr>", {desc = "git branch", buffer = true, nowait = true})
