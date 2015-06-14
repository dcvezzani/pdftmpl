receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',  
  'controllers',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/recipes',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      .when('/',
        templateUrl: "invoices.html"
        controller: 'InvoicesController'
      )
])

recipes = [
  {
    id: 1
    name: 'Baked Potato w/ Cheese'
  },
  {
    id: 2
    name: 'Garlic Mashed Potatoes',
  },
  {
    id: 3
    name: 'Potatoes Au Gratin',
  },
  {
    id: 4
    name: 'Baked Brussel Sprouts',
  },
]

controllers = angular.module('controllers',[])

controllers.controller("RecipesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->  
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)

    if $routeParams.keywords
      keywords = $routeParams.keywords.toLowerCase()
      $scope.recipes = recipes.filter (recipe)-> recipe.name.toLowerCase().indexOf(keywords) != -1
    else
      $scope.recipes = []
])

controllers.controller("InvoicesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->
    $scope.search = ()->  $location.path("/invoices")

    Invoice = $resource('/invoices', { format: 'json' })
    Invoice.query((results)-> $scope.invoices = results)
])
