receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',  
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'  
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/recipes',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      .when('/recipes/:recipeId',
        templateUrl: "show.html"
        controller: 'RecipeController'
      )
      .when('/',
        templateUrl: "invoices.html"
        controller: 'InvoicesController'
      )
])

controllers = angular.module('controllers',[])
