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

   :NotifyINFOIcon  {:fg color.mauve}
   :NotifyINFOTitle  {:fg color.mauve}
   :NotifyINFOBorder  {:fg color.mauve}

   :NotifyWARNBorder  {:fg color.overlay0}
   :NotifyERRORBorder {:fg color.overlay0}
   :NotifyDEBUGBorder {:fg color.overlay0}
   :NotifyTRACEBorder {:fg color.overlay0}

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

   :MiniStarterItemBullet {:fg :NONE :bg :NONE}
   :MiniStarterItemPrefix {:fg color.blue :bg :NONE}
   :MiniStarterQuery {:fg color.crust :bg color.blue}
   :MiniStarterFooter {:fg color.subtext0 :bg :NONE}

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
   :NavicSeparator {:fg color.text :bg color.surface2}

   :NoiceCmdline {:fg color.text :bg color.crust}
   :NoiceCmdlineIcon {:fg color.sky :bg color.crust}
   :NoiceCmdlineIconSearch {:fg color.yellow :bg color.crust}
   :NoiceCmdlinePopup {:fg color.text :bg color.crust}
   :NoiceCmdlinePopupBorder {:fg color.crust :bg color.crust}
   :NoiceCmdlinePopupBorderSearch {:fg color.crust :bg color.crust}
   :NoiceConfirmBorder {:fg color.crust :bg color.crust}})

{: custom-highlights}
