return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    words = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    toggle = { map = vim.keymap.set },
  },
  keys = {
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  }
}
