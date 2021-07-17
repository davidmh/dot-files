local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local telescope = require('telescope')
local themes = require('telescope.themes')
local utils = require('telescope.utils')
local putils = require('telescope.previewers.utils')

local defaulter = utils.make_default_callable

telescope.setup {
  defaults = {
    layout_config = {
      prompt_position = 'top',
    },
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

-- Yank the selected commit into the default registry
local function git_yank_commit(prompt_bufnr)
  local selection = action_state.get_selected_entry()

  actions.close(prompt_bufnr)
  vim.cmd(string.format([[let @@='%s']], selection.value))
end

-- Open the selected commit in the platform hosting the remote. Depends on
-- vim-fugitive
local function git_browse()
  vim.cmd('GBrowse ' .. action_state.get_selected_entry().value)
end

local git_commit_diff = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, _)
      putils.job_maker({ 'git', '--no-pager', 'show', entry.value .. '^!' }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd
      })
      putils.regex_highlighter(self.state.bufnr, 'git')
    end
  }
end, {})

function _G.telescope_git_log(opts)
  opts = opts or {}
  local path = opts.path or '.'
  local limit = opts.limit or 2000 -- large logs get slow past this point
  local revision_range = opts.revision_range or 'HEAD'
  local path_in_title = opts.path and ' -- ' .. path or ''

  local results = utils.get_os_command_output({
    'git', 'log', '--pretty=oneline', '--abbrev-commit', string.format('-n%s', limit), revision_range, '--', path
  }, opts.cwd)

  pickers.new(themes.get_ivy(opts), {
    prompt_title = 'git log' .. path_in_title,
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_git_commits(opts),
    },
    previewer = git_commit_diff.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(git_view_commit 'Gtabedit')
      map('i', '<C-x>', git_view_commit 'Gsplit')
      map('n', '<C-x>', git_view_commit 'Gsplit')
      map('i', '<C-v>', git_view_commit 'Gvsplit')
      map('n', '<C-v>', git_view_commit 'Gvsplit')

      map('i', '<C-y>', git_yank_commit)
      map('n', '<C-y>', git_yank_commit)

      map('i', '<C-b>', git_browse)
      map('n', '<C-b>', git_browse)

      map('i', '<C-f>', git_fixup)
      map('n', '<C-f>', git_fixup)
      return true
    end
  }):find()
end
