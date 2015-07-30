config = Config.get()
config.preventDefaultMouseEvents = false
config.width = window.innerWidth / 2
config.height = window.innerHeight

engine = new Engine3D()
engine.renderer.setClearColor('white')
engine.camera.position.set 0, 2, 7

editorScene = new EditorScene()
engine.addScene(editorScene)
engine.render()

angular.fromOutside = (callback)->
  scope = angular.element(document.body).scope()
  scope.$apply callback(scope)

angular.module('coffeeEngineModelEditor', ['ui.bootstrap'])

.controller 'MainController', ($scope, $timeout) ->
  $scope.allowedTypes = ['json', 'box']
  $scope.names = ['asd', 'bar']
  $scope.reload = ->
    ModelRepository.get().load((data) ->
      $scope.models = ModelRepository.get().models
      $scope.$apply()
    )
  $scope.reload()
  watchers = []

  callback = (json) ->
    $scope.reload()
    editorScene.draw(json)
    $scope.hash = editorScene.model.json
    $scope.hashRaw = angular.toJson($scope.hash, 2)

  $scope.newModel = ->
    ModelRepository.get().new(callback)

  $scope.saveModel = (model) ->
    json = JSON.parse($scope.hashRaw)
    ModelRepository.get().save(json, callback)

  $scope.addSubModel = () ->
    subModel = ModelRepository.get().newSubModel()
    $scope.hash.models.push subModel
    $scope.selected = $scope.hash.models.length - 1

  $scope.cloneSelectedSubModel = () ->
    return unless $scope.selected?
    subModel = angular.copy($scope.hash.models[$scope.selected])
    $scope.hash.models.push subModel
    $scope.selected = $scope.hash.models.length - 1

  $scope.deleteSelectedSubModel = ->
    return unless $scope.selected?
    $scope.hash.models.splice($scope.selected, 1)
    $scope.selected = undefined

  $scope.loadModel = (model) ->
    $scope.hashRaw = angular.toJson(model, 2)

  $scope.setSelected = (i) ->
    $scope.selected = i
    reinitWatchers()

  reinitWatchers = ->
    for watch in watchers
      watch()

    for i in ['name', 'position.x', 'position.y', 'position.z', 'rotation.x', 'rotation.y', 'rotation.z', 'scale.x', 'scale.y', 'scale.z']
      a = $scope.$watch "hash.#{i}", (newValue, oldValue) ->
        return unless newValue?
        $scope.hashRaw = angular.toJson($scope.hash, 2)
      watchers.push a

    a = $scope.$watch 'hash.models.length', (newValue, oldValue) ->
      return if newValue == oldValue
      console.log $scope.hash
      $scope.hashRaw = angular.toJson($scope.hash, 2)
    watchers.push a

    if $scope.selected?
      for i in ['id', 'type', 'name', 'position.x', 'position.y', 'position.z', 'rotation.x', 'rotation.y', 'rotation.z', 'scale.x', 'scale.y', 'scale.z', 'options.w', 'options.h', 'options.d']
        a = $scope.$watch "hash.models[#{$scope.selected}].#{i}", (newValue, oldValue) ->
          return unless newValue?
          $scope.hashRaw = angular.toJson($scope.hash, 2)
        watchers.push a

      if $scope.hash.models[$scope.selected]? and $scope.hash.models[$scope.selected].type == 'box'
        $scope.$watch "hash.models[#{$scope.selected}].material.options.color", (newValue, oldValue) ->
          return unless newValue?
          $scope.hashRaw = angular.toJson($scope.hash, 2)
          watchers.push a

  $scope.$watch 'hashRaw', (newValue, oldValue) ->
    return unless newValue?
    try
      $scope.hash = JSON.parse(newValue)
    catch e
      console.log e
    finally
      reinitWatchers()
      editorScene.draw($scope.hash)
