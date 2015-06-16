controllers = angular.module('controllers')

recipes = []

controllers.controller("RecipesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->  
    $scope.search = (keywords)->  $location.path("/recipes").search('keywords',keywords)

    Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' })

    if $routeParams.keywords
      Recipe.query(keywords: $routeParams.keywords, (results)-> $scope.recipes = results)
      
    else
      $scope.recipes = []
])

