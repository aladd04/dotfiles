return {
  "seblj/roslyn.nvim", -- https://github.com/seblj/roslyn.nvim
  dependencies = {
    "tris203/rzls.nvim", -- https://github.com/tris203/rzls.nvim
  },
  ft = "cs",
  config = function()
    local roslyn = require("roslyn")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- pulled from rzls docs
    roslyn.setup({
      config = {
        capabilities = capabilities,
        on_attach = require("lspattach"),
        handlers = require("rzls.roslyn_handlers"),
      },
      args = {
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(
          vim.fn.stdpath "data" --[[@as string]],
          "mason",
          "packages",
          "roslyn",
          "libexec",
          "Microsoft.CodeAnalysis.Razor.Compiler.dll"
        ),
        "--razorDesignTimePath=" .. vim.fs.joinpath(
          vim.fn.stdpath "data" --[[@as string]],
          "mason",
          "packages",
          "rzls",
          "libexec",
          "Targets",
          "Microsoft.NET.Sdk.Razor.DesignTime.targets"
        ),
      },
    })
  end,
}
