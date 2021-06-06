local wk = require("which-key")

local cmd = function(expression, description)
  return { '<cmd>' .. expression .. '<cr>', description }
end

-- normal mode mappings
wk.register({
  f = cmd([[lua _G.telescope_file_browser()]], 'file browser'),
  -- finders
  ["<leader>"] = cmd('Telescope find_files theme=get_ivy', 'find files'),
  lg = cmd('Telescope live_grep theme=get_ivy', 'live grep'),
  sw = cmd('Telescope grep_string theme=get_ivy', 'search word under cursor'),

  -- buffers
  b = {
    name = 'buffer',
    b = cmd('Telescope buffers theme=get_ivy', 'buffer list'),
    k = cmd('bprevious <bar> bdelete #', 'kill buffer'),
    o = cmd('BufOnly', 'kill other buffers')
  },

  -- git mappings
  g = {
    name = 'git',
    s = cmd('Git', 'git status'),
    c = cmd('Telescope git_branches theme=get_ivy', 'checkout branch'),
    w = cmd('Gwrite', 'write into the git tree'),
    r = cmd('Gread', 'read from the git tree'),
    e = cmd('Gedit', 'edit from the git tree'), -- open the latest committed version of the current file
    b = cmd('Git blame', 'blame'),
    d = cmd('Gdiff', 'diff'),
    l = cmd('lua _G.telescope_git_log()', 'log'),
    L = cmd('lua _G.telescope_git_log({ current_buffer = true })', 'buffer log'),
    B = cmd('GBrowse', 'open in remote service'),
    f = cmd('GFixup', 'fixup staged changes'),
    ['[h'] = cmd('Gitsigns prev_hunk', 'prev hunk'),
    [']h'] = cmd('Gitsigns next_hunk', 'next hunk'),
    h = {
      name = 'hunk',
      s = cmd('Gitsigns stage_hunk', 'stage'),
      u = cmd('Gitsigns undo_stage_hunk', 'unstage'),
      r = cmd('Gitsigns reset_hunk', 'reset'),
      p = cmd('Gitsigns preview_hunk', 'reset'),
      b = cmd('Gitsigns blame_line', 'blame line'),
    }
  },

  -- tmux runner
  r = {
    name = 'runner',
    F = cmd('VtrFlushCommand', 'flush'),
    a = cmd('VtrAttachToPane', 'attach to pane'),
    c = cmd('VtrClearRunner', 'clear'),
    f = cmd('VtrFocusRunner', 'focus'),
    k = cmd('VtrKillRunner', 'kill'),
    o = cmd('VtrOpenRunner', 'open'),
    s = {
      name = 'send',
      c = cmd('VtrSendCommandToRunner', 'command'),
      f = cmd('VtrSendFile', 'file'),
      l = cmd('VtrSendLinesToRunner', 'lines'),
    },

  }
}, { prefix = '<leader>'})

-- visual mode mappings
wk.register({
  g = {
    name = 'git',
    b = cmd('GBrowse', 'browse in remote'),
  },
}, { prefix = '<leader>', mode = 'v' })


-- On-demand OS clipboard sharing
--
-- Creates a map of handful of actions to share with
-- the system clipbpard using the + registry.
--
-- It would be the equivalent of mapping all the
-- iterations of the actions in normal and visual mode
-- and their uppercase versions
local shared_actions = {
  y = {name = 'yank',   dir = 'into'},
  x = {name = 'delete', dir = 'into'},
  p = {name = 'paste',  dir = 'from'},
  c = {name = 'change', dir = 'into'}
}

local os_clipboard = function(action, name, direction)
  return {
    '"+' .. action,
    name .. ' ' .. direction .. ' the OS clipboard'}
end

local os_mappings = {}

for action, data in pairs(shared_actions) do
  local Action = string.upper(action)
  os_mappings[action] = os_clipboard(action, data.name, data.dir)
  os_mappings[Action] = os_clipboard(Action, string.upper(data.name), data.dir)
end

wk.register(os_mappings, { prefix = '<leader>', mode = 'n' })
wk.register(os_mappings, { prefix = '<leader>', mode = 'v' })

-- native overrides
wk.register({
  ZZ = cmd([[call v:lua.confirm_quit(v:true)]], 'save and quit'),
  ZQ = cmd([[call v:lua.confirm_quit(v:false)]], 'discard and quit')
})
