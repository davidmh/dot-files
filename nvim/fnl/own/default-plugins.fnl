; disables these default plugins
(local default-plugins [:2html_plugin
                        :getscript
                        :getscriptPlugin
                        :gzip
                        :logipat
                        :matchit
                        :tar
                        :tarPlugin
                        :rrhelper
                        :spellfile_plugin
                        :vimball
                        :vimballPlugin
                        :tutor
                        :rplugin
                        :syntax
                        :synmenu
                        :optwin
                        :compiler
                        :bugreport
                        :ftplugin])

(each [_ plugin (pairs default-plugins)]
  (tset vim.g (.. "loaded_" plugin) 1))
