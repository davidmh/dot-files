-- ALE
vim.g.ale_disable_lsp = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_completion_autoimport = 1
vim.g.ale_javascript_eslint_use_global = 1
vim.g.ale_set_highlights = 0
vim.g.ale_echo_msg_error_str = ''
vim.g.ale_echo_msg_warning_str = ''
vim.g.ale_javascript_eslint_executable = 'eslint_d'
vim.g.ale_echo_msg_format = '%severity% [%linter% %code%] %s'
vim.g.ale_linters_ignore = {'deno', 'lessc', 'standard', 'tslint', 'typecheck', 'xo'}
vim.g.ale_fixers = {
  ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
  javascript = {'eslint'},
  typescript = {'eslint'},
  typescriptreact = {'eslint'},
}

vim.g.switch_mapping = '!'
vim.g.netrw_banner = 0
