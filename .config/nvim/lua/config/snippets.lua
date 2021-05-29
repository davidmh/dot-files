local U = require'snippets.utils'
local opts = { noremap=true, silent=false }

local function map(mode, key, cmd)
  vim.api.nvim_set_keymap(mode, key, '<cmd>' .. cmd ..'<CR>', opts)
end

-- <c-k> will either expand the current snippet at the word or try to jump to
-- the next position for the snippet.
map('i', '<c-k>', "lua return require'snippets'.expand_or_advance(1)")

-- <c-j> will jump backwards to the previous field.
-- If you jump before the first field, it will cancel the snippet.
map('i', '<c-j>', "lua return require'snippets'.advance_snippet(-1)")

local function note_snippet(header)
  local S = [[
${-1}(dmejorado): ${=os.date("%Y-%m-%d")} ﹣ $0]]
  S = U.force_comment(S)
  S = U.match_indentation(S)
  return U.iterate_variables_by_id(S, -1, function(v)
    v.default = header
  end)
end

local log = "console.log('DEBUG', { $1 });"

require'snippets'.snippets = {
  _global = {
    date  = [[${=os.date("%Y-%m-%d")}]];
    epoch = "${=os.time()}";
    todo  = note_snippet "TODO";
    fixme = note_snippet "FIXME";
  };
  typescript = { log = log };
  typescriptreact = { log = log };
  tsx = { log = log };
}
