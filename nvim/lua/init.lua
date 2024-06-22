-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local function map(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

-- configure Neovim to automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

-- Plugins --
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  -- LSP --
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use "jose-elias-alvarez/null-ls.nvim"
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use 'folke/lsp-colors.nvim'
  -- UI --
  use 'arcticicestudio/nord-vim' -- color
  use 'mjlbach/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  -- UI to select things (files, grep results, open buffers...)
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Nvim-tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }
  -- Git --
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' } -- git diff view
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }  -- Add git related info in the signs columns and popups
  -- auto-pairs
  use 'windwp/nvim-autopairs'
  --
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
end)

--Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

--Enable mouse mode
--vim.o.mouse = 'a'

vim.g.mapleader = ','

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true
--vim.cmd [[colorscheme nord]]
vim.cmd [[colorscheme onedark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set trouble
require("trouble").setup {
    position = "left", -- position of the list can be: bottom, top, left, right
    height = 100, -- height of the trouble list when position is top or bottom
    width = 50,
    action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r", -- manually refresh
      jump = {"<cr>", "<tab>", "o"}, -- jump to the diagnostic or open / close folds
      open_split = { "<c-x>" }, -- open buffer in new split
      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      open_tab = { "<c-t>" }, -- open buffer in new tab
      jump_close = { "<c-o>" }, -- jump to the diagnostic and close the list
      toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = "P", -- toggle auto_preview
      hover = "K", -- opens a small popup with the full multiline message
      preview = "p", -- preview the diagnostic location
      close_folds = {"zM", "zm"}, -- close all folds
      open_folds = {"zR", "zr"}, -- open all folds
      toggle_fold = {"zA", "za"}, -- toggle fold of current file
      previous = "k", -- preview item
      next = "j" -- next item
    },
}

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    --theme = 'nord',
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
  lualine_a = {
    {
      'filename',
      file_status = true,      -- Displays file status (readonly status, modified status)
      newfile_status = true,   -- Display new file status (new file means no write after created)
      path = 1,                -- 0: Just the filename
      shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
      symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
        newfile = '[New]',     -- Text to show for new created file before first writting
      }
    }
  }
}
}

--Enable Comment.nvim
require('Comment').setup()

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Diagnostic keymaps
map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

-- LSP settings
-- need keep order
require("mason").setup()
require("mason-lspconfig").setup {
      ensure_installed = { "lua_ls", "tsserver", "markdown_oxide", "yamlls", "biome" },
}

local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup --
local luasnip = require 'luasnip'

-- nvim-cmp setup --
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- nvim-tree --
require'nvim-tree'.setup {
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}
map('n', '<C-e>', '<cmd>NvimTreeToggle<CR>')
map('n', '<leader>n', '<cmd>NvimTreeFindFile<CR>')

-- Comment --

-- # NORMAL mode
-- Linewise toggle current line using C-/
map('n', '<C-_>', '<CMD>lua require("Comment.api").toggle.linewise()<CR>')
-- Linewise toggle using C-/
map('x', '<C-_>', '<ESC><CMD>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>')

-- auto-pairs --
require('nvim-autopairs').setup()

-- trouble.nvim --
-- Lua
map("n", "<leader>xx", "<cmd>Trouble<cr>")
map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
map("n", "<leader>gr", "<cmd>Trouble lsp_references<cr>")

-- telescope to trouble
local actions = require("telescope.actions")
local trouble = require("trouble.sources.telescope")

local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup {
  defaults = {
    mappings = {
      i = { 
        ["<c-t>"] = trouble.open,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
      n = { 
        ["<c-t>"] = trouble.open,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}
--
-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

--Add leader shortcuts
map('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
map('n', '<C-p>', [[<cmd>lua require('telescope.builtin').find_files({previewer = false, hidden = true})<CR>]])
map('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
map('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
map('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]])
map('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]])
map('n', '<leader>f', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
map('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]])
map('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])


-- null-ls
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
    },
})

-- null-ls format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})

--
map("n", "<leader>cp", "<cmd>let @+=expand('%')<cr>") --copy current file path
map("n", "<leader>gb", "<cmd>Git blame<cr>") -- git blame
