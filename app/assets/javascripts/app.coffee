receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',  
  'controllers',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      .when('/invoices',
        templateUrl: "invoices.html"
        controller: 'InvoicesController'
      )
])

recipes = []
# recipes = [
#   {
#     id: 1
#     name: 'Baked Potato w/ Cheese'
#   },
#   {
#     id: 2
#     name: 'Garlic Mashed Potatoes',
#   },
#   {
#     id: 3
#     name: 'Potatoes Au Gratin',
#   },
#   {
#     id: 4
#     name: 'Baked Brussel Sprouts',
#   },
# ]

controllers = angular.module('controllers',[])

controllers.controller("RecipesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->  
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)

    Recipe = $resource('/recipes/index', { format: 'json' })
    # Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' })
    # Recipe = $resource('/recipes', { format: 'json' })

    if $routeParams.keywords
      Recipe.query(keywords: $routeParams.keywords, (results)-> $scope.recipes = results)
      # keywords = $routeParams.keywords.toLowerCase()
      # $scope.recipes = recipes.filter (recipe)-> recipe.name.toLowerCase().indexOf(keywords) != -1
      
    else
      $scope.recipes = []
])

controllers.controller("InvoicesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->
    $scope.search = ()->  $location.path("/invoices")

    Invoice = $resource('/invoices', { format: 'json' })
    Invoice.query((results)-> $scope.invoices = results)
])
