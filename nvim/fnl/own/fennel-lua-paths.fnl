(local join #(table.concat $1 ","))

(fn setup []
  (set vim.bo.path (->> (vim.opt.rtp:get)
                        (vim.tbl_map #(join [$1 (.. $1 "/fnl") (.. $1 "/lua")]))
                        (join)))

  (set vim.bo.suffixesadd (join [".fnl"
                                 "/init.fnl"
                                 ".lua"
                                 "/init.lua"
                                 ".fnlm"]))

  (set vim.bo.includeexpr "tr(v:fname, '.', '/')"))

{: setup}
