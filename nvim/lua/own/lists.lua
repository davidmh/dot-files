-- [nfnl] fnl/own/lists.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_["define"]
local M = define("own.lists")
M.find = function(pred, xs)
  vim.validate("pred", pred, "function")
  vim.validate("xs", xs, "table")
  for i, x in ipairs(xs) do
    if pred(x, i) then
      return x
    else
    end
  end
  return nil
end
M["find-right"] = function(pred, xs)
  vim.validate("pred", pred, "function")
  vim.validate("xs", xs, "table")
  for i = 1, (#xs - 1) do
    local x = xs[i]
    if pred(x, i) then
      return x
    else
    end
  end
  return nil
end
M["find-index"] = function(pred, xs)
  vim.validate("pred", pred, "function")
  vim.validate("xs", xs, "table")
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
M.join = function(xs, sep)
  vim.validate("xs", xs, "table")
  vim.validate("sep", sep, "string")
  return table.concat(vim.tbl_filter(not_empty, xs), sep)
end
M.take = function(n, xs)
  vim.validate("n", n, "number")
  vim.validate("xs", xs, "table")
  return vim.list_slice(xs, 1, n)
end
M["min-by"] = function(f, xs)
  vim.validate("f", f, "function")
  vim.validate("xs", xs, "table")
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
M["max-by"] = function(f, xs)
  vim.validate("f", f, "function")
  vim.validate("xs", xs, "table")
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
return M
