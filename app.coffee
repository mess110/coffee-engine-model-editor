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

  $scope.load = (model) ->
    $scope.selectedRaw = JSON.stringify(model, null, 2)

  $scope.save = (model) ->
    json = JSON.parse($scope.selectedRaw)
    ModelRepository.get().save(json, ->
      $scope.reload()
      editorScene.draw(json)
      $scope.selected = editorScene.model.json
      $scope.selectedRaw = JSON.stringify($scope.selected, null, 2)
    )

  $scope.$watch 'selectedRaw', (newValue, oldValue) ->
    return unless newValue?
    try
      $scope.hash = JSON.parse(newValue)
    catch e
      console.log e
    finally
      editorScene.draw($scope.hash)
