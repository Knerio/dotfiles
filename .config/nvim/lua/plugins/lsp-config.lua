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
        },
    },

    -- Neovim's LSP client
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            -- Capabilities (required for nvim-cmp)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local settings = {
                formatting = { enabled = true }
            }

            vim.lsp.config("ruby_lsp", {
                capabilities = capabilities,
                settings = settings,
            })
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = settings,
            })
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
                settings = settings,
            })
            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                settings = settings,
            })
            vim.lsp.config("bufls", {
                capabilities = capabilities,
                settings = settings,
            })
            vim.lsp.config("buf_ls", {
                capabilities = capabilities,
                settings = settings,
            })


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
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●", -- symbol before message
                    spacing = 4,
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
            vim.o.updatetime = 200
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = function()
                    vim.diagnostic.open_float(nil, { focus = false })
                end
            })
        end,
    },

}
