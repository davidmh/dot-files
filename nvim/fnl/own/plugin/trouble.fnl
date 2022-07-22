(module own.plugin.trouble
  {autoload {trouble trouble
             config own.config}})

(trouble.setup {:icons true
                :signs {:error config.icons.error
                        :warning config.icons.warning
                        :hint config.icons.hint
                        :information config.info
                        :other "﫠"}
                :group false})
