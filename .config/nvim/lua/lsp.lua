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

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }
  buf_set_keymap('n', '<M-d>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<M-f>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<M-h>', '<cmd>Lspsaga hover_doc<CR>', opts)
  buf_set_keymap('n', '<M-i>', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<M-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<M-t>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<M-r>', '<cmd>Lspsaga rename<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<M-q>', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<M-a>', "<cmd>Lspsaga code_action<CR>", opts)
  --
  -- scroll hover doc or scroll in definition preview
  buf_set_keymap('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
  buf_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)
  --
  -- broken:
  -- buf_set_keymap('n', '<M-p>', '<cmd>Lspsaga preview_definition<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<M-F>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<M-F>", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
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
local system_name = 'macOS' -- (Linux, macOS, or Windows)
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
