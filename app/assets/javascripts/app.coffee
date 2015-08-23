receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',  
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'  
])

receta.config([ '$routeProvider', 'flashProvider',
  ($routeProvider,flashProvider)->

    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when('/recipes',
        templateUrl: "index.html"
        controller: 'RecipesController'

      ).when('/recipes/new',
        templateUrl: "form.html"
        controller: 'RecipeController'

      ).when('/recipes/:recipeId',
        templateUrl: "show.html"
        controller: 'RecipeController'

      ).when('/recipes/:recipeId/edit',
        templateUrl: "form.html"
        controller: 'RecipeController'

      ).when('/invoices/:invoiceId/edit',
        templateUrl: "invoice_edit_form.html"
        controller: 'InvoiceEditController'

      ).when('/',
        templateUrl: "invoices.html"
        controller: 'InvoicesController'
      )
])


controllers = angular.module('controllers',[])
