return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux"
  },
  config = function()
    vim.keymap.set("n", "<leader>test", ":TestNearest<CR>", {})
    vim.keymap.set("n", "<leader>TT", ":TestFile<CR>", {})
    vim.keymap.set("n", "<leader>tall", ":TestSuite<CR>", {})
    vim.keymap.set("n", "<leader>tlast", ":TestLast<CR>", {})
    vim.cmd("let test#strategy = 'vimux'")
  end,
}
