return {
  "mason-org/mason.nvim",
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ensure_installed = {
      "bash-language-server",
      "lemminx", -- xml
      "powershell-editor-services",
      "roslyn",
    },
  },
}
