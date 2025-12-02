return {
  -- Copilot configuration
  -- This plugin provides AI-powered code suggestions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = true },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          inline = true,
          debounce = 50,
          keymap = {
            accept = "<Tab>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          -- Enable Copilot for all filetypes
          ["*"] = true
        },
      })
    end,
  },
}
