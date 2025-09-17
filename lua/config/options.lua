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
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", "")',
    },
    cache_enabled = 0,
  }
end

vim.g.lazyvim_prettier_needs_config = true

-- TEMP WEBVIEW MAPPINGS

function start_job(job)
  return vim.fn.jobstart(job({
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        print("stdout, data: " .. vim.inspect(data))
      end
    end,
    on_stderr = function(_, data)
      if data then
        print("stderr, data: " .. vim.inspect(data))
      end
    end,
    on_exit = function(_, code)
      print("Process exited with code: " .. vim.inspect(code))
    end,
  }))
end

-- TODO: support for multiple pdf inside same viewer
CURRENT_PDF_JOB_ID = 0
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
    CURRENT_PAGE = 0
  end

  CURRENT_PDF_JOB_ID = start_job({ "cmd.exe", "/c", "start", exec, fullpath })
end, {
  nargs = 1,
  complete = "file",
})

CURRENT_PAGE = 0
function set_page(page)
  CURRENT_PAGE = page

  local body = "page:" .. CURRENT_PAGE

  -- TODO: page checks
  -- TODO: retrieve info from active pdf from application
  start_job({ "powershell", "Invoke-WebRequest", "-Uri", "http://localhost:12345", "-Method", "Post", "-Body", body })
end

vim.keymap.set("n", "<Leader>own", function()
  set_page(CURRENT_PAGE + 1)
end)

vim.keymap.set("n", "<Leader>owp", function()
  set_page(CURRENT_PAGE - 1)
end)

vim.api.nvim_create_user_command("PdfPage", function(opts)
  set_page(opts.args)
end, {
  nargs = 1,
  complete = "file",
})
