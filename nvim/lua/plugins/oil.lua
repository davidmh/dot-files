-- [nfnl] fnl/plugins/oil.fnl
local _local_1_ = require("own.config")
local border = _local_1_["border"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local snacks = autoload("snacks")
local function _3_(event)
  if (event.data.actions.type == "move") then
    print(vim.inspect(event.data))
    return snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("User", {pattern = "OilActionsPost", callback = _3_})
return {"stevearc/oil.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}, keys = {{"<leader>fs", "<c-w>s<cmd>Oil<cr>", desc = "file explorer in split"}, {"<leader>fv", "<c-w>v<cmd>Oil<cr>", desc = "file explorer in vertical split"}, {"<leader>f.", "<cmd>Oil<cr>", desc = "file explorer in current window"}}, opts = {keymaps = {["<c-v>"] = {"actions.select", opts = {vertical = true}}, ["<c-s>"] = {"actions.select", opts = {horizontal = true}}, ["<c-h>"] = false, ["<c-l>"] = false}, view_options = {show_hidden = true}, confirmation = {border = border}, progress = {border = border}, keymaps_help = {border = border}}}
