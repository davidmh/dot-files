(local {: autoload : define} (require :nfnl.module))
(local M (define :own.colors))
(local kanagawa-colors (autoload :kanagawa.colors))

(fn M.get-colors []
  "Return a list of colors used by different plugins."
  (local {: palette} (kanagawa-colors.setup))

  {; diagnostics
   :error palette.autumnRed
   :warn palette.autumnYellow
   :info palette.autumnGreen
   :hint palette.crystalBlue

   ; modes
   :modeNormal     :fg
   :modeInsert     palette.lotusGreen
   :modeVisual     palette.waveBlue1
   :modeVLine      palette.lotusTeal1
   :modeVBlock     palette.lotusTeal1
   :modeCommand    palette.sakuraPink
   :modeSelect     palette.oniViolet
   :modeSLine      palette.oniViolet
   :modeSBlock     palette.oniViolet
   :modeReplace    palette.sakuraPink
   :modeShellCmd   palette.waveRed
   :modeTerm       palette.lotusGreen
   :modeNormalTerm :fg

   ; misc
   :git palette.oniViolet})

(fn M.get-highlights [{: theme}]
  (local syn theme.syn)
  (local bg theme.ui.bg_dim)
  (local fg theme.ui.bg)
  (local cmp-fg theme.ui.fg_reverse)

  {:WinSeparator {:fg theme.ui.bg_search}

   :StatusLine {:bg :none}

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
   :CmpItemKindTypeParameterIcon {:fg cmp-fg :bg syn.parameter}})

M
