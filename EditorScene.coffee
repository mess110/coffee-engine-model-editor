class EditorScene extends BaseScene
  constructor: ->
    super()

    grid = new THREE.GridHelper(3, 2)
    @scene.add grid

    @domEvents = new THREEx.DomEvents(engine.camera, engine.renderer.domElement)

    @controls = new THREE.OrbitControls(engine.camera)
    @control = new THREE.TransformControls(engine.camera, engine.renderer.domElement)

    @light = new THREE.DirectionalLight(0xffffff, 1.0)
    @light.position.set(320, 390, 700)
    @scene.add @light

    light = new THREE.AmbientLight( 0x404040 );
    @scene.add( light )

    @loaded = true

  draw: (json) ->
    @removeModel() if @model?
    @addModel(json)

  addModel: (json) ->
    console.log "Drawing #{json.name}"
    @model = new JsonModel(json)
    @scene.add @model.mesh

    for subModel in @model.children
      @domEvents.addEventListener(subModel, 'click', (event) ->

        angular.fromOutside (scope) ->
          scope.setSelected(event.target.json.zIndex)

      , false)

  removeModel: ->
    console.log "Removing #{@model.json.name}"
    for subModel in @model.children
      @domEvents.removeEventListener(subModel, 'click', () -> {})
    @scene.remove @model.mesh

  tick: (tpf) ->

  doMouseEvent: (event, raycaster) ->
    return if event.type != 'mouseup'
    angular.fromOutside (scope) ->
      scope.setSelected(undefined)

  doKeyboardEvent: (event) ->
