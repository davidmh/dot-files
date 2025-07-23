(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: assoc-in : get} (require :nfnl.core))
(local {: find-files : project-list} (require :own.projects))
(local actions (autoload :snacks.picker.actions))

(math.randomseed (os.time))

(local quotes ["vim is only free if your time has no value."
               "Eat right, stay fit, and die anyway."
               "Causes moderate eye irritation."
               "May cause headaches."
               "And now for something completely different."
               "What are we breaking today?"
               "Oh good, it's almost bedtime."])

(tx :folke/snacks.nvim {:lazy false
                        :priority 1000
                        :opts {:bigfile {:enabled true}
                               :statuscolumn {:enabled true}
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
                                                       :padding 1
                                                       :limit 10}
                                                      {:icon :
                                                       :title :Projects
                                                       :section :projects
                                                       :indent 2
                                                       :action find-files
                                                       :dirs project-list
                                                       :limit 10
                                                       :padding 1}
                                                      {:section :startup}]}
                                :input {:enabled true
                                        :win {:relative :cursor
                                              :col 0
                                              :row 1}}
                                :image {:force true
                                        :doc {:inline true}}
                                :notifier {:enabled true
                                           :style :fancy
                                           :margin {:bottom 2}
                                           :top_down false}
                                :picker {:sources {:commands {:confirm :cmd!}
                                                   :files {:win {:input {:keys {:<c-x> (tx :edit_split {:mode [:i :n]})}}}
                                                           :hidden true}}
                                         :actions {:cmd! (fn [picker item]
                                                           (if (and item item.command
                                                                    (= item.command.nargs :0))
                                                               (do
                                                                 (picker:close)
                                                                 (vim.schedule #(vim.cmd item.cmd)))
                                                               (actions.cmd picker item)))}}
                                :terminal {:win {:position :bottom
                                                 :bo {:filetype :terminal}
                                                 :wo {:winbar ""
                                                      :winhighlight :Normal:Normal}}}}
                              :init (fn []
                                      (local snacks (require :snacks))
                                      (set vim.ui.select snacks.picker.select)

                                      (local layouts (require :snacks.picker.config.layouts))
                                      (assoc-in layouts [:default :layout 1 :border] :solid)
                                      (assoc-in layouts [:default :layout 1 1 :border] :solid)
                                      (assoc-in layouts [:default :layout 2 :border] :solid)
                                      (assoc-in layouts [:default :layout :backdrop] false)
                                      (assoc-in layouts [:select :layout :border] :solid)
                                      (assoc-in layouts [:select :layout 1 :border] :none))})
