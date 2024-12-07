-- [nfnl] Compiled from fnl/plugins/markdown.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  return vim.fn["mkdp#util#install"]()
end
return {{"iamcco/markdown-preview.nvim", cmd = {"MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"}, ft = {"markdown"}, build = _1_}, {"MeanderingProgrammer/render-markdown.nvim", opts = {file_types = {"markdown", "Avante"}}, ft = {"markdown", "Avante"}}}
