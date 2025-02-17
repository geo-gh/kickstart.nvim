-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- [[ Basic Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.api.nvim_set_keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.api.nvim_set_keymap(
  'n',
  '<leader>q',
  '<cmd>lua vim.diagnostic.setloclist()<CR>',
  { noremap = true, silent = true, desc = 'Open diagnostic [Q]uickfix list' }
)

-- Exit terminal mode
vim.api.nvim_set_keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })

-- Split navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w><C-h>', { noremap = true, silent = true, desc = 'Move focus to the left window' })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w><C-l>', { noremap = true, silent = true, desc = 'Move focus to the right window' })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w><C-j>', { noremap = true, silent = true, desc = 'Move focus to the lower window' })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w><C-k>', { noremap = true, silent = true, desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  -- Add your plugins here
  'tanvirtin/monokai.nvim',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'ui-select'

      local builtin = require 'telescope.builtin'
      vim.api.nvim_set_keymap('n', '<leader>sh', '<cmd>lua builtin.help_tags()<CR>', { noremap = true, silent = true, desc = '[S]earch [H]elp' })
      vim.api.nvim_set_keymap('n', '<leader>sk', '<cmd>lua builtin.keymaps()<CR>', { noremap = true, silent = true, desc = '[S]earch [K]eymaps' })
      vim.api.nvim_set_keymap('n', '<leader>sf', '<cmd>lua builtin.find_files()<CR>', { noremap = true, silent = true, desc = '[S]earch [F]iles' })
      vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>lua builtin.builtin()<CR>', { noremap = true, silent = true, desc = '[S]earch [S]elect Telescope' })
      vim.api.nvim_set_keymap('n', '<leader>sw', '<cmd>lua builtin.grep_string()<CR>', { noremap = true, silent = true, desc = '[S]earch current [W]ord' })
      vim.api.nvim_set_keymap('n', '<leader>sg', '<cmd>lua builtin.live_grep()<CR>', { noremap = true, silent = true, desc = '[S]earch by [G]rep' })
      vim.api.nvim_set_keymap('n', '<leader>sd', '<cmd>lua builtin.diagnostics()<CR>', { noremap = true, silent = true, desc = '[S]earch [D]iagnostics' })
      vim.api.nvim_set_keymap('n', '<leader>sr', '<cmd>lua builtin.resume()<CR>', { noremap = true, silent = true, desc = '[S]earch [R]esume' })
      vim.api.nvim_set_keymap(
        'n',
        '<leader>s.',
        '<cmd>lua builtin.oldfiles()<CR>',
        { noremap = true, silent = true, desc = '[S]earch Recent Files ("." for repeat)' }
      )
      vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>lua builtin.buffers()<CR>', { noremap = true, silent = true, desc = '[ ] Find existing buffers' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'j-hui/fidget.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- LSP configuration
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby', 'cpp' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = [[<c-\>]],
      direction = 'float',
      border = 'curved',
    },
  },
}
