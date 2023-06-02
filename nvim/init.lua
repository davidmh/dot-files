local fn = vim.fn
local fmt = string.format

-- disable default vimscript bundled plugins, these load very early
local default_plugins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'matchit',
  'tar',
  'tarPlugin',
  'rrhelper',
  'spellfile_plugin',
  'vimball',
  'vimballPlugin',
  'tutor',
  'rplugin',
  'syntax',
  'synmenu',
  'optwin',
  'compiler',
  'bugreport',
  'ftplugin',
}

for _, plugin in pairs(default_plugins) do
  vim.g['loaded_' .. plugin] = 1
end

-- gem install neovim-ruby
vim.g.ruby_host_prog = '~/.gem/ruby/3.0.6/bin/neovim-ruby-host'
vim.opt.termguicolors = true

-- luarocks support
package.path = string.gsub(vim.fn.system('luarocks path --lr-path'), '\n', ';') .. package.path
package.cpath = package.cpath .. ';.dylib'

local data_path = fn.stdpath('data') .. '/lazy'

--- Ensures a given github.com/USER/REPO is cloned in the lazy directory.
--- @param user string
--- @param repo string
--- @param alias string|nil
local function ensure(user, repo, alias)
  local install_path = fmt('%s/%s', data_path, alias or repo)
  local repo_url = fmt('https://github.com/%s/%s', user, repo)

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--filter=blob:none', '--single-branch', repo_url, install_path })
  end

  vim.opt.runtimepath:prepend(install_path)
end

-- Lazy.nvim as a plugin manager
ensure('folke', 'lazy.nvim')

-- Aniseed compiles Fennel to Lua and loads it automatically.
ensure('Olical', 'aniseed')

ensure('catppuccin', 'nvim', 'catppuccin')

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g['aniseed#env'] = { module = 'own.init' } -- fnl/own/init.fnl
