class EditorScene extends BaseScene
  constructor: ->
    super()

    grid = new THREE.GridHelper(3, 2)
    @scene.add grid

    @domEvents = new THREEx.DomEvents(engine.camera, engine.renderer.domElement)

    @controls = new THREE.OrbitControls(engine.camera)
    @control = new THREE.TransformControls(engine.camera, engine.renderer.domElement)

  draw: (json) ->
    @removeModel() if @model?
    @addModel(json)

  addModel: (json) ->
    console.log "Drawing #{json.name}"
    @model = new JsonModel(json)
    @scene.add @model.mesh

    for subModel in @model.children
      @domEvents.addEventListener(subModel, 'click', (event) ->
        console.log 'clicked'
      , false)

  removeModel: ->
    console.log "Removing #{@model.json.name}"
    for subModel in @model.children
      @domEvents.removeEventListener(subModel, 'click', () -> {})
    @scene.remove @model.mesh

  tick: (tpf) ->
    return unless @loaded
    console.log 'hello'

  doMouseEvent: (event, raycaster) ->

  doKeyboardEvent: (event) ->
