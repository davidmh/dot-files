-- [nfnl] Compiled from fnl/own/json-schemas.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local Job = require("plenary.job")
local local_catalog_path = (vim.fn.stdpath("data") .. "/json-schema-catalog.json")
local function notify_info(message)
  return vim.notify(message, "info", {title = "JSON LSP Schemas"})
end
local function notify_error(message)
  return vim.notify(message, "error", {title = "JSON LSP Schemas"})
end
local function on_start()
  return notify_info("Fetching catalog")
end
local function on_exit(job, exit_code)
  if (exit_code == 0) then
    return notify_info("Catalog download complete")
  else
    return notify_error(("Couldn't download catalog.\ncurl responded with exit code: " .. exit_code))
  end
end
local function download_catalog()
  return Job:new({command = "curl", args = {"https://www.schemastore.org/api/json/catalog.json", "-o", local_catalog_path}, on_start = on_start, on_exit = on_exit})
end
local function get_all()
  local function _3_()
    local _4_ = local_catalog_path
    if (nil ~= _4_) then
      local _5_ = core.slurp(_4_, true)
      if (nil ~= _5_) then
        local _6_ = vim.fn.json_decode(_5_)
        if (nil ~= _6_) then
          return core.get(_6_, "schemas", {})
        else
          return _6_
        end
      else
        return _5_
      end
    else
      return _4_
    end
  end
  local function _10_()
    print("Run refetch-catalog to get JSON schema hovers")
    return {}
  end
  return (_3_() or _10_())
end
local function refetch_catalog()
  vim.fn.system(("rm -f " .. local_catalog_path))
  return download_catalog():sync()
end
return {["get-all"] = get_all, ["refetch-catalog"] = refetch_catalog}
