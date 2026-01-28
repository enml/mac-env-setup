-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local function map(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

--Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

--Enable mouse mode
--vim.o.mouse = 'a'

vim.g.mapleader = ","

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

--Set colorscheme
vim.o.termguicolors = true
--vim.cmd [[colorscheme nord]]
vim.cmd([[colorscheme onedark]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

--fold
vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- need keep order
require("mason").setup()

require("ufo").setup()

-- Set trouble
require("trouble").setup({
	win = {
		position = "left",
		width = 150,
	},
	modes = {
		mydiags = {
			mode = "diagnostics",
			filter = {
				any = {
					{
						severity = vim.diagnostic.severity.ERROR, -- errors only
						function(item)
							return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
						end,
					},
				},
			},
		},
	},
})

--Set statusbar
require("lualine").setup({
	options = {
		icons_enabled = false,
		--theme = 'nord',
		theme = "onedark",
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_a = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = true, -- Display new file status (new file means no write after created)
				path = 1, -- 0: Just the filename
				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
					newfile = "[New]", -- Text to show for new created file before first writting
				},
			},
		},
	},
})

--Enable Comment.nvim
require("Comment").setup()

--Remap for dealing with word wrap
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]])

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

-- Diagnostic keymaps
map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")

-- LSP settings
-- mason-lspconfig expects `mason-registry.refresh(cb)` to call `cb(success, updated_registries)`.
-- Older mason.nvim versions call `cb(success, result)` where `result` is nil, which breaks mason-lspconfig.
-- Shim the callback signature to avoid startup errors; best fix is updating mason.nvim + mason-lspconfig.nvim together.
do
	-- Ensure mason is initialized before mason-lspconfig, and make sure mason-installed
	-- executables (like `typescript-language-server`) are on PATH.
	local mason_ok = pcall(require, "mason")
	if mason_ok then
		require("mason").setup()
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		if vim.fn.isdirectory(mason_bin) == 1 then
			local path = vim.env.PATH or ""
			if not string.find(path, mason_bin, 1, true) then
				vim.env.PATH = mason_bin .. ":" .. path
			end
		end
	end

	local ok, registry = pcall(require, "mason-registry")
	if ok and type(registry.refresh) == "function" then
		local refresh = registry.refresh
		registry.refresh = function(cb)
			if type(cb) ~= "function" then
				return refresh(cb)
			end
			return refresh(function(success, _result)
				cb(success, {})
			end)
		end
	end
end

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "ts_ls", "markdown_oxide", "yamlls", "biome" },
})

local on_attach = function(_, bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, buffer = bufnr })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr })
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>so",
		[[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
		opts
	)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		vim.lsp.buf.format({ bufnr = bufnr })
	end, {})

	local format_group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = format_group,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ bufnr = bufnr })
		end,
	})
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	-- Enable the following language servers
	local servers = { "lua_ls", "ts_ls", "markdown_oxide", "yamlls", "biome" }
	for _, lsp in ipairs(servers) do
		vim.lsp.config(lsp, {
			on_attach = on_attach,
			capabilities = capabilities,
	})
	vim.lsp.enable(lsp)
end

-- luasnip setup --
local luasnip = require("luasnip")

-- nvim-cmp setup --
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
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
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- nvim-tree --
local function tree_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "<C-e>", api.tree.toggle, opts("toggle"))
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 40,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
		git_ignored = true,
	},
	git = {
		enable = true,
	},
	diagnostics = {
		enable = true,
	},
	update_focused_file = {
		update_root = true,
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	on_attach = tree_on_attach,
})
map("n", "<C-e>", "<cmd>NvimTreeToggle<CR>")
map("n", "<leader>n", "<cmd>NvimTreeFindFile<CR>")

-- Comment --

-- # NORMAL mode
-- Linewise toggle current line using C-/
map("n", "<C-_>", '<CMD>lua require("Comment.api").toggle.linewise()<CR>')
-- Linewise toggle using C-/
map("x", "<C-_>", '<ESC><CMD>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>')

-- auto-pairs --
require("nvim-autopairs").setup()

-- trouble.nvim --
-- Lua
map("n", "<leader>xx", "<cmd>Trouble<cr>")
map("n", "<leader>xw", "<cmd>Trouble diagnostics<cr>")
map("n", "<leader>xd", "<cmd>Trouble diagnostics document symbols<cr>")
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
map("n", "<leader>gr", "<cmd>Trouble lsp_references<cr>")

-- telescope to trouble
local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open
local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<c-t>"] = open_with_trouble,
				["<C-s>"] = actions.select_horizontal, -- Open in horizontal split
				["<C-v>"] = actions.select_vertical, -- Open in vertical split
			},
			n = {
				["<c-t>"] = open_with_trouble,
				["<C-s>"] = actions.select_horizontal, -- Open in horizontal split
				["<C-v>"] = actions.select_vertical, -- Open in vertical split
			},
		},
	},
})

-- Enable telescope fzf native
require("telescope").load_extension("fzf")

--Add leader shortcuts
map("n", "<leader><space>", [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
map("n", "<C-p>", [[<cmd>lua require('telescope.builtin').find_files({previewer = false, hidden = false})<CR>]])
map("n", "<leader>sb", [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
map("n", "<leader>sh", [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
map("n", "<leader>st", [[<cmd>lua require('telescope.builtin').tags()<CR>]])
map("n", "<leader>sd", [[<cmd>lua require('telescope.builtin').grep_string()<CR>]])
map("n", "<leader>f", [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
map("n", "<leader>so", [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]])
map("n", "<leader>?", [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])

-- none-ls (formerly null-ls)
-- Note: this is not a mason-lspconfig server, so `:LspStart null-ls` will fail with "invalid server name".
do
	local ok, null_ls = pcall(require, "null-ls")
	if ok then
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local eslint_source
		do
			local eslint_ok, eslint = pcall(require, "none-ls.diagnostics.eslint") -- from none-ls-extras.nvim
			if eslint_ok then
				eslint_source = eslint
			elseif null_ls.builtins and null_ls.builtins.diagnostics and null_ls.builtins.diagnostics.eslint then
				eslint_source = null_ls.builtins.diagnostics.eslint
			end
		end

		local sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.completion.spell,
			null_ls.builtins.formatting.prettier.with({
				-- Only use Prettier if a config file is found
				condition = function(utils)
					return utils.root_has_file({
						".prettierrc",
						".prettierrc.json",
						".prettierrc.js",
					})
				end,
				extra_args = { "--use-tabs=false", "--tab-width=2" },
			}),
		}
		if eslint_source then
			table.insert(sources, eslint_source)
		end

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		})
	end
end

--
map("n", "<leader>cp", "<cmd>let @+=expand('%')<cr>") --copy current file path
map("n", "<leader>gb", "<cmd>Git blame<cr>") -- git blame

--
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "tact" },
	sync_install = false,
	auto_install = true,
	ignore_install = { "javascript" },
	highlight = {
		enable = true,
		disable = { "c", "rust" },
		additional_vim_regex_highlighting = false,
	},
})

---
vim.filetype.add({
	extension = {
		tact = "tact",
	},
})
