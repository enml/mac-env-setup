local lsp_installer = require "nvim-lsp-installer"

-- Include the servers you want to have installed by default below
local servers = {
	"bashls",
	"html",
	"cssls",
	"eslint",
	"jsonls",
	"sumneko_lua",
	"prosemd_lsp",
	"vimls",
	"tsserver",
	"vuels",
	"yamlls",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    server:install()
  end
end

