return {
  -- Mason: installs LSP servers
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-LSPConfig: bridges Mason + Neovim LSP
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {
        "ruby_lsp",
      },
    },
  },

  -- Neovim's LSP client
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Capabilities (required for nvim-cmp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      ---------------------------------------------------------------------
      -- Modern Neovim 0.11+ API
      -- You define configs with vim.lsp.config(), then enable the server.
      ---------------------------------------------------------------------

      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        -- add any ruby-lsp settings here if needed
        settings = {
          formatting = { enabled = true }, -- enable Rubocop formatting
        },
      })

      -- Enable the server (starts automatically when opening filetypes)
      vim.lsp.enable("ruby_lsp")

      ---------------------------------------------------------------------
      -- LSP Keymaps
      ---------------------------------------------------------------------
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<C-A-l>", function()
        vim.lsp.buf.format({ async = false })
      end, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
    end,
  },

}

