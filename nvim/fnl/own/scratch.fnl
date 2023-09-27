(local conjure (require :conjure.log))
(local core (require :nfnl.core))
(local str (require :nfnl.string))

(local state {:bufnr nil})

; assumes state.bufnr ~= nil
(fn new-scratch-split []
  (vim.api.nvim_ex.botright :split)
  (vim.api.nvim_win_set_buf (vim.api.nvim_get_current_win) state.bufnr)
  (vim.cmd "normal G"))

(fn initialize []
  (var bufnr (vim.api.nvim_create_buf false false))
  (vim.api.nvim_buf_set_option bufnr :filetype :fennel)
  (vim.api.nvim_buf_set_option bufnr :buftype :nofile)
  (vim.api.nvim_buf_set_lines bufnr 0 0 true ["(local core (require :nfnl.core))"
                                              ""
                                              ""])
  (tset state :bufnr bufnr)
  (new-scratch-split)
  (vim.cmd :ConjureEvalBuf))

(fn show []
  (if (= state.bufnr nil)
    ;; we need to initialize the scratch buffer's properties
    (initialize)

    ;; open an existing scratch buffer in a split window
    (let [winid (core.first (vim.fn.win_findbuf state.bufnr))]
      (if (= winid nil)
        ; open a new scratch split
        (new-scratch-split)

        ; focus the scratch window
        (vim.fn.win_gotoid winid)))))

; in theory this function won't be called at all, the scratch could live along
; the session indefinitely
(fn kill []
  (if (~= -1 state.bufnr)
    (do

      ; maybe close the window
      (let [winid (vim.fn.bufwinid state.bufnr)
            current-winid (vim.fn.winnr :$)]
        (if (and
              ; it's a valid window
              (~= -1 winid)
              ; the cursor is in it
              (= winid current-winid)
              ; it's not the only window remaining
              (~= 1 winid))
          (vim.api.nvim_win_close winid false)))

      ; delete the buffer
      (vim.api.nvim_buf_delete state.bufnr {:force true})

      ; reset the state
      (tset state :bufnr nil))

    (vim.notify "Nothing to kill")))

{: show
 : kill}
