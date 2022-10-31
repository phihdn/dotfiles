local status, _ = pcall(vim.cmd, "colorscheme onenord")
if not status then
  print("Colorscheme not found!")
  return
end
