-- [nfnl] fnl/plugins/markdown.fnl
local function _1_()
  return vim.fn["mkdp#util#install"]()
end
return {{"iamcco/markdown-preview.nvim", cmd = {"MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"}, event = "VeryLazy", build = _1_}, {"MeanderingProgrammer/render-markdown.nvim", opts = {file_types = {"markdown"}, heading = {position = "inline", sign = false}, code = {sign = false}}, ft = {"markdown"}}}
