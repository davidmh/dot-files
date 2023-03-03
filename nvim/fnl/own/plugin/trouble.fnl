(module own.plugin.trouble
  {autoload {trouble trouble
             config own.config}})

(trouble.setup {:icons true
                :signs {:error config.icons.ERROR
                        :warning config.icons.WARN
                        :hint config.icons.HINT
                        :information config.icons.INFO
                        :other "﫠"}
                :group false})
