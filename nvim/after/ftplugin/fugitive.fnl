(import-macros {: nmap} :own.macros)

(nmap :p "<cmd>Neogit pull<cr>" {:desc "git pull" :buffer true :nowait true})
(nmap :P "<cmd>Neogit push<cr>" {:desc "git push" :buffer true :nowait true})
(nmap :b "<cmd>Neogit branch<cr>" {:desc "git branch" :buffer true :nowait true})
