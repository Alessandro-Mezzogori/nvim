require('trouble').setup {

}

vim.keymap.set('n', '<leader>td', '<cmd>TroubleToggle<cr>', { desc = '[O]pen [d]iagnostics' });
