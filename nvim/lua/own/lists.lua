-- [nfnl] Compiled from fnl/own/lists.fnl by https://github.com/Olical/nfnl, do not edit.
local function find(pred, xs)
  vim.validate({pred = {pred, "function"}, xs = {xs, "table"}})
  for i, x in ipairs(xs) do
    if pred(x, i) then
      return x
    else
    end
  end
  return nil
end
local function find_right(pred, xs)
  vim.validate({pred = {pred, "function"}, xs = {xs, "table"}})
  for i = 1, (#xs - 1) do
    local x = xs[i]
    if pred(x, i) then
      return x
    else
    end
  end
  return nil
end
local function not_empty(x)
  return ((x ~= nil) and (x ~= ""))
end
local function join(xs, sep)
  vim.validate({t = {xs, "table"}, s = {sep, "string"}})
  return table.concat(vim.tbl_filter(not_empty, xs), sep)
end
return {find = find, ["find-right"] = find_right, join = join}
