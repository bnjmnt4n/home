-- LSP

-- TODO: look for inspiration in the following configurations
-- - https://phelipetls.github.io/posts/configuring-eslint-to-work-with-neovim-lsp/
-- - https://elianiva.my.id/post/my-nvim-lsp-setup
-- - https://github.com/lukas-reineke/dotfiles/tree/master/vim/lua/lsp
-- - https://github.com/lucax88x/configs/tree/master/dotfiles/.config/nvim/lua/lt/lsp

local nvim_lsp = require 'lspconfig'

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  })

  local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
  vim.lsp.handlers['textDocument/hover'] = function(...)
    local buf = overridden_hover(...)
    -- TODO: is this correct?
    if buf then
      vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>', { noremap = true, silent = true })
    end
  end
  local overridden_signature_help = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
  vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
    local buf = overridden_signature_help(...)
    -- TODO: is this correct?
    if buf then
      vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>', { noremap = true, silent = true })
    end
  end

  require('which-key').register({
    g = {
      D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration' },
      d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition' },
      i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to implementation' },
      r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'Go to references' },
    },
    K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' },
    ['<C-k>'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Singature help' },
    ['<leader>'] = {
      cr = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename variable' },
      -- TODO: keybindings
      D = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Go to type definition' },
      e = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Show line diagnostics' },
      cl = { '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set location list' },
    },
    ['[d'] = {
      '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" } })<CR>',
      'Previous diagnostic',
    },
    [']d'] = {
      '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" } })<CR>',
      'Next diagnostic',
    },
  }, {
    buffer = bufnr,
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable the following language servers
local servers = { 'clangd', 'rnix', 'zls' }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

nvim_lsp.sumneko_lua.setup {
  cmd = { 'lua-language-server' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Wrapper around non-LSP actions
local null_ls = require 'null-ls'
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.gitsigns,
  },
}

-- TypeScript + ESLint integration
nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    -- Prevent formatting with `tsserver` so `null-ls` can do the formatting
    client.resolved_capabilities.document_formatting = false

    local ts_utils = require 'nvim-lsp-ts-utils'
    ts_utils.setup {
      disable_commands = false,
      enable_import_on_completion = true,
      import_all_timeout = 5000,

      -- ESLint code actions
      eslint_enable_code_actions = true,
      eslint_enable_disable_comments = true,
      eslint_bin = 'eslint_d',
      eslint_enable_diagnostics = true,

      -- Formatting: depends on ESLint + Prettier integration
      enable_formatting = true,
      formatter = 'eslint_d',
    }

    -- Fixes code action ranges
    ts_utils.setup_client(client)

    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Rust
require('rust-tools').setup {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = ' <-',
      other_hints_prefix = ' =>',
    },
  },
  server = {
    on_attach = on_attach,
  },
}
