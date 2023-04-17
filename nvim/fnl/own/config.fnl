(module own.config)

(local severity vim.diagnostic.severity)

(def icons {:ERROR :
            :WARN  :
            :HINT  :
            :INFO  :})

(tset icons severity.ERROR icons.ERROR)
(tset icons severity.WARN icons.WARN)
(tset icons severity.HINT icons.HINT)
(tset icons severity.INFO icons.INFO)

(def border :solid)
