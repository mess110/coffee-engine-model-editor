class ModelRepository
  instance = null

  class PrivateClass
    constructor: () ->
      @models = []
      jNorthPole.BASE_URL = 'https://json.northpole.ro/'

    new: (callback) ->
      json =
        api_key: 'world'
        secret: 'world'
        name: 'untitled'
        position: {x: 0, y: 0, z: 0}
        rotation: {x: 0, y: 0, z: 0}
        scale: {x: 1, y: 1, z: 1}
        models: []
      jNorthPole.createStorage json, callback

    newSubModel: ->
      {
        type: 'box'
        options: {w: 1, h: 1, d: 1}
        position: {x: 0, y: 0, z: 0}
        rotation: {x: 0, y: 0, z: 0}
        scale: {x: 1, y: 1, z: 1}
        material:
          type: 'basic'
          options:
            color: '#ff0000'
      }

    save: (json, callback) ->
      json.api_key = 'world'
      json.secret = 'world'
      jNorthPole.putStorage json, callback

    load: (callback) ->
      responseHandler = (data) ->
        if data.length == 0
          console.log 'WARNING: no models found in repository'
        data = [data] unless data instanceof Array
        ModelRepository.get().models = data
        callback(data)

      jNorthPole.getStorage { api_key: 'world', secret: 'world' }, responseHandler

    findById: (id) ->
      models = @models.filter (m) -> m.id == id
      throw "Model with id #{id} not found" if models.length == 0
      models[0]

  @get: () ->
    instance ?= new PrivateClass()
