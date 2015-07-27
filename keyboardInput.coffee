window.addEventListener 'keydown', (event) ->
  return unless editorScene.model?
  console.log event.keyCode
  switch event.keyCode
    when 27 # ESC
      editorScene.blur()
    when 83 # S
      ModelRepository.get().save(editorScene.model, (data) ->
        editorScene.draw(data.id)
      )
    when 81 # Q
      editorScene.control.setSpace if editorScene.control.space == 'local' then 'world' else 'local'
    when 87
      # W
      editorScene.control.setMode 'translate'
    when 69
      # E
      editorScene.control.setMode 'rotate'
    when 82
      # R
      editorScene.control.setMode 'scale'
    when 187, 107
      # +,=,num+
      editorScene.control.setSize editorScene.control.size + 0.1
    when 189, 10
      # -,_,num-
      editorScene.control.setSize Math.max(editorScene.control.size - 0.1, 0.1)
