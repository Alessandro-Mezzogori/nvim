vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Opens NETRW folder'})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves selection up' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves selection down' })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Centers when going down half-page' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Centers when going up half-page' })
vim.keymap.set("n", "n", "nzzzv", { desc = '' })
vim.keymap.set("n", "N", "Nzzzv", { desc = '' })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = '[P]aste preserve buffer' })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = '[Y]ank to clipboard' })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = '[Y]ank to clipboard' })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = '[Y]ank to clipboard' })

vim.keymap.set("n", "<leader>d", "\"_d", { desc = '[D]elete in void' })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = '[D]elete in void' })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end, { desc = '[f]ormat'})

-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = 'Replace under cursor' })











