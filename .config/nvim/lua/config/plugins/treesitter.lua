return {
  "nvim-treesitter/nvim-treesitter", -- https://github.com/nvim-treesitter/nvim-treesitter
  build = ":TSUpdate", -- installs or updates parsers
  event = { "BufReadPre", "BufNewFile" }, -- load before a file is put into the buffer
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      highlight = {
        enable = true,
        use_languagetree = true, -- support different syntax for embedded languages
      },
      indent = {
        enable = true,
      },
      sync_install = false, -- allow parsers to be installed in the background
      incremental_selection = { -- allows selecting "blocks" or "scopes" of code using keybinds
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      ensure_installed = {
        "angular",
        "bash",
        "c",
        "c_sharp",
        "comment",
        "cpp",
        "csv",
        "diff",
        "dockerfile",
        "editorconfig",
        "gitignore",
        "go",
        "graphql",
        "helm",
        "html",
        "http",
        "java",
        "javascript",
        "json",
        "kusto",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "mermaid",
        "nginx",
        "pem",
        "powershell",
        "printf",
        "python",
        "regex",
        "sql",
        "ssh_config",
        "swift",
        "terraform",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    })
  end
}
