for _, config in ipairs({
  'config.lazy',
  'config.keymaps',
  'config.options',
  'config.autocmds',
  'zettelkasten',
}) do
  local ok, err = pcall(require, config)
  if not ok then
    print(config, ': caused an error', err)
  end
end
