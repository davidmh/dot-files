-- [nfnl] Compiled from fnl/own/plugin/colorscheme.fnl by https://github.com/Olical/nfnl, do not edit.
local core = require("nfnl.core")
local catppuccin = require("catppuccin")
local custom_highlights = require("own.plugin.highlights")
catppuccin.setup({flavour = "mocha", term_colors = true, integrations = {lsp_trouble = true, telescope = true, which_key = true}, custom_highlights = custom_highlights, transparent_background = false})
vim.cmd.colorscheme("catppuccin")
local home_manager_path = vim.fn.expand("~/.config/home-manager/")
local wezterm_config_path = (home_manager_path .. "wezterm.lua")
local nvim_colorscheme_path = (home_manager_path .. "nvim/fnl/own/plugin/colorscheme.fnl")
local function capitalize(text)
  local first_letter = text:sub(1, 1)
  local rest = text:sub(2)
  return (first_letter:upper() .. rest)
end
local function symbolize(text)
  return (":" .. text)
end
local function get_wezterm_catppuccin_flavor()
  local _, _0, flavor = string.find(string.lower(core.slurp(wezterm_config_path)), "color_scheme = 'catppuccin (%w*)'")
  return flavor
end
local function get_nvim_catppuccin_flavor()
  local _, _0, flavor = string.find(core.slurp(nvim_colorscheme_path), ":flavour :(%w*)")
  return flavor
end
local function update_colorscheme(new_flavor)
  return vim.cmd(("Catppuccin " .. new_flavor))
end
local function update_file_content(path, from, to)
  local updated_content = string.gsub(core.slurp(path), from, to)
  return core.spit(path, updated_content)
end
local function on_wezterm_config_change()
  local new_flavor = get_wezterm_catppuccin_flavor()
  if (new_flavor ~= catppuccin.flavour) then
    update_file_content(nvim_colorscheme_path, symbolize(catppuccin.flavour), symbolize(new_flavor))
    return update_colorscheme(new_flavor)
  else
    return nil
  end
end
local function on_nvim_config_change()
  local _, _0, new_flavor = string.find(table.concat(vim.api.nvim_buf_get_lines(vim.fn.bufnr(), 0, -1, false)), ":flavour :(%w*)")
  local wezterm_flavor = get_wezterm_catppuccin_flavor()
  if (new_flavor ~= wezterm_flavor) then
    update_file_content(wezterm_config_path, capitalize(wezterm_flavor), capitalize(new_flavor))
    return update_colorscheme(new_flavor)
  else
    return nil
  end
end
local function on_update_from_command()
  local new_flavor = catppuccin.flavour
  local wezterm_flavor = get_wezterm_catppuccin_flavor()
  local nvim_flavor = get_nvim_catppuccin_flavor()
  if (new_flavor ~= wezterm_flavor) then
    update_file_content(wezterm_config_path, capitalize(wezterm_flavor), capitalize(new_flavor))
  else
  end
  if (new_flavor ~= nvim_flavor) then
    return update_file_content(nvim_colorscheme_path, symbolize(nvim_flavor), symbolize(new_flavor))
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("update-colorscheme", {clear = true})
vim.api.nvim_create_autocmd("BufWritePost", {pattern = wezterm_config_path, callback = on_wezterm_config_change, group = group})
vim.api.nvim_create_autocmd("BufWritePost", {pattern = nvim_colorscheme_path, callback = on_nvim_config_change, group = group})
vim.api.nvim_create_autocmd("ColorScheme", {pattern = "*", callback = on_update_from_command, group = group})
return nil
