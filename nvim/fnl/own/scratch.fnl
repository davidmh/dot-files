(module own.scratch
  {autoload {nvim aniseed.nvim
             util aniseed.nvim.util
             conjure conjure.log
             core aniseed.core
             str aniseed.string}})

(defonce- state {:bufnr nil})

; assumes state.bufnr ~= nil
(defn- new-scratch-split []
  (nvim.ex.botright :split)
  (nvim.win_set_buf (nvim.get_current_win) state.bufnr)
  (util.normal :G))

(defn- initialize []
  (var bufnr (nvim.create_buf false false))
  (vim.api.nvim_buf_set_option bufnr :filetype :fennel)
  (vim.api.nvim_buf_set_option bufnr :buftype :nofile)
  (nvim.buf_set_lines bufnr 0 0 true ["(module scratch {autoload {nvim aniseed.nvim"
                                      "                           core aniseed.core}})"
                                      ""
                                      ""])
  (tset state :bufnr bufnr)
  (new-scratch-split)
  (vim.cmd :ConjureEvalBuf))

(defn show []
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
(defn kill []
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
          (nvim.win_close winid false)))

      ; delete the buffer
      (nvim.buf_delete state.bufnr {:force true})

      ; reset the state
      (tset state :bufnr nil))

    (vim.notify "Nothing to kill")))
