-- [nfnl] after/plugin/nfnlm.fnl
vim.filetype.add({extension = {fnlm = "fnlm"}})
return vim.treesitter.language.register("fennel", "fnlm")
