-- [nfnl] fnl/plugins/git.fnl
local function _1_()
  vim.g.fugitive_legacy_commands = false
  return nil
end
return {{"lewis6991/gitsigns.nvim", opts = {current_line_blame = true, signcolumn = true}, config = true}, {"tpope/vim-git", dependencies = {"nvim-lua/plenary.nvim", "lewis6991/gitsigns.nvim"}, event = "VeryLazy"}, {"tpope/vim-fugitive", dependencies = {"tpope/vim-rhubarb"}, init = _1_}, "davidmh/gitattributes.nvim", {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim"}, opts = {disable_hint = true, console_timeout = 100, fetch_after_checkout = true, graph_style = "unicode", remember_settings = true, ignore_settings = {"NeogitPopup--"}, notification_icon = "\238\156\130", recent_commit_count = 15, integrations = {telescope = nil}, auto_close_console = false}, event = "VeryLazy"}}
