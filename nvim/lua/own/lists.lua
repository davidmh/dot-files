-- [nfnl] fnl/own/lists.fnl
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
local function find_index(pred, xs)
  vim.validate({pred = {pred, "function"}, xs = {xs, "table"}})
  for i, x in ipairs(xs) do
    if pred(x, i) then
      return i
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
local function take(n, xs)
  vim.validate({n = {n, "number"}, xs = {xs, "table"}})
  return vim.list_slice(xs, 1, n)
end
local function min_by(f, xs)
  vim.validate({f = {f, "function"}, xs = {xs, "table"}})
  local min = math.huge
  local min_x = nil
  for _, x in ipairs(xs) do
    local v = f(x)
    if (v < min) then
      min = v
      min_x = x
    else
    end
  end
  return min_x
end
local function max_by(f, xs)
  vim.validate({f = {f, "function"}, xs = {xs, "table"}})
  local max = ( - math.huge)
  local max_x = nil
  for _, x in ipairs(xs) do
    local v = f(x)
    if (v > max) then
      max = v
      max_x = x
    else
    end
  end
  return max_x
end
return {find = find, ["find-right"] = find_right, ["find-index"] = find_index, ["min-by"] = min_by, ["max-by"] = max_by, join = join, take = take}
