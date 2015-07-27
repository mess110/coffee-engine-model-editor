class JsonModel
  constructor: (json) ->
    @json = json
    @children = []

    throw 'id missing' unless json.id?
    throw 'name missing' unless json.name?
    console.log 'no models found' if json.models.length == 0

    @mesh = new THREE.Object3D()
    for subModel in json.models
      mesh = Utils.getSubModel(subModel)
      @mesh.add mesh
      Utils.applyTransformations(mesh, subModel)
      @children.push mesh
    Utils.applyTransformations(@mesh, json)

  export: ->
    @json
