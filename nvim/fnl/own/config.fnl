(local severity vim.diagnostic.severity)

(local icons {:ERROR :
              :WARN  :
              :INFO  :
              :HINT  :})

(tset icons severity.ERROR icons.ERROR)
(tset icons severity.WARN icons.WARN)
(tset icons severity.HINT icons.HINT)
(tset icons severity.INFO icons.INFO)

{: icons
 :navic-icons {:File " "
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
               :TypeParameter " "}
 :separator :▌
 :border :rounded}
