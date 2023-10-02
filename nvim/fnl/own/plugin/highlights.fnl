(local palette (require :catppuccin.palettes))

;; useful to get completion while writing the highlights
;; but the actual color will come from the function param
(local color (palette.get_palette))

(fn custom-highlights [color]
  {:Comment {:style [:italic :bold]}
   :Pmenu {:bg color.crust}
   :WinSeparator {:fg color.overlay0 :bg :none}

   :FloatBorder {:link :NormalFloat}

   :TreesitterContext {:link :Normal}

   :TroubleText {:link :Normal}
   :TroubleCount {:link :Normal}
   :TroubleNormal {:link :Normal}

   :TelescopeBorder {:fg color.crust :bg color.crust}
   :TelescopePromptBorder {:fg color.crust :bg color.crust}
   :TelescopePromptNormal {:bg color.crust}
   :TelescopePromptPrefix {:fg color.blue :bg color.crust}
   :TelescopeNormal {:bg color.crust}
   :TelescopePreviewTitle {:fg color.crust :bg color.crust}
   :TelescopePromptTitle {:fg color.crust :bg color.blue}
   :TelescopeResultsNormal { :bg color.mantle}
   :TelescopeResultsBorder {:fg color.mantle :bg color.mantle}
   :TelescopeSelection {:bg color.crust :fg color.blue}
   :TelescopeSelectionCaret  {:fg color.blue}
   :TelescopeResultsDiffAdd {:fg color.green}
   :TelescopeResultsDiffChange {:fg color.yellow}
   :TelescopeResultsDiffDelete {:fg color.red}

   :NotifyINFOBody {:bg color.mantle}
   :NotifyWARNBody {:bg color.mantle}
   :NotifyERRORBody {:bg color.mantle}
   :NotifyDEBUGBody {:bg color.mantle}
   :NotifyTRACEBody {:bg color.mantle}

   :NotifyINFOBorder  {:fg color.mantle :bg color.mantle}
   :NotifyWARNBorder  {:fg color.mantle :bg color.mantle}
   :NotifyERRORBorder {:fg color.mantle :bg color.mantle}
   :NotifyDEBUGBorder {:fg color.mantle :bg color.mantle}
   :NotifyTRACEBorder {:fg color.mantle :bg color.mantle}

   :CmpItemKindSnippet {:fg color.crust :bg color.mauve}
   :CmpItemKindKeyword {:fg color.crust :bg color.red}
   :CmpItemKindText {:fg color.crust :bg color.teal}
   :CmpItemKindMethod {:fg color.crust :bg color.blue}
   :CmpItemKindConstructor {:fg color.crust :bg color.blue}
   :CmpItemKindFunction {:fg color.crust :bg color.blue}
   :CmpItemKindFolder {:fg color.crust :bg color.blue}
   :CmpItemKindModule {:fg color.crust :bg color.blue}
   :CmpItemKindConstant {:fg color.crust :bg color.peach}
   :CmpItemKindField {:fg color.crust :bg color.green}
   :CmpItemKindProperty {:fg color.crust :bg color.green}
   :CmpItemKindEnum {:fg color.crust :bg color.green}
   :CmpItemKindUnit {:fg color.crust :bg color.green}
   :CmpItemKindClass {:fg color.crust :bg color.yellow}
   :CmpItemKindVariable {:fg color.crust :bg color.flamingo}
   :CmpItemKindFile {:fg color.crust :bg color.blue}
   :CmpItemKindInterface {:fg color.crust :bg color.yellow}
   :CmpItemKindColor {:fg color.crust :bg color.red}
   :CmpItemKindReference {:fg color.crust :bg color.red}
   :CmpItemKindEnumMember {:fg color.crust :bg color.red}
   :CmpItemKindStruct {:fg color.crust :bg color.blue}
   :CmpItemKindValue {:fg color.crust :bg color.peach}
   :CmpItemKindEvent {:fg color.crust :bg color.blue}
   :CmpItemKindOperator {:fg color.crust :bg color.blue}
   :CmpItemKindTypeParameter {:fg color.crust :bg color.blue}

   :CmpItemKindCopilot {:fg color.crust :bg color.mauve}

   :NavicIconsFile {:bg color.surface2 :fg color.blue}
   :NavicIconsModule {:bg color.surface2 :fg color.blue}
   :NavicIconsNamespace {:bg color.surface2 :fg color.green}
   :NavicIconsPackage {:bg color.surface2 :fg color.maroon}
   :NavicIconsClass {:bg color.surface2 :fg color.peach}
   :NavicIconsMethod {:bg color.surface2 :fg color.lavender}
   :NavicIconsProperty {:bg color.surface2 :fg color.blue}
   :NavicIconsField {:bg color.surface2 :fg color.blue}
   :NavicIconsConstructor {:bg color.surface2 :fg color.blue}
   :NavicIconsEnum {:bg color.surface2 :fg color.blue}
   :NavicIconsInterface {:bg color.surface2 :fg color.blue}
   :NavicIconsFunction {:bg color.surface2 :fg color.blue}
   :NavicIconsVariable {:bg color.surface2 :fg color.blue}
   :NavicIconsConstant {:bg color.surface2 :fg color.blue}
   :NavicIconsString {:bg color.surface2 :fg color.blue}
   :NavicIconsNumber {:bg color.surface2 :fg color.blue}
   :NavicIconsBoolean {:bg color.surface2 :fg color.blue}
   :NavicIconsArray {:bg color.surface2 :fg color.blue}
   :NavicIconsObject {:bg color.surface2 :fg color.blue}
   :NavicIconsKey {:bg color.surface2 :fg color.blue}
   :NavicIconsNull {:bg color.surface2 :fg color.blue}
   :NavicIconsEnumMember {:bg color.surface2 :fg color.blue}
   :NavicIconsStruct {:bg color.surface2 :fg color.blue}
   :NavicIconsEvent {:bg color.surface2 :fg color.blue}
   :NavicIconsOperator {:bg color.surface2 :fg color.blue}
   :NavicIconsTypeParameter {:bg color.surface2 :fg color.blue}
   :NavicText {:fg color.text :bg color.surface2}
   :NavicSeparator {:fg color.text :bg color.surface2}})

{: custom-highlights}
