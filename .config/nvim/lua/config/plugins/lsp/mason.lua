return {
  "williamboman/mason.nvim", -- https://github.com/williamboman/mason.nvim
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- https://github.com/williamboman/mason-lspconfig.nvim
  },
  config = function()
    local mason = require("mason")
    local mason_lsp = require("mason-lspconfig")

    mason.setup({})

    mason_lsp.setup({
      -- language servers to install or use, many may have pre-reqs to install in order to use
      ensure_installed = {
        "angularls",
        "azure_pipelines_ls",
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "gopls",
        "graphql",
        "html",
        "ts_ls",
        "jsonls",
        "lua_ls",
        "markdown_oxide",
        -- "nginx_language_server",
        "powershell_es",
        "pyright",
        "rust_analyzer",
        "sqls",
        "terraformls",
        "taplo",
        "vimls",
        "lemminx",
        "yamlls",
      },
    })
  end
}
