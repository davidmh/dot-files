(module own.plugin.gh
  {autoload {lib litee.lib
             gh litee.gh}})

(lib.setup)
(gh.setup {:git_buffer_completion true})
