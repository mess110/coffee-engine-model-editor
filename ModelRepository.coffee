class ModelRepository
  instance = null

  class PrivateClass
    constructor: () ->
      @models = []
      jNorthPole.BASE_URL = 'https://json.northpole.ro/'

    load: (callback) ->
      responseHandler = (data) ->
        if data.length == 0
          console.log 'WARNING: no models found in repository'
        data = [data] unless data instanceof Array
        ModelRepository.get().models = data
        callback(data)

      jNorthPole.getStorage { api_key: 'world', secret: 'world' }, responseHandler

    save: (json, callback) ->
      json.api_key = 'world'
      json.secret = 'world'
      jNorthPole.putStorage json, callback

    saveCurrent: ->
      @save(editorScene.model.json, (data) ->
        editorScene.draw(data)
      )

    findById: (id) ->
      models = @models.filter (m) -> m.id == id
      throw "Model with id #{id} not found" if models.length == 0
      models[0]

  @get: () ->
    instance ?= new PrivateClass()
