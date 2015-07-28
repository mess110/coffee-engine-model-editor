class JsonObject
  constructor: (json) ->
    @json = json

    throw 'name missing' unless json.name?
    @name = json.name

    throw 'id missing' unless json.id?
    @id = json.id

    console.log 'no models found' if json.models.length == 0

    @mesh = new THREE.Mesh()
    @mesh.name = @name

    @applyTransformations(@mesh, @json)

  add: (obj) ->
    geometry = @json2Geometry(obj)
    if geometry instanceof THREE.BoxGeometry
      material = @json2Material(obj.material)
      mesh = new THREE.Mesh(geometry, material)
    else if geometry instanceof JsonObject
      mesh = geometry.mesh
    else
      throw 'fuck'
    @applyTransformations(mesh, obj)
    @mesh.add mesh
    mesh

  export: ->
    json = {
      id: @id,
      name: @name,
      position: @mesh.position
      rotation: @mesh.rotation.toVector3()
      scale: @mesh.scale,
      models: []
    }
    for child in @mesh.children
      if child instanceof THREE.Mesh
        if child.geometry instanceof THREE.BoxGeometry
          if child.material instanceof THREE.MeshBasicMaterial
            jsonMaterial = {
              type: 'basic'
              options: {
                color: child.material.color.getHex()
              }
            }

          json.models.push {
            type: 'box'
            options: {
              w: child.geometry.parameters.width
              h: child.geometry.parameters.height
              d: child.geometry.parameters.depth
            }
            position: child.position
            rotation: child.rotation.toVector3()
            scale: child.scale
            material: jsonMaterial
          }
    json

  json2Geometry: (json) ->
    switch json.type
      when 'box'
        new THREE.BoxGeometry(json.options.w, json.options.h, json.options.d)
      when 'json'
        asd = ModelRepository.get().models.filter (x) -> x.id == json.id
        throw 'shit' if asd.length == 0
        bar = new JsonObject(asd[0])
        for obj in bar.json.models
          editorScene.add(obj)
      else
        throw "Unkown geometry type #{type}"

  applyTransformations: (obj, json)->
    @setPosition(obj, json.position)
    @setRotation(obj, json.rotation)
    @setScale(obj, json.scale)

  json2Material: (json={type: 'none'}) ->
    switch json.type
      when 'basic'
        new THREE.MeshBasicMaterial(json.options)
      else
        new THREE.MeshBasicMaterial(color: 'purple')

  setScale: (obj, json={}) ->
    json.x = 1 unless json.x?
    json.y = 1 unless json.y?
    json.z = 1 unless json.z?
    obj.scale.set json.x, json.y, json.z

  setPosition: (obj, json={}) ->
    json.x = 0 unless json.x?
    json.y = 0 unless json.y?
    json.z = 0 unless json.z?
    obj.position.set json.x, json.y, json.z

  setRotation: (obj, json={}) ->
    json.x = 0 unless json.x?
    json.y = 0 unless json.y?
    json.z = 0 unless json.z?
    obj.rotation.set json.x, json.y, json.z
