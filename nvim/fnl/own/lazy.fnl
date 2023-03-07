(module own.lazy
  {autoload {core aniseed.core
             lazy lazy}})

(defn- load-module [name]
  (let [(ok? val-or-err) (pcall require (.. "own.plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn load-plugins [...]
  (let [pkgs [...]
        plugins []]
    (for [i 1 (core.count pkgs) 2]
      (let [name (. pkgs i)
            opts (. pkgs (+ i 1))
            mod (. opts :mod)
            plugin (core.merge {1 name} opts)]
        (when mod
          ; remove the mod key
          (tset plugin :mod nil)
          ; replace it with a config call
          (tset plugin :config #(load-module mod)))

        ; the first param defines the plugin URL, local plugins don't need it
        (if (. opts :dir)
          (table.remove plugin 1))

        ; add it to the list of plugins
        (table.insert plugins plugin)))
    (lazy.setup plugins {:ui {:border :rounded}
                         :install {:colorscheme [:catppuccin]}})))
