return {
  "seblj/roslyn.nvim", -- https://github.com/seblj/roslyn.nvim
  dependencies = {
    "tris203/rzls.nvim", -- https://github.com/tris203/rzls.nvim
  },
  ft = "cs",
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  config = function()
    -- NOTE: to make this work we have to manually install "roslyn" and "rzls" in neovim with :MasonInstall

    local roslyn = require("roslyn")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- pulled from rzls docs
    roslyn.setup({
      config = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.bo[bufnr].tabstop = 4
          vim.bo[bufnr].shiftwidth = 4
          vim.bo[bufnr].expandtab = true
        end,
        handlers = require("rzls.roslyn_handlers"),
      },
      args = {
        "--stdio",
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
