(local starter (require :mini.starter))

(starter.setup {:header #(-?> [:fortune-kind :-s]
                              (vim.system {:text true})
                              (: :wait)
                              (. :stdout)
                              (string.gsub "^1" ""))
                :items [(starter.sections.builtin_actions)
                        (starter.sections.recent_files 7 false false)
                        (starter.sections.telescope)]})
