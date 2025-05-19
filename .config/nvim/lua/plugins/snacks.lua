-- found this issue that explained how to show hidden files by default https://github.com/LazyVim/LazyVim/discussions/5559
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      hidden = true,
      ignored = true,
      exclude = {
        "node_modules",
        ".git",
        "bin",
        "obj",
        "dist",
      },
    },
  },
}
