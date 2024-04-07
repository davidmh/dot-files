-- [nfnl] Compiled from fnl/plugins/remix.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local cmp = autoload("cmp")
local remix_authors = autoload("remix.git-co-authors")
local remix_utils = autoload("remix.utils")
vim.api.nvim_create_augroup("remix-git-commit", {clear = true})
local source
local function _2_()
  return remix_utils.is_remix_buffer()
end
local function _3_()
  return "remix-authors"
end
local function _4_()
  return {"Co-authored-by: "}
end
local function _5_(_, _0, cb)
  local function _6_(_241)
    return {label = _241, insertText = _241, filterText = _241}
  end
  return cb({items = vim.tbl_map(_6_, remix_authors.get())})
end
source = {is_available = _2_, get_debug_name = _3_, get_trigger_characters = _4_, complete = _5_}
local function set_co_author_source()
  if remix_utils.is_remix_buffer() then
    cmp.register_source("remix-authors", source)
    return cmp.setup.buffer({sources = cmp.config.sources({{name = "remix-authors"}, {name = "luasnip"}, {name = "emoji"}})})
  else
    return nil
  end
end
local function config()
  return vim.api.nvim_create_autocmd("FileType", {group = "remix-git-commit", pattern = "gitcommit", callback = set_co_author_source})
end
return {"remix.nvim", dir = "$REMIX_HOME/.nvim", dependencies = {"hrsh7th/nvim-cmp"}, name = "remix", opts = {}, config = config}
