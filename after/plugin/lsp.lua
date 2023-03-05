local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp.set_preferences({
	sign_icons = {}
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {buffer = bufnr, remap = false, desc = '[G]oto [d]efinition' })
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = bufnr, remap = false, desc = '[k] Hover '}) 
	--vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts..{ desc = '[W]orkspace [s]ymbols'})
	--vim.keymap.set("n", "<leader>ds", function() vim.lsp.buf.document_symbol() end, opts..{ desc = '[D]ocument [s]ymbols'})
	--vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, { buffer = bufnr, remap = false, desc = 'Goto next'})
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, { buffer = bufnr, remap = false, desc = 'Goto prev'})
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, { buffer = bufnr, remap = false, desc = '[C]ode [a]ction' })
	vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, { buffer = bufnr, remap = false, desc = '[G]oto [r]eferences' })
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, { buffer = bufnr, remap = false, desc = '[v] [R]e[n]ame' })
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { buffer = bufnr, remap = false, desc = 'Signature [h]elp' })
end)

-- Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    underline = false,
    severity_sort = false,
    float = true,
})


