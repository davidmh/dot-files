(import-macros {: use} :own.macros)
(local {: border} (require :own.config))
(local {: get} (require :nfnl.core))
(local {: find-files} (require :own.projects))

(math.randomseed (os.time))

(local quotes ["vim is only free if your time has no value."
               "Eat right, stay fit, and die anyway."
               "Causes moderate eye irritation."
               "May cause headaches."
               "And now for something completely different."
               "What are we breaking today?"
               "Oh good, it's almost bedtime."])

(use :folke/snacks.nvim {:lazy false
                         :priority 1000
                         :opts {:bigfile {:enabled true}
                                :words {:enabled true}
                                :notifier {:enabled true
                                           :top_down false
                                           :margin {:bottom 1 :right 0}}
                                :dashboard {:enabled true
                                            :preset {:header (->> quotes
                                                                  (length)
                                                                  (math.random)
                                                                  (get quotes))}
                                            :sections [{:section :header}
                                                       {:icon :
                                                        :title "Recent files"
                                                        :section :recent_files
                                                        :indent 2
                                                        :padding 1}
                                                       {:icon :
                                                        :title :Projects
                                                        :section :projects
                                                        :indent 2
                                                        :action find-files
                                                        :padding 1}
                                                       {:section :startup}]}
                                :styles {:notification {: border}
                                         :notification_history {: border}}}})
