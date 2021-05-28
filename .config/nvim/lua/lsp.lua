require('lspinstall').setup()
local lsp_config = require 'lspconfig'
local saga = require 'lspsaga'
local lsp_status = require 'lsp-status'

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
  local function vnoremap(key, exp)
    vim.api.nvim_buf_set_keymap(bufnr, 'v', key, '<cmd>' .. exp .. '<cr>', { noremap=true, silent = true})
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
  nnoremap('[d', '<cmdvim.lsp.diagnostic.goto_prev()')
  nnoremap(']d', '<cmdvim.lsp.diagnostic.goto_next()')
  nnoremap('<M-q>', 'lua vim.lsp.diagnostic.set_loclist()')
  nnoremap('<M-a>', "Lspsaga code_action")
  --
  -- scroll hover doc or scroll in definition preview
  nnoremap('<C-f>', "lua require('lspsaga.action').smart_scroll_with_saga(1)")
  nnoremap('<C-b>', "lua require('lspsaga.action').smart_scroll_with_saga(-1)")

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    nnoremap("<M-F>", "lua vim.lsp.buf.formatting()")
  end
  if client.resolved_capabilities.document_range_formatting then
    vnoremap('<M-F>', 'lua vim.lsp.buf.range_formatting()')
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "solargraph", "tsserver", "python", "vim" }
for _, lsp in ipairs(servers) do
  lsp_config[lsp].setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
  }
end

-- lua needs some custom settings to provide context on the vim API
local system_name = 'macOs'
local sumneko_root_path = vim.fn.stdpath('data') .. '/lspinstall/lua/sumneko-lua/extension/server/'
local sumneko_binary = sumneko_root_path..'/bin/' .. system_name .. '/lua-language-server'
lsp_config.sumneko_lua.setup({
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
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
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    }
  },
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
})
