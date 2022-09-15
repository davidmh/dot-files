(module own.plugin.dressing
  {autoload {dressing dressing
             themes telescope.themes}})

(defn- width [_ max-columns]
  (math.min max-columns 80))

(defn- height [_ max-lines]
  (math.min max-lines 15))

(dressing.setup {:select {:backend :telescope
                          :telescope {:layout_config {:width width
                                                      :height height}}}})
