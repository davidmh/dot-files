-- [nfnl] fnl/plugins/markdown.fnl
local function _1_()
  return vim.fn["mkdp#util#install"]()
end
return {{"iamcco/markdown-preview.nvim", cmd = {"MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"}, event = "VeryLazy", build = _1_}}
