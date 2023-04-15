(module own.plugin.colorscheme
  {autoload {catppuccin catppuccin
             palette catppuccin.palettes}})

(def- color (palette.get_palette))

(defn- custom-highlights []
  {:Comment {:style [:italic :bold]}
   :Pmenu {:bg color.crust}
   :WinSeparator {:fg color.overlay0 :bg :none}

   :NormalFloat {:link :Normal}

   :TreesitterContext {:link :Normal}

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
   :CmpItemKindCopilot {:fg color.crust :bg color.teal}})

(catppuccin.setup {:flavour :macchiato
                   :transparent_background false
                   :term_colors true
                   :integrations {:lsp_trouble true
                                  :telescope true
                                  :which_key true}
                   :custom_highlights custom-highlights})

(vim.cmd.colorscheme :catppuccin)
