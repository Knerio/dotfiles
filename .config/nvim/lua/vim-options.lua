vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')


vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.expandtab = true   -- convert tabs to spaces
vim.opt.tabstop = 4        -- display tabs as 4 spaces
vim.opt.shiftwidth = 4     -- indent size
vim.opt.softtabstop = 4    -- number of spaces when pressing TAB
vim.opt.smartindent = true -- auto indent new lines
vim.opt.autowrite = true
vim.opt.autowriteall = true

vim.api.nvim_create_autocmd({ "WinLeave", "TabLeave", "FocusLost" }, {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })


vim.keymap.set("n", "<leader>th", ":split | term<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>p", ":Telescope projects<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>F", "<C-w>_", { noremap = true, silent = true, nowait = true })
