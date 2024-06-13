; extends

(block_mapping_pair
  (flow_node
    (plain_scalar (string_scalar) @_prop))
  (block_node
    (block_scalar) @injection.content)
  (#eq? @_prop "command")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "bash"))

(block_mapping_pair
  (flow_node
    (plain_scalar (string_scalar) @_prop))
  (block_node
    (block_scalar) @injection.content)
  (#eq? @_prop "await_cmd")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "bash"))

(block_mapping_pair
  key: (flow_node
          (plain_scalar
              (string_scalar) @_prop))
  value: (flow_node
            (plain_scalar
                (string_scalar) @injection.content))
 (#eq? @_prop "command")
 (#set! injection.language "bash"))

(block_mapping_pair
  key: (flow_node
          (plain_scalar
              (string_scalar) @_prop))
  value: (flow_node
            (plain_scalar
                (string_scalar) @injection.content))
 (#eq? @_prop "await_cmd")
 (#set! injection.language "bash"))

; JSON payload in slack/notify step
; https://circleci.com/developer/orbs/orb/circleci/slack
(block_mapping_pair
  (flow_node
    (plain_scalar
      (string_scalar) @_step))
  (block_node
    (block_mapping
      (block_mapping_pair
        (flow_node
          (plain_scalar
            (string_scalar) @_prop))
        (block_node
          (block_scalar) @injection.content))))
  (#eq? @_step "slack/notify")
  (#eq? @_prop "custom")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "json"))
