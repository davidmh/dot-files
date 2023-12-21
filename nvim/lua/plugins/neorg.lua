-- [nfnl] Compiled from fnl/plugins/neorg.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_(_, opts)
  if (vim.re ~= nil) then
    opts.load["core.ui.calendar"] = {}
    return nil
  else
    opts.load["core.ui.calendar.views.monthly"] = {}
    if nil then
      opts.load["core.tempus"] = {}
      return nil
    else
      return nil
    end
  end
end
return {"nvim-neorg/neorg", build = ":Neorg sync-parsers", dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"}, ft = "norg", mod = "neorg", opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["core.completion"] = {config = {engine = "nvim-cmp"}}, ["core.integrations.treesitter"] = {config = {configure_parsers = true, install_parsers = true}}, ["core.export"] = {config = {export_dir = "/tmp/"}}, ["core.export.markdown"] = {config = {extension = ".md"}}, ["core.dirman"] = {config = {workspaces = {notes = "~/Documents/neorg"}}}, ["core.mode"] = {}}}, config = _1_}
