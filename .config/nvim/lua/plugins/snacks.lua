return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      -- disable scrolling animations
      enabled = false,
    },
    picker = {
      hidden = true,
      ignored = true,
      -- found this issue that explained how to show hidden files by default https://github.com/LazyVim/LazyVim/discussions/5559
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
