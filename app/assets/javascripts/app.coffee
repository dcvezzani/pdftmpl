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

controllers = angular.module('controllers',[])

controllers.controller("InvoicesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->
    $scope.search = ()->  $location.path("/invoices")

    Invoice = $resource('/invoices', { format: 'json' })
    Invoice.query((results)-> $scope.invoices = results)
])
