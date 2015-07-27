config = Config.get()
config.preventDefaultMouseEvents = false
config.fillWindow()

engine = new Engine3D()
engine.renderer.setClearColor('white')
engine.camera.position.set 0, 2, 7

editorScene = new EditorScene()
engine.addScene(editorScene)
engine.render()

ModelRepository.get().load((data) ->
  editorScene.draw(data[0].id)
  editorScene.loaded = true
)
