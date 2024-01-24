-- [nfnl] Compiled from fnl/plugins/ui.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local notify = autoload("notify")
local function config_beacon()
  return vim.api.nvim_create_autocmd("FocusGained", {pattern = "*", command = "Beacon"})
end
local function _2_(_241, _242)
  return math.min(_242, 80)
end
local function _3_(_241, _242)
  return math.min(_242, 15)
end
local function _4_()
  local function _5_(win, _record)
    return vim.api.nvim_win_set_config(win, {border = "solid"})
  end
  notify.setup({timeout = 2500, minimum_width = 30, fps = 60, on_open = _5_, render = "wrapped-compact", top_down = false})
  vim.notify = notify
  return nil
end
return {{"danilamihailov/beacon.nvim", config = config_beacon}, {"nvim-tree/nvim-web-devicons", opts = {override = {scm = {color = "#A6E3A1", name = "query", icon = "\243\176\152\167"}, fnl = {color = "teal", name = "blue", icon = "\238\143\146"}, norg = {icon = "\238\152\179"}}}, config = true}, {"stevearc/dressing.nvim", event = "VeryLazy", opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _2_, height = _3_}}}}, {"rcarriga/nvim-notify", dependencies = {"nvim-telescope/telescope.nvim"}, event = "VeryLazy", config = _4_}, {"folke/noice.nvim", config = true, event = "VeryLazy", opts = {lsp = {override = {["vim.lsp.util.convert_input_to_markdown_lines"] = true, ["vim.lsp.util.stylize_markdown"] = true, ["cmp.entry.get_documentation"] = true}, hover = {opts = {size = {max_height = 10, max_width = 80}}}}, messages = {view_search = false}}, dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"}}}
