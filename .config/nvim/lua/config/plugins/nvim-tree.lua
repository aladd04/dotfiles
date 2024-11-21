return {
  "nvim-tree/nvim-tree.lua", -- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  version = "*",
  lazy = false, -- load immediately
  config = function()
    -- disable built in neovim file explorer
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      view = {
        relativenumber = true,
        width = 35,
      },
      filters = {
        custom = {
          ".DS_Store" -- hide this file globally
        }
      }
    })

    local map = vim.keymap.set

    map("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer pane" })
    map("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer pane" })
    map("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    map("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
  end,
}
