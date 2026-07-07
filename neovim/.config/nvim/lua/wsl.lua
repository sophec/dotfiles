local pwsh = "/mnt/c/Windows/System32/WindowsPowershell/v1.0/powershell.exe"
local pwsh_args = ' -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'

vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    -- for copying, windows terminal supports OSC 52
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    -- for pasting, windows terminal does not support OSC 52
    ["+"] = pwsh .. pwsh_args,
    ["*"] = pwsh .. pwsh_args,
  },
}
