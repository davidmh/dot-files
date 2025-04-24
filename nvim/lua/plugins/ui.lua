-- [nfnl] fnl/plugins/ui.fnl
local _local_1_ = require("nfnl.core")
local get = _local_1_["get"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local confirm_quit = autoload("confirm-quit")
local quit_messages = {"Ya know, next time you come in here I'm gonna toast ya.", "Go ahead and leave. See if I care.", "Get outta here and go back to your boring programs.", "If I were your boss, I'd deathmatch ya in a minute!", "You're lucky I don't smack you for thinking about leaving.", "Okay, look. We've both said a lot of things you're going to regret...", "Where do you think you're going?, Because I don't think you're going where you think you're going.", "It's not too late for you to turn back.", "I'm not angry. Just go back to the editing area.", "Someday we'll remember this and laugh. and laugh. and laugh. Oh boy. Well. You may as well come on back.", "But if you leave who's gonna be bad at writing macros?", "Huh, never pegged you for a quitter."}
math.randomseed(os.time())
local function quit_message()
  local message = get(quit_messages, math.random(#quit_messages))
  return (message .. "\nQuit?")
end
local function _3_()
  vim.cmd("update")
  return confirm_quit.confirm_quit()
end
local function _4_()
  return confirm_quit.confirm_quit()
end
return {{"nvim-tree/nvim-web-devicons", config = true}, {"davidmh/confirm-quit.nvim", event = "CmdLineEnter", branch = "custom-quit-message", opts = {overwrite_q_command = true, quit_message = quit_message}, keys = {{"ZZ", _3_, mode = "n", desc = "Save and quit"}, {"ZQ", _4_, mode = "n", desc = "Quit without saving"}}}}
