(module own.plugin.dressing
  {autoload {dressing dressing
             themes telescope.themes}})

(dressing.setup {:select {:backend :telescope}})
