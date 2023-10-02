-- [nfnl] Compiled from fnl/own/confirm-quit.fnl by https://github.com/Olical/nfnl, do not edit.
local core = require("nfnl.core")
local messages = {"Ya know, next time you come in here I'm gonna toast ya.", "Go ahead and leave. See if I care.", "Are you sure you want to quit this great editor?", "Get outta here and go back to your boring programs.", "If I were your boss, I'd deathmatch ya in a minute!", "You're lucky I don't smack you for thinking about leaving.", "Okay, look. We've both said a lot of things you're going to regret...", "Uh oh. Somebody cut the cake. I told them to wait for you, but they did it anyway. There is still some left, though, if you hurry back.", "Where do you think you're going?, Because I don't think you're going where you think you're going.", "It's not too late for you to turn back.", "I'm not angry. Just go back to the editing area.", "Someday we'll remember this and laugh. and laugh. and laugh. Oh boy. Well. You may as well come on back.", "Nobody can quit vim, nobody!", "You can checkout anytime you like, but you can never leave *cheesy guitar solo*", "But if you leave who's gonna be bad at writing macros?", "Huh, never pegged you for a quitter."}
local function get_message()
  math.randomseed(os.time())
  return messages[math.random(core.count(messages))]
end
local function confirm(should_write)
  if should_write then
    if vim.o.modifiable then
      vim.cmd("write")
    else
      if (vim.fn.expand("%:t") == "") then
        vim.notify("Can't save a file without a name.", "error", {title = "hold up!"})
        return
      else
      end
    end
  else
    vim.cmd("echo ''")
  end
  if ((vim.fn.winnr("$") == 1) and (vim.fn.tabpagenr("$") == 1)) then
    if (1 == vim.fn.confirm(get_message(), "Quit? &Yes\n&No", 2)) then
      return vim.cmd("quit")
    else
      return nil
    end
  else
    return vim.cmd("quit")
  end
end
local function _6_()
  return confirm(true)
end
vim.keymap.set("n", "ZZ", _6_)
local function _7_()
  return confirm(false)
end
return vim.keymap.set("n", "ZQ", _7_)
