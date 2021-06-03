local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

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
