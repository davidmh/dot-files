-- [nfnl] Compiled from fnl/plugins/neorg.fnl by https://github.com/Olical/nfnl, do not edit.
return {{"vhyrro/luarocks.nvim", priority = 1000, config = true}, {"nvim-neorg/neorg", dependencies = {"vhyrro/luarocks.nvim"}, version = "*", opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["core.completion"] = {config = {engine = "nvim-cmp"}}, ["core.integrations.treesitter"] = {config = {configure_parsers = true, install_parsers = true}}, ["core.journal"] = {config = {workspace = "notes"}}, ["core.export"] = {config = {export_dir = "/tmp/"}}, ["core.export.markdown"] = {config = {extension = ".md"}}, ["core.dirman"] = {config = {workspaces = {notes = "~/Documents/neorg"}}}, ["core.mode"] = {}, ["core.ui.calendar"] = {}}}, lazy = false}}
