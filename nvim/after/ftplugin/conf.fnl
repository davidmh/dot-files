(match (-> (vim.fn.expand :%:t)
           (vim.split :. {:plain true}))
  [:DOCKERFILE] (set vim.bo.ft :dockerfile)
  [_ :rbi] (set vim.bo.ft :ruby))
