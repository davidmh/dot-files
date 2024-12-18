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

   :SnacksNotifierIconInfo  {:fg color.mauve :bg color.mantle}
   :SnacksNotifierIconError {:fg color.red :bg color.mantle}
   :SnacksNotifierIconWarn  {:fg color.yellow :bg color.mantle}
   :SnacksNotifierIconDebug {:fg color.peach :bg color.mantle}
   :SnacksNotifierIconTrace {:fg color.flamingo :bg color.mantle}

   :SnacksNotifierTitleInfo  {:fg color.mauve :bg color.mantle}
   :SnacksNotifierTitleError {:fg color.red :bg color.mantle}
   :SnacksNotifierTitleWarn  {:fg color.yellow :bg color.mantle}
   :SnacksNotifierTitleDebug {:fg color.peach :bg color.mantle}
   :SnacksNotifierTitleTrace {:fg color.flamingo :bg color.mantle}

   :SnacksNotifierInfo {:bg color.mantle}
   :SnacksNotifierWarn {:bg color.mantle}
   :SnacksNotifierError {:bg color.mantle}
   :SnacksNotifierDebug {:bg color.mantle}
   :SnacksNotifierTrace {:bg color.mantle}

   :SnacksNotifierBorderInfo  {:fg color.mantle :bg color.mantle}
   :SnacksNotifierBorderWarn  {:fg color.mantle :bg color.mantle}
   :SnacksNotifierBorderError {:fg color.mantle :bg color.mantle}
   :SnacksNotifierBorderDebug {:fg color.mantle :bg color.mantle}
   :SnacksNotifierBorderTrace {:fg color.mantle :bg color.mantle}

   :BlinkCmpKindSnippet {:fg color.crust :bg color.mauve}
   :BlinkCmpKindKeyword {:fg color.crust :bg color.red}
   :BlinkCmpKindText {:fg color.crust :bg color.teal}
   :BlinkCmpKindMethod {:fg color.crust :bg color.blue}
   :BlinkCmpKindConstructor {:fg color.crust :bg color.blue}
   :BlinkCmpKindFunction {:fg color.crust :bg color.blue}
   :BlinkCmpKindFolder {:fg color.crust :bg color.blue}
   :BlinkCmpKindModule {:fg color.crust :bg color.blue}
   :BlinkCmpKindConstant {:fg color.crust :bg color.peach}
   :BlinkCmpKindField {:fg color.crust :bg color.green}
   :BlinkCmpKindProperty {:fg color.crust :bg color.green}
   :BlinkCmpKindEnum {:fg color.crust :bg color.green}
   :BlinkCmpKindUnit {:fg color.crust :bg color.green}
   :BlinkCmpKindClass {:fg color.crust :bg color.yellow}
   :BlinkCmpKindVariable {:fg color.crust :bg color.flamingo}
   :BlinkCmpKindFile {:fg color.crust :bg color.blue}
   :BlinkCmpKindInterface {:fg color.crust :bg color.yellow}
   :BlinkCmpKindColor {:fg color.crust :bg color.red}
   :BlinkCmpKindReference {:fg color.crust :bg color.red}
   :BlinkCmpKindEnumMember {:fg color.crust :bg color.red}
   :BlinkCmpKindStruct {:fg color.crust :bg color.blue}
   :BlinkCmpKindValue {:fg color.crust :bg color.peach}
   :BlinkCmpKindEvent {:fg color.crust :bg color.blue}
   :BlinkCmpKindOperator {:fg color.crust :bg color.blue}
   :BlinkCmpKindTypeParameter {:fg color.crust :bg color.blue}

   :MiniStarterItemBullet {:fg :NONE :bg :NONE}
   :MiniStarterItemPrefix {:fg color.blue :bg :NONE}
   :MiniStarterQuery {:fg color.crust :bg color.blue}
   :MiniStarterFooter {:fg color.subtext0 :bg :NONE}

   :NavicIconsFile {:bg :NONE :fg color.blue :bold true}
   :NavicIconsModule {:bg :NONE :fg color.blue :bold true}
   :NavicIconsNamespace {:bg :NONE :fg color.green :bold true}
   :NavicIconsPackage {:bg :NONE :fg color.maroon :bold true}
   :NavicIconsClass {:bg :NONE :fg color.peach :bold true}
   :NavicIconsMethod {:bg :NONE :fg color.lavender :bold true}
   :NavicIconsProperty {:bg :NONE :fg color.blue :bold true}
   :NavicIconsField {:bg :NONE :fg color.blue :bold true}
   :NavicIconsConstructor {:bg :NONE :fg color.blue :bold true}
   :NavicIconsEnum {:bg :NONE :fg color.blue :bold true}
   :NavicIconsInterface {:bg :NONE :fg color.blue :bold true}
   :NavicIconsFunction {:bg :NONE :fg color.blue :bold true}
   :NavicIconsVariable {:bg :NONE :fg color.blue :bold true}
   :NavicIconsConstant {:bg :NONE :fg color.blue :bold true}
   :NavicIconsString {:bg :NONE :fg color.blue :bold true}
   :NavicIconsNumber {:bg :NONE :fg color.blue :bold true}
   :NavicIconsBoolean {:bg :NONE :fg color.blue :bold true}
   :NavicIconsArray {:bg :NONE :fg color.blue :bold true}
   :NavicIconsObject {:bg :NONE :fg color.blue :bold true}
   :NavicIconsKey {:bg :NONE :fg color.blue :bold true}
   :NavicIconsNull {:bg :NONE :fg color.blue :bold true}
   :NavicIconsEnumMember {:bg :NONE :fg color.blue :bold true}
   :NavicIconsStruct {:bg :NONE :fg color.blue :bold true}
   :NavicIconsEvent {:bg :NONE :fg color.blue :bold true}
   :NavicIconsOperator {:bg :NONE :fg color.blue :bold true}
   :NavicIconsTypeParameter {:bg :NONE :fg color.blue :bold true}
   :NavicText {:fg color.text :bg :NONE :bold true}
   :NavicSeparator {:fg color.blue :bg :NONE :bold true}

   :NoiceCmdline {:fg color.text :bg color.crust}
   :NoiceCmdlineIcon {:fg color.sky :bg color.crust}
   :NoiceCmdlineIconSearch {:fg color.yellow :bg color.crust}
   :NoiceCmdlinePopup {:fg color.text :bg color.crust}
   :NoiceCmdlinePopupBorder {:fg color.crust :bg color.crust}
   :NoiceCmdlinePopupBorderSearch {:fg color.crust :bg color.crust}
   :NoiceConfirmBorder {:fg color.crust :bg color.crust}})

{: custom-highlights}
