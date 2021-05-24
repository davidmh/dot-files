local lsp_status = require('lsp-status')
local condition = require('galaxyline.condition')
local gl = require('galaxyline')
local gls = gl.section

local colors = {
  bg = 'NONE',
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#A3BE8C',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#88C0D0',
  red = '#BF616A'
}

local providers = {}

-- ALE
function providers.ale_diagnostics()
  local ok, data = pcall(vim.fn['ale#statusline#Count'], vim.fn.bufnr())
  if ok then
    return data
  else
    return { error = 0, warning = 0, info =  0 }
  end
end
function providers.ale_error()
  return providers.ale_diagnostics().error
end
function providers.ale_warn()
  return providers.ale_diagnostics().warning
end
function providers.ale_info()
  return providers.ale_diagnostics().info
end

-- looks funky, disabled for now
function providers.lsp_status()
  return lsp_status.status()
end

function providers.mode()
  local mode_color = {n = colors.red, i = colors.green,v=colors.blue,
    [''] = colors.blue,V=colors.blue,
    c = colors.yellow,no = colors.red,s = colors.orange,
    S=colors.orange,[''] = colors.orange,
    ic = colors.yellow,R = colors.violet,Rv = colors.violet,
    cv = colors.red,ce=colors.red, r = colors.cyan,
    rm = colors.cyan, ['r?'] = colors.cyan,
    ['!']  = colors.red,t = colors.red}
  -- auto change color according the vim mode
  local mode = vim.fn.mode()
  vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[mode])
  -- return ' '
  return '▊ '
end

function providers.file_encode()
  local encode = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
  return ' ' .. encode
end
function providers.file_format()
  return vim.bo.fileformat
end

function condition.has_errors()
  return providers.ale_error() > 0
end
function condition.has_warnings()
  return providers.ale_warn() > 0
end
function condition.has_info()
  return providers.ale_info() > 0
end
function condition.show_lsp()
  local hidden_by_ft = {
    ['gitcommit'] = true,
    ['fugitive'] = true,
    ['qf'] = true,
    [''] = true,
  }
  return not hidden_by_ft[vim.bo.filetype]
end
function condition.show_git_branch()
  local hidden_by_ft = {
    ['qf'] = true,
  }
  return not hidden_by_ft[vim.bo.filetype]
end

gls.left[1] = {
  ViMode = {
    provider = providers.mode,
    highlight = {colors.red,colors.bg,'bold'},
  },
}

-- git
gls.left[2] = {
  GitBranch = {
    provider = 'GitBranch',
    separator = ' ',
    condition = condition.show_git_branch,
    highlight = {colors.violet,colors.bg,'bold'},
  }
}
gls.left[3] = {
  DiffAdd = {
    provider = 'DiffAdd',
    icon = '+',
    highlight = {colors.green,colors.bg},
  }
}
gls.left[4] = {
  DiffModified = {
    provider = 'DiffModified',
    icon = '±',
    highlight = {colors.orange,colors.bg},
  }
}
gls.left[5] = {
  DiffRemove = {
    provider = 'DiffRemove',
    icon = '-',
    highlight = {colors.red,colors.bg},
  }
}

-- quickfix title
gls.left[6] = {
  QuickfixTitle = {
    provider = function()
      return vim.w.quickfix_title
    end,
    condition = function()
      return vim.bo.filetype == 'qf'
    end,
    separator = ' ',
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.left[7] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.blue,colors.bg,'bold'}
  }
}

gls.left[8] = {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = condition.show_lsp,
    icon = ' ',
    highlight = {colors.grey,colors.bg,'bold'}
  }
}

-- ALE
gls.right[1] = {
  DiagnosticError = {
    condition = condition.has_errors,
    provider = providers.ale_error,
    icon = 'e:',
    separator = ' ',
    highlight = {colors.red, colors.bg}
  }
}
gls.right[2] = {
  DiagnosticWarn = {
    condition = condition.has_warnings,
    provider = providers.ale_warn,
    icon = 'w:',
    separator = ' ',
    highlight = {colors.yellow,colors.bg},
  }
}
gls.right[3] = {
  DiagnosticInfo = {
    condition = condition.has_info,
    provider = providers.ale_info,
    icon = 'i:',
    separator = ' ',
    highlight = {colors.blue,colors.bg},
  }
}

gls.right[4] ={
  FileIcon = {
    provider = 'FileIcon',
    separator = ' ',
    condition = condition.buffer_not_empty,
    highlight = {colors.grey,colors.bg,'bold'},
  },
}
gls.right[5] = {
  FileEncode = {
    provider = providers.file_encode,
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[6] = {
  FileFormat = {
    provider = providers.file_format,
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}
gls.right[7] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.right[8] = {
  PerCent = {
    provider = 'LinePercent',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg,'bold'},
  }
}
