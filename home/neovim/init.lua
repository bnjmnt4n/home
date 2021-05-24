-- Based on:
-- https://github.com/mjlbach/defaults.nvim/blob/f4611c06493f85450f82aded43b50a14619ae55a/init.lua
-- https://github.com/mjlbach/nix-dotfiles/blob/78c9ca9363107d4e967e5b49e19d86c75e7a3e3a/nixpkgs/configs/neovim/init.lua

-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

-- TODO: remove?
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'       -- Package manager
  use 'tpope/vim-fugitive'           -- Git commands in nvim
  use 'tpope/vim-rhubarb'            -- Fugitive-companion to interact with github
  use 'tpope/vim-commentary'         -- "gc" to comment visual regions/lines
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'ishan9299/modus-theme-vim'    -- Vim ports of Modus Themes
  use 'itchyny/lightline.vim'        -- Fancier statusline
  -- Add indentation guides even on blank lines
  use { 'lukas-reineke/indent-blankline.nvim', branch = "lua" }
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }
  use 'neovim/nvim-lspconfig'        -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-compe'           -- Autocompletion plugin
  use 'justinmk/vim-dirvish'         -- Directory viewer
  use 'direnv/direnv.vim'            -- direnv support
  -- Treesitter configuration
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'windwp/nvim-autopairs'
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  -- Run vim in the browser
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
  use 'norcalli/snippets.nvim'       -- Snippets
  use 'kosayoda/nvim-lightbulb'      -- Lightbulb indication for code actions availability

  -- TODO: review
  use 'tpope/vim-vinegar'
  use 'tpope/vim-surround'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-unimpaired'
  use 'AndrewRadev/splitjoin.vim'
  use 'sheerun/vim-polyglot'
end)

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false

--Incremental search
vim.o.incsearch = true

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.cmd[[set undofile]]

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

--Set colorscheme
vim.o.termguicolors = true
vim.cmd[[colorscheme modus-operandi]]

-- Set statusbar
vim.g.lightline = {
  active = { left = {{'mode', 'paste'}, {'gitbranch', 'readonly', 'filename', 'modified'}} },
  component_function = { gitbranch = 'fugitive#head' },
}

-- firenvim
vim.cmd[[set guifont=Iosevka:h24]]
vim.g.firenvim_config = { localSettings = { ['.*'] = { takeover = 'never' } } }

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Add move line shortcuts
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-j>', ':m \'>+1<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', ':m \'<-2<CR>gv=gv', { noremap = true })

--Remap escape to leave terminal mode
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]], false)

--Add map to enter paste mode
vim.o.pastetoggle="<F3>"

-- Indent guide
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'

--Toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.cmd[[IndentBlanklineDisable]]
    vim.wo.signcolumn = 'no'
    vim.o.mouse = 'v'
    vim.wo.number = false
    print("Mouse disabled")
  else
    vim.cmd[[IndentBlanklineEnable]]
    vim.wo.signcolumn = 'yes'
    vim.o.mouse = 'a'
    vim.wo.number = true
    print("Mouse enabled")
  end
end

vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua ToggleMouse()<CR>', { noremap = true })

--Gitsigns
require('gitsigns').setup({
  signs = {
    add          = { hl = 'GitGutterAdd'   , text = '+' },
    change       = { hl = 'GitGutterChange', text = '~' },
    delete       = { hl = 'GitGutterDelete', text = '_' },
    topdelete    = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  }
})

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
}
require('telescope').load_extension('fzf')

--Add leader shortcuts
vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_commits()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').git_status()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', [[<cmd>lua require('telescope.builtin').git_bcommits()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wb', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cx', [[<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>]], { noremap = true, silent = true })

-- Git shortcuts
vim.api.nvim_set_keymap('n', '<leader>gg', ':Neogit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add %:p<CR><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gdiff<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ge', ':Gedit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gr', ':Gread<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gw', ':Gwrite<CR><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gl', ':silent! Glog<CR>:bot copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gm', ':Gmove<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>go', ':Git checkout<Space>', { noremap = true, silent = true })

-- Alternative shorcuts without telescope
vim.api.nvim_set_keymap('n', '<leader>,', ':buffer *', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':e<space>**/', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':tjump *', { noremap = true })

-- Change preview window location
vim.g.splitbelow = true

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Clear white space on empty lines and end of line
vim.api.nvim_set_keymap('n', '<F6>', [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]], { noremap = true, silent = true })


-- TODO: Remap number increment to alt
vim.api.nvim_set_keymap('n', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-x>', '<C-x>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-x>', '<C-x>', { noremap = true })

-- TODO: n always goes forward
vim.api.nvim_set_keymap('n', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('x', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('o', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('x', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('o', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })

-- TODO
-- Nerdtree like sidepanel
-- absolute width of netrw window
vim.g.netrw_winsize = -28

-- do not display info on the top of window
vim.g.netrw_banner = 0

-- sort is affecting only: directories on the top, files below
-- vim.g.netrw_sort_sequence = '[\/]$,*'

-- variable for use by ToggleNetrw function
vim.g.NetrwIsOpen = 0

-- Lexplore toggle function
ToggleNetrw = function()
  if vim.g.NetrwIsOpen == 1 then
    local i = vim.api.nvim_get_current_buf()
    while i >= 1 do
      if vim.bo.filetype == "netrw" then
        vim.cmd([[silent exe "bwipeout " .]] .. i )
      end
      i = i - 1
    end
    vim.g.NetrwIsOpen = 0
    vim.g.netrw_liststyle = 0
    vim.g.netrw_chgwin = -1
  else
    vim.g.NetrwIsOpen = 1
    vim.g.netrw_liststyle = 3
    vim.cmd([[silent Lexplore]])
  end
end

vim.api.nvim_set_keymap('n', '<leader>d', ':lua ToggleNetrw()<CR><paste>', { noremap = true, silent = true })

-- Function to open preview of file under netrw
vim.api.nvim_exec([[
  augroup Netrw
    autocmd!
    autocmd filetype netrw nmap <leader>; <CR>:wincmd W<cr>
  augroup end
]], false)

-- directory managmeent, including autochdir
vim.cmd[[nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>]]

vim.api.nvim_exec([[
  augroup BufferCD
    autocmd!
    autocmd BufEnter * silent! Glcd
  augroup end
]], false)
-- vim.cmd([[autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()]])

-- snippets.nvim
require'snippets'.use_suggested_mappings()

-- LSP settings
local nvim_lsp = require('lspconfig')

local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      signs = true,
      update_in_insert = true,
    }
  )

  local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/hover"] = function(...)
    local buf = overridden_hover (...)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>', { noremap = true, silent = true })
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnt, 'n', '<leader>ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]], opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable the following language servers
local servers = {
  'clangd', 'rust_analyzer', 'tsserver' --, 'zls'
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- TODO
nvim_lsp.zls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "/home/bnjmnt4n/repos/zls/zig-cache/bin/zls" },
}

FormatRange = function()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  vim.lsp.buf.range_formatting({}, start_pos, end_pos)
end

vim.cmd([[command! -range FormatRange execute 'lua FormatRange()']])

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[command! Format execute 'lua vim.lsp.buf.formatting()']])

-- TODO: re-enable?
-- Was encountering some timer issues which I suspect might be attributable to this
-- vim.cmd[[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noselect,noinsert"

-- Compe setup
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 2,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    nvim_lsp = true,
    nvim_lua = true,
    snippets_nvim = true,
  },
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.g.completion_confirm_key = ""

-- auto-pairs
local npairs = require('nvim-autopairs')
npairs.setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})

_G.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn['compe#confirm'](npairs.esc('<CR>'))
    else
      return npairs.esc("<CR>")
    end
  else
    return npairs.autopairs_cr()
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<CR>", "v:lua.completion_confirm()", { expr = true, noremap = true })

vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { expr = true, silent = true })

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = { "comment", "jsdoc" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}
 
-- Treesitter folding
vim.cmd[[set foldmethod=expr]]
vim.cmd[[set foldexpr=nvim_treesitter#foldexpr()]]
vim.cmd[[set nofoldenable]]
