-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local wsl = vim.fn.has("wsl") == 1

if wsl then
  vim.g.clipboard = {
    name = "wsl-clip",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", "")',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", "")',
    },
    cache_enabled = 0,
  }
end

vim.g.lazyvim_prettier_needs_config = true

-- TEMP WEBVIEW MAPPINGS

function start_job(job)
  return vim.fn.jobstart(job, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        local result = vim.json.decode(data[1])
        vim.notify(result.message, result.ok and vim.log.levels.INFO or vim.log.levels.ERROR)
      end
    end,
    on_stderr = function(_, data)
      --if data then
      --  print("stderr, data: " .. vim.inspect(data))
      --end
    end,
    on_exit = function(_, code)
      --print("Process exited with code: " .. vim.inspect(code))
    end,
  })
end

-- TODO: support for multiple pdf inside same viewer
CURRENT_PDF_JOB_ID = 0
CONTROLLER_PORT = "12345"
CONTROLLER_URL = "http://localhost:" .. CONTROLLER_PORT

vim.api.nvim_create_user_command("Pdf", function(opts)
  -- TODO: support for binary search / predefined folder
  local bin = "E:/projects/personal/NeovimEdgePdfController/NeovimEdgePdfController/bin/Debug/net9.0-windows"
  local exec = vim.fn.fnamemodify(bin .. "/" .. "NeovimEdgePdfController.exe", ":p")
  exec =
    "E:\\projects\\personal\\NeovimEdgePdfController\\NeovimEdgePdfController\\bin\\Debug\\net9.0-windows\\NeovimEdgePdfController.exe"

  local arg = opts.args
  local fullpath = arg
  if not vim.fn.has("win32") == 1 then
    -- Unix-like: absolute if starts with "/"
    if not arg:match("^/") then
      fullpath = vim.fn.fnamemodify(arg, ":p")
    end
  else
    -- Windows: absolute if starts with drive letter (C:\) or UNC path (\\)
    if not arg:match("^%a:[/\\]") and not arg:match("^\\\\") then
      fullpath = vim.fn.fnamemodify(arg, ":p")
    end
  end

  print("echo " .. exec)
  print("echo " .. fullpath)

  -- Run your executable asynchronously
  -- TODO: cross platform ( ma devo fare anche l'eseguibile webview2)

  if CURRENT_PDF_JOB_ID ~= 0 then
    vim.fn.jobstop(CURRENT_PDF_JOB_ID)
    CURRENT_PDF_JOB_ID = 0
  end

  CURRENT_PDF_JOB_ID = start_job({ "cmd.exe", "/c", "start", exec, fullpath, 800, 800, 1, CONTROLLER_PORT })
end, {
  nargs = 1,
  complete = "file",
})

function __call(message)
  start_job({ "powershell", "curl.exe", CONTROLLER_URL, "-X", "POST", "-d", message })
end

local messages = {
  set_page = function(page)
    __call("page:" .. page)
  end,
  next_page = function()
    __call("page:next")
  end,
  prev_page = function()
    __call("page:prev")
  end,
}

vim.keymap.set("n", "<Leader>own", messages.next_page)
vim.keymap.set("n", "<Leader>owp", messages.prev_page)
vim.api.nvim_create_user_command("PdfPage", function(opts)
  messages.set_page(opts.args)
end, {
  nargs = 1,
  complete = "file",
})
