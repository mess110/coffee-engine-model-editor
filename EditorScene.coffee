class EditorScene extends BaseScene
  constructor: ->
    super()

    grid = new THREE.GridHelper(3, 2)
    @scene.add grid

    @domEvents = new THREEx.DomEvents(engine.camera, engine.renderer.domElement)

    @controls = new THREE.OrbitControls(engine.camera)
    @control = new THREE.TransformControls(engine.camera, engine.renderer.domElement)

  draw: (modelId) ->
    json = ModelRepository.get().findById(modelId)
    @removeModel() if @model?
    @addModel(json)

  focus: (model) ->
    @control.attach(model)
    @scene.add @control

  blur: () ->
    @control.detach({})
    @scene.remove @control

  addModel: (json) ->
    console.log "Drawing #{json.name}"
    @model = new JsonModel(json)
    @scene.add @model.mesh

    for subModel in @model.children
      @domEvents.addEventListener(subModel, 'click', (event) ->
        editorScene.focus(event.target)
      , false)

  removeModel: ->
    console.log "Removing #{@model.json.name}"
    @scene.remove @model.mesh
    @blur()

  tick: (tpf) ->
    return unless @loaded
    @controls.update()

  doMouseEvent: (event, raycaster) ->

  doKeyboardEvent: (event) ->
