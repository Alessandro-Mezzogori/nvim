local dap = require('dap')

vim.keymap.set("n", "<leader>tb", dap.toggle_breakpoint)
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<leader>rp", dap.repl.open)

local dapui = require('dapui')
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Rust setup

local mason_registry = require('mason-registry')
local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
--TODO IDK what it is used for, search 
--local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
    }
}

dap.configurations.rust = {
    {
        name = "Debug",
        type = "codelldb",
        request = "launch",
        program = function()
            vim.fn.jobstart("cargo build")
            return "${workspaceFolder}/target/debug/${workspaceFolderBasename}"
        end,
        stopAtEntry = true,
        showDisassembly = "never" 
    }
}

