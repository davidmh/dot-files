-- [nfnl] Compiled from fnl/plugins/hydra.fnl by https://github.com/Olical/nfnl, do not edit.
local venn_hint = "\n     Arrow^^^^^^   Select region with <C-v>^^^^^^^^^^^^^^^^\n     ^ ^ _K_ ^ ^   _b_: Surround with box ^ ^ ^ ^ ^ ^ ^ ^ ^\n     _H_ ^ ^ _L_   _<C-h>_: \226\151\132, _<C-j>_: \226\150\188\n     ^ ^ _J_ ^ ^   _<C-k>_: \226\150\178, _<C-l>_: \226\150\186   _<C-c>_: exit  \n\n"
local function config()
  local hydra = require("hydra")
  local function _1_()
    vim.wo.virtualedit = "all"
    return nil
  end
  return hydra({name = "Draw utf-8 diagrams", hint = venn_hint, config = {color = "pink", invoke_on_body = true, on_enter = _1_}, mode = "n", body = "<leader>ve", heads = {{"<C-h>", "xi<C-v>u25c4<Esc>"}, {"<C-j>", "xi<C-v>u25bc<Esc>"}, {"<C-k>", "xi<C-v>u25b2<Esc>"}, {"<C-l>", "xi<C-v>u25ba<Esc>"}, {"H", "<C-v>h:VBox<CR>"}, {"J", "<C-v>j:VBox<CR>"}, {"K", "<C-v>k:VBox<CR>"}, {"L", "<C-v>l:VBox<CR>"}, {"b", ":VBox<CR>", {mode = "v"}}, {"<C-c>", nil, {exit = true}}}})
end
return {"nvimtools/hydra.nvim", config = config, dependencies = {"jbyuki/venn.nvim"}}
