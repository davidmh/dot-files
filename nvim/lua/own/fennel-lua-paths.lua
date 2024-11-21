-- [nfnl] Compiled from fnl/own/fennel-lua-paths.fnl by https://github.com/Olical/nfnl, do not edit.
local join
local function _1_(_241)
  return table.concat(_241, ",")
end
join = _1_
local function setup()
  local function _2_(_241)
    return join({_241, (_241 .. "/fnl"), (_241 .. "/lua")})
  end
  vim.bo.path = join(vim.tbl_map(_2_, vim.opt.rtp:get()))
  vim.bo.suffixesadd = join({".fnl", "/init.fnl", ".lua", "/init.lua"})
  vim.bo.includeexpr = "tr(v:fname, '.', '/')"
  return nil
end
return {setup = setup}
