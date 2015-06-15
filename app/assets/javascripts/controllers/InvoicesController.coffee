controllers = angular.module('controllers')

controllers.controller("InvoicesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->
    $scope.search = ()->  $location.path("/")

    Invoice = $resource('/invoices', { format: 'json' })
    Invoice.query((results)-> $scope.invoices = results)
])

