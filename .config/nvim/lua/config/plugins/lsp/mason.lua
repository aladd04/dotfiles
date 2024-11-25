return {
  "williamboman/mason.nvim", -- https://github.com/williamboman/mason.nvim
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- https://github.com/williamboman/mason-lspconfig.nvim
    -- "tris203/rzls.nvim", -- https://github.com/tris203/rzls.nvim
    -- "seblj/roslyn.nvim", -- https://github.com/seblj/roslyn.nvim
  },
  config = function()
    local mason = require("mason")
    local mason_lsp = require("mason-lspconfig")

    mason.setup({
      registries = {
        "github:mason-org/mason-registry", -- default registry
        "github:Crashdummyy/mason-registry", -- dotnet registry for roslyn and rzls https://github.com/Crashdummyy/mason-registry
        -- "github:seblj/roslyn-mason-registry", -- dotnet registry for roslny, need this too for some reason
      },
    })

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
        "roslyn",
        "rust_analyzer",
        -- "rzls",
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
