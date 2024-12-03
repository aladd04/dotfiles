return {
  "ThePrimeagen/harpoon", -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    -- use telescope for the ui instead of harpoon native
    local conf = require("telescope.config").values
    local function toggle_harpoon_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    local map = vim.keymap.set

    map("n", "<leader>hf", function() toggle_harpoon_telescope(harpoon:list()) end, { desc = "Search and preview harpoon list" })
    map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Show harpoon list" })
    map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add file to harpoon list" })
    map("n", "<leader>hr", function() harpoon:list():remove() end, { desc = "Remove file from harpoon list" })
    map("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Navigate to next mark" })
    map("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Navigate to previous mark" })
  end,
}
