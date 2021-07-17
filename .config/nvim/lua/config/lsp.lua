local lsp_install = require('lspinstall')
local lsp_config = require 'lspconfig'
local saga = require 'lspsaga'
local lsp_status = require 'lsp-status'

lsp_install.setup()

local on_attach = function(client, bufnr)
  saga.init_lsp_saga {
    code_action_prompt = { enable = false },
    rename_prompt_prefix = '✎',
    border_style = 'round'
  }
  lsp_status.config {
    component_separator = ' ',
    indicator_ok = ' ',
    status_symbol = '',
    -- not working?
    spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'},
  }
  lsp_status.register_progress()
  lsp_status.on_attach(client)

  local function nnoremap(key, exp)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, '<cmd>' .. exp .. '<cr>', { noremap=true, silent = true})
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  nnoremap('<M-d>', 'lua vim.lsp.buf.definition()')
  nnoremap('<M-f>', 'lua vim.lsp.buf.references()')
  nnoremap('<M-h>', 'Lspsaga hover_doc')
  nnoremap('<M-i>', 'lua vim.lsp.buf.implementation()')
  nnoremap('<M-k>', 'lua vim.lsp.buf.signature_help()')
  nnoremap('<M-t>', 'lua vim.lsp.buf.type_definition()')
  nnoremap('<M-r>', 'Lspsaga rename')
  nnoremap('<M-q>', 'lua vim.lsp.diagnostic.set_loclist()')
  nnoremap('<M-a>', 'Lspsaga code_action')
  nnoremap('[d',    'lua vim.lsp.diagnostic.goto_prev()')
  nnoremap(']d',    'lua vim.lsp.diagnostic.goto_next()')
  --
  -- scroll hover doc or scroll in definition preview
  nnoremap('<C-f>', "lua require('lspsaga.action').smart_scroll_with_saga(1)")
  nnoremap('<C-b>', "lua require('lspsaga.action').smart_scroll_with_saga(-1)")
end

local function setup()
  -- returns all the lsp servers installed with:
  -- `:LspInstall <server_name>`
  local servers = require'lspinstall'.installed_servers()

  for _, lsp in ipairs(servers) do
    lsp_config[lsp].setup {
      on_attach = on_attach,
      capabilities = lsp_status.capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim', 'use'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
          },
          -- Do not send telemetry data
          telemetry = { enable = false }
        }
      },
    }
  end
end

setup()

-- Automatically reload after `:LspInstall <server_name>` so we don't have to restart neovim
lsp_install.post_install_hook = function ()
  setup() -- reload installed servers
  vim.cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
end
