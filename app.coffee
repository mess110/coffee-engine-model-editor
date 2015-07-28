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

angular.module('coffeeEngineModelEditor', ['ui.bootstrap'])

.controller 'MainController', ($scope, $timeout) ->
  $scope.reload = ->
    ModelRepository.get().load((data) ->
      $scope.models = ModelRepository.get().models
      $scope.$apply()
    )
  $scope.reload()

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

  $scope.loadModel = (model) ->
    $scope.hashRaw = angular.toJson(model, 2)

  for i in ['name', 'position.x', 'position.y', 'position.z', 'rotation.x', 'rotation.y', 'rotation.z', 'scale.x', 'scale.y', 'scale.z']
    $scope.$watch "hash.#{i}", (newValue, oldValue) ->
      return unless newValue?
      $scope.hashRaw = angular.toJson($scope.hash, 2)

  $scope.$watch 'hashRaw', (newValue, oldValue) ->
    return unless newValue?
    try
      $scope.hash = JSON.parse(newValue)
    catch e
      console.log e
    finally
      editorScene.draw($scope.hash)
