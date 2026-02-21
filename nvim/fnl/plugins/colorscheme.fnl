(import-macros {: tx} :own.macros)

(tx :rebelot/kanagawa.nvim {:init #(vim.cmd.colorscheme :kanagawa)
                            :opts {:colors {:theme {:all {:ui {:bg_gutter :none}}}}
                                   :overrides (fn [{: theme}]
                                                (local syn theme.syn)
                                                (local bg theme.ui.bg_dim)
                                                (local fg theme.ui.bg)
                                                (local cmp-fg theme.ui.fg_reverse)

                                                {:WinSeparator {:fg theme.ui.bg_search}

                                                 :SnacksNotifierInfo  {: bg}
                                                 :SnacksNotifierWarn  {: bg}
                                                 :SnacksNotifierError {: bg}
                                                 :SnacksNotifierDebug {: bg}
                                                 :SnacksNotifierTrace {: bg}

                                                 :SnacksNotifierBorderInfo  {: fg : bg}
                                                 :SnacksNotifierBorderWarn  {: fg : bg}
                                                 :SnacksNotifierBorderError {: fg : bg}
                                                 :SnacksNotifierBorderDebug {: fg : bg}
                                                 :SnacksNotifierBorderTrace {: fg : bg}

                                                 :CmpItemKindSnippetIcon       {:fg cmp-fg :bg syn.statement}
                                                 :CmpItemKindKeywordIcon       {:fg cmp-fg :bg syn.keyword}
                                                 :CmpItemKindTextIcon          {:fg cmp-fg :bg syn.comment}
                                                 :CmpItemKindMethodIcon        {:fg cmp-fg :bg syn.fun}
                                                 :CmpItemKindConstructorIcon   {:fg cmp-fg :bg syn.statement}
                                                 :CmpItemKindFunctionIcon      {:fg cmp-fg :bg syn.fun}
                                                 :CmpItemKindFolderIcon        {:fg cmp-fg :bg syn.punct}
                                                 :CmpItemKindModuleIcon        {:fg cmp-fg :bg syn.type}
                                                 :CmpItemKindConstantIcon      {:fg cmp-fg :bg syn.constant}
                                                 :CmpItemKindFieldIcon         {:fg cmp-fg :bg syn.identifier}
                                                 :CmpItemKindPropertyIcon      {:fg cmp-fg :bg syn.identifier}
                                                 :CmpItemKindEnumIcon          {:fg cmp-fg :bg syn.constant}
                                                 :CmpItemKindUnitIcon          {:fg cmp-fg :bg syn.string}
                                                 :CmpItemKindClassIcon         {:fg cmp-fg :bg syn.operator}
                                                 :CmpItemKindVariableIcon      {:fg cmp-fg :bg syn.keyword}
                                                 :CmpItemKindFileIcon          {:fg cmp-fg :bg syn.punct}
                                                 :CmpItemKindInterfaceIcon     {:fg cmp-fg :bg syn.identifier}
                                                 :CmpItemKindColorIcon         {:fg cmp-fg :bg syn.special2}
                                                 :CmpItemKindReferenceIcon     {:fg cmp-fg :bg syn.special2}
                                                 :CmpItemKindEnumMemberIcon    {:fg cmp-fg :bg syn.special2}
                                                 :CmpItemKindStructIcon        {:fg cmp-fg :bg syn.parameter}
                                                 :CmpItemKindValueIcon         {:fg cmp-fg :bg syn.number}
                                                 :CmpItemKindEventIcon         {:fg cmp-fg :bg syn.parameter}
                                                 :CmpItemKindOperatorIcon      {:fg cmp-fg :bg syn.parameter}
                                                 :CmpItemKindTypeParameterIcon {:fg cmp-fg :bg syn.parameter}})}})
