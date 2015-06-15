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

controllers = angular.module('controllers',[])
