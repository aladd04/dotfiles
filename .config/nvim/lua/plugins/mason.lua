return {
  "mason-org/mason.nvim",
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ensure_installed = {
      "angular-language-server",
      "bash-language-server",
      "clangd",
      "css-lsp",
      "dockerfile-language-server",
      "gopls",
      "html-lsp",
      "typescript-language-server",
      "json-lsp",
      "lua-language-server",
      "markdown-oxide",
      "powershell-editor-services",
      "pyright",
      "rust-analyzer",
      "sqls",
      "terraform-ls",
      "taplo", -- toml
      "vim-language-server",
      "lemminx", -- xml
    },
  },
}
