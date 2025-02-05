-- Syntastics
vim.cmd([[
set statusline+=%#warningmsg#
set statusline+=%*
]])

vim.g.syntastic_always_populate_loc_list = 1
vim.g.syntastic_auto_loc_list = 1
vim.g.syntastic_check_on_open = 1
vim.g.syntastic_check_on_wq = 0

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- YGZ Customizations
  use {"ellisonleao/glow.nvim"}  -- Markdown previewer, use as :Glow
  use { "ahmedkhalf/project.nvim", config = function() require("project_nvim").setup {} end }  -- Project manager for NeoVim
  use 'nvim-telescope/telescope-file-browser.nvim'  -- Telescope file browser
  use 'kshenoy/vim-signature'  -- Use to see marks
  use 'glepnir/dashboard-nvim'  -- Dashboard for neovim
  use 'ryanoasis/vim-devicons'  -- File icons for neovim
  use 'preservim/nerdtree'  -- NERDTree <C-t> to toggle
  use 'Xuyuanp/nerdtree-git-plugin'  -- Shows git status on NERDTree
  use 'johnstef99/vim-nerdtree-syntax-highlight'  -- Highlights file names according to the file type
  use 'tpope/vim-commentary'  -- "gcc" to comment stuff out
  use 'wakatime/vim-wakatime'  -- For wakatime integration
  use 'prisma/vim-prisma'  -- Prisma lsp
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }  -- Replaces the default bottomline
  use 'tpope/vim-surround'  -- Change inner surround
  use 'ap/vim-css-color'  -- CSS color highlighting
  use 'airblade/vim-gitgutter' -- Shows git differences
  use 'folke/tokyonight.nvim' -- TokyoNight Theme
  use 'jiangmiao/auto-pairs'  -- Auto pairs for parantheses
  use 'windwp/nvim-ts-autotag'  -- Autochange the pairs
  use 'jose-elias-alvarez/null-ls.nvim'  -- Required for prettier
  use 'MunifTanjim/prettier.nvim'  -- Prettier addon
  use 'nvim-tree/nvim-web-devicons'  -- Tab bar icons
  use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}  -- Tab bar
  use 'manzeloth/live-server'  -- Live server plugin, use as :LiveServer start/stop
  use 'sirver/ultisnips'  -- Snippets
  use 'mbbill/undotree'  -- Undo Tree
  use 'jghauser/mkdir.nvim'  -- Create new dir if file not existing
  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        auto_save_enabled = true,
        auto_restore_enabled = true,
      }
    end
  }
  use {
  "folke/which-key.nvim",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
  use {
    'yagiziskirik/AirSupport.nvim',

    requires = {
      {'nvim-telescope/telescope.nvim'},
      {'nvim-lua/plenary.nvim'},
    }
  }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme tokyonight]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('ibl').setup {
  indent = { char = '┊' },
  whitespace = { remove_blankline_trail = true },
  exclude = { filetypes = { "dashboard" } }
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope file_browser
require('telescope').load_extension('file_browser')

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aP'] = '@assignment.outer',
        ['iP'] = '@assignment.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  autotag = {
    enable = true,
  }
}

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  -- sumneko_lua = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --   },
  -- },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et


-- YGZ Side of things
vim.cmd [[
  autocmd BufNewFile,BufRead *.ejs set filetype=html
]]

-- Null-ls setup
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>dq", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>dq", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

-- Prettier setup
local prettier = require("prettier")

prettier.setup({
  bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

-- Bufferline setup
require 'bufferline'.setup {
  icons = {
    button = '✕',
    pinned = {
      button = '📍'
    }
  }
}

-- Lualine setup
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {lualine_c = {require('auto-session.lib').current_session_name}}
}

-- Project.nvim configuration
require('telescope').load_extension('projects')

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.syntax = 'on'
vim.opt.compatible = false
vim.opt.filetype = 'on'
vim.opt.filetype.plugin = 'on'
vim.opt.filetype.indent = 'on'
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.history = 1000
vim.opt.wildmenu = true
vim.opt.wildmode = 'list:longest'
vim.opt.background = 'dark'
vim.opt.backspace = 'indent,eol,start'
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false


-- Remap Functions
local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function imap(shortcut, command)
  map('i', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
end

local function cmap(shortcut, command)
  map('c', shortcut, command)
end

local function xmap(shortcut, command)
  map('x', shortcut, command)
end

-- Shortcuts
--
-- Thanks to the Primeagen...
xmap('<leader>p', "\"_dP")  -- Greatest shortcut

-- Next greatest shortcut by asbjornHaland
nmap('<leader>y', "\"+y")
nmap('<leader>Y', "\"+Y")
vmap('<leader>y', "\"+y")

-- Prettier
nmap('<leader>da', "<cmd>Prettier<CR>")

-- Replace the word
nmap('<leader>f', ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Undotree
nmap("<leader>u", ":UndotreeToggle<CR>")  -- Opens up the menu

-- VSCode-like shortcuts
nmap("<A-Down>", ":m .+1<CR>==") -- Moves the line down in normal mode
nmap("<A-Up>", ":m .-2<CR>==") -- Moves the line up in normal mode
vmap('<A-Down>', ":m '>+1<CR>gv=gv")  -- Moves the line down in visual mode
vmap('<A-Up>', ":m '<-2<CR>gv=gv")  -- Moves the line up in visual mode
nmap('<A-S-Down>', 'yyp')  -- Copies the line down in visual mode
nmap('<A-S-Up>', 'yyP')  -- Copies the line up in visual mode
nmap("<A-j>", ":m .+1<CR>==") -- Moves the line down in normal mode
nmap("<A-k>", ":m .-2<CR>==") -- Moves the line up in normal mode
vmap('<A-j>', ":m '>+1<CR>gv=gv")  -- Moves the line down in visual mode
vmap('<A-k>', ":m '<-2<CR>gv=gv")  -- Moves the line up in visual mode
nmap('<A-S-j>', 'yyp')  -- Copies the line down in visual mode
nmap('<A-S-k>', 'yyP')  -- Copies the line up in visual mode

-- Projects shortcuts
nmap('<C-S-p>', '<Cmd>Telescope projects<CR>')

-- Debugging shortcuts
nmap('<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>') -- Prev diagnostic
nmap('<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>')  -- Next diagnostic
nmap('<leader>dd', '<cmd>Telescope diagnostics<CR>')  -- Shows the list of diagnostics
nmap('<leader>df', '<cmd>lua vim.lsp.buf.code_action()<CR>')  -- Fixes errors

-- Telescope
nmap('<C-p>', ':Telescope find_files<CR>')

-- AirSupport shortcut
nmap('<leader>?', '<cmd>AirSupport<CR>')  -- AirSupport Toggle

-- NERDTree settings
nmap('<C-t>', ':NERDTreeToggle<CR>')  -- NERDTree Toggle

-- Buffer type shortcuts for tab navigation
nmap('<C-e>', ':tabnew<CR>')
nmap('<A-S-tab>', '<Cmd>BufferPrevious<CR>')
nmap('<A-tab>', '<Cmd>BufferNext<CR>')
nmap('<Space>1', '<Cmd>BufferGoto 1<CR>')
nmap('<Space>2', '<Cmd>BufferGoto 2<CR>')
nmap('<Space>3', '<Cmd>BufferGoto 3<CR>')
nmap('<Space>4', '<Cmd>BufferGoto 4<CR>')
nmap('<Space>5', '<Cmd>BufferGoto 5<CR>')
nmap('<Space>6', '<Cmd>BufferGoto 6<CR>')
nmap('<Space>7', '<Cmd>BufferGoto 7<CR>')
nmap('<Space>8', '<Cmd>BufferGoto 8<CR>')
nmap('<Space>9', '<Cmd>BufferGoto 9<CR>')
nmap('<Space>0', '<Cmd>BufferLast<CR>')
nmap('<C-q>', '<Cmd>BufferClose<CR>')
nmap('<Space>t', '<Cmd>BufferPin<CR>')

-- Insert mode movement
imap('<C-h>', '<Left>')
imap('<C-j>', '<Down>')
imap('<C-k>', '<Up>')
imap('<C-l>', '<Right>')
cmap('<C-h>', '<Left>')
cmap('<C-j>', '<Down>')
cmap('<C-k>', '<Up>')
cmap('<C-l>', '<Right>')

-- Set wrap in markdownfiles
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {'*.md'},
  command = 'setlocal wrap'
})

-- Load custom treesitter grammar for org filetype
-- require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop,
  -- highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

-- Import dashboard settings
require('dashboard_settings')
