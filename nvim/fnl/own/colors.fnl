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

M
