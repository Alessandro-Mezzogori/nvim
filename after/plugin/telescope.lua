local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = '[P]roject [f]ile'})
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = '[P]roject [f]ile [g]it'})
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = '[S]earch by [G]rep' } )
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = '[S]earch [d]iagnostics' } )
vim.keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = '[S]earch [r]ecent' } )
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = '[S]earch [h]elp' } )

