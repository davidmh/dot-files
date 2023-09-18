(module own.config)

(local severity vim.diagnostic.severity)

(def icons {:ERROR :
            :WARN  :
            :INFO  :
            :HINT  :})

(tset icons severity.ERROR icons.ERROR)
(tset icons severity.WARN icons.WARN)
(tset icons severity.HINT icons.HINT)
(tset icons severity.INFO icons.INFO)

(def navic-icons {:File " "
                  :Module " "
                  :Namespace " "
                  :Package " "
                  :Class " "
                  :Method " "
                  :Property " "
                  :Field " "
                  :Constructor " "
                  :Enum " "
                  :Interface " "
                  :Function " "
                  :Variable " "
                  :Constant " "
                  :String " "
                  :Number " "
                  :Boolean " "
                  :Array " "
                  :Object " "
                  :Key " "
                  :Null " "
                  :EnumMember " "
                  :Struct " "
                  :Event " "
                  :Operator " "
                  :TypeParameter " "})

(def separator :▌)

(def border :solid)
