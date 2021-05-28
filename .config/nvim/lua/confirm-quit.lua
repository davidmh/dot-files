-- Some messages are from Doom, some from Portal and some custom ones.
local messages = {
  "Ya know, next time you come in here I'm gonna toast ya.",
  "Go ahead and leave. See if I care.",
  "Are you sure you want to quit this great editor?",
  "Get outta here and go back to your boring programs.",
  "If I were your boss, I'd deathmatch ya in a minute!",
  "You're lucky I don't smack you for thinking about leaving.",
  "Okay, look. We've both said a lot of things you're going to regret...",
  "Uh oh. Somebody cut the cake. I told them to wait for you, but they did it anyway. There is still some left, though, if you hurry back.",
  "Where do you think you're going?, Because I don't think you're going where you think you're going.",
  "It's not too late for you to turn back.",
  "I'm not angry. Just go back to the editing area.",
  "Someday we'll remember this and laugh. and laugh. and laugh. Oh boy. Well. You may as well come on back.",
  "Nobody can quit vim, nobody!",
  "You can checkout anytime you like, but you can never leave *cheesy guitar solo*",
  "But if you leave who's gonna be bad at writing macros?",
  "Huh, never pegged you for a quitter."
}

function _G.confirm_quit(should_write)
  if should_write then
    if vim.o.modifiable then
      vim.cmd('write')
    elseif vim.fn.expand('%:t') == '' then
      vim.cmd([[echoerr "Can't save a file with no name."]])
      return
    end
  else
    -- When we try to quit without saving, we cleanup the last message because
    -- it's not relevant to the confirmation prompt
    vim.cmd("echo ''")
  end
  if vim.fn.winnr('$') == 1 and vim.fn.tabpagenr('$') == 1 then
    local message = messages[math.random(#messages)]
    if vim.fn.confirm(message,  'Quit? &Yes\n&No', 2) == 1 then
      vim.cmd('quit')
    end
  else
    vim.cmd('quit')
  end
end
