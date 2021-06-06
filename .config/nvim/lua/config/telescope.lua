local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local telescope = require('telescope')
local themes = require('telescope.themes')
local utils = require('telescope.utils')

telescope.setup {
  defaults = {
    prompt_position = 'top',
    sorting_strategy = 'ascending',
  },
}

function _G.telescope_file_browser(path)
  builtin.file_browser(themes.get_ivy({
    depth = 3,
    cwd = path,
  }))
end

-- Creates a fixup using the selected commit. Assumes there are staged files to
-- be committed.
local function git_fixup(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local cwd = current_picker.cwd

  local confirmation = vim.fn.input('Fixup staged files into ' .. selection.value .. '? [Y/n] ')
  if confirmation ~= '' and string.lower(confirmation) ~= 'y' then return end

  actions.close(prompt_bufnr)

  local fixup_cmd = {'git', 'commit', '--fixup', selection.value}

  local output, ret = utils.get_os_command_output(fixup_cmd, cwd)
  local results = ret == 0 and output or {'Nothing to fixup, have you staged your changes?'}

  vim.fn.setqflist(results, 'r', { title = table.concat(fixup_cmd, ' ') })
  vim.cmd('copen')
end

-- Open the selected commit using a fugitive command
local function git_view_commit(target)
  return function(prompt_bufnr)
    local selection = action_state.get_selected_entry()

    actions.close(prompt_bufnr)
    vim.cmd(target .. ' ' .. selection.value)
  end
end

-- Open the selected commit in the platform hosting the remote. Depends on
-- vim-fugitive
local function git_browse()
  vim.cmd('GBrowse ' .. action_state.get_selected_entry().value)
end

function _G.telescope_git_log(opts)
  opts = opts or {}

  local picker = opts.current_buffer and 'git_bcommits' or 'git_commits'
  local log_path = opts.current_buffer and ' -- ' .. vim.fn.expand('%') or ''

  builtin[picker](themes.get_ivy({
    prompt_title = 'git log' .. log_path,
    attach_mappings = function(_, map)
      map('i', '<CR>', git_view_commit 'Gtabedit')
      map('n', '<CR>', git_view_commit 'Gtabedit')
      map('i', '<C-x>', git_view_commit 'Gsplit')
      map('n', '<C-x>', git_view_commit 'Gsplit')
      map('i', '<C-v>', git_view_commit 'Gvsplit')
      map('n', '<C-v>', git_view_commit 'Gvsplit')

      map('i', '<C-b>', git_browse)
      map('n', '<C-b>', git_browse)

      map('i', '<C-f>', git_fixup)
      map('n', '<C-f>', git_fixup)
      return true
    end
  }))
end
