class Utils
  @applyTransformations: (obj, json)->
    @setPosition(obj, json.position)
    @setRotation(obj, json.rotation)
    @setScale(obj, json.scale)

  @setScale: (obj, json={}) ->
    json.x = 1 unless json.x?
    json.y = 1 unless json.y?
    json.z = 1 unless json.z?
    obj.scale.set json.x, json.y, json.z

  @setPosition: (obj, json={}) ->
    json.x = 0 unless json.x?
    json.y = 0 unless json.y?
    json.z = 0 unless json.z?
    obj.position.set json.x, json.y, json.z

  @setRotation: (obj, json={}) ->
    json.x = 0 unless json.x?
    json.y = 0 unless json.y?
    json.z = 0 unless json.z?
    obj.rotation.set json.x, json.y, json.z

  @getMaterial: (json={ type: 'none' }) ->
    defaultOptions = { color: 'purple' }
    switch json.type
      when 'basic'
        json.options = defaultOptions unless json.options?
        new THREE.MeshBasicMaterial(json.options)
      else
        new THREE.MeshBasicMaterial(defaultOptions)

  @getGeometry: (json) ->
    throw "missing type" unless json.type?
    switch json.type
      when 'box'
        json.options = {} unless json.options?
        json.options.w = 1 unless json.options.w?
        json.options.h = 1 unless json.options.h?
        json.options.d = 1 unless json.options.d?
        new THREE.BoxGeometry(json.options.w, json.options.h, json.options.d)
      else
        throw "Unkown geometry type #{type}"

  @getSubModel: (json) ->
    throw 'type missing' unless json.type?

    switch json.type
      when 'box'
        geometry = Utils.getGeometry(json)
        material = Utils.getMaterial(json.material)
        mesh = new THREE.Mesh(geometry, material)
      when 'json'
        repoModel = ModelRepository.get().findById(json.id)
        jsonModel = new JsonModel(repoModel)
        mesh = jsonModel.mesh
      else
        throw "Unknown type #{json.type}"
    mesh
