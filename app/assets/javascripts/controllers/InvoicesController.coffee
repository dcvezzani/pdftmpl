controllers = angular.module('controllers')

controllers.controller("InvoicesController", [ '$scope', '$routeParams', '$location', '$resource', 'flash',
  ($scope,$routeParams,$location,$resource, flash)->
    $scope.search = ()->  $location.path("/")

    Invoice = $resource('/invoices', { format: 'json' })
    InvoiceAng = $resource('/invoices_ang/:invoiceId', { invoiceId: "@id", format: 'json' })

    Invoice.query((results)-> $scope.invoices = results)

    $scope.edit = (invoiceId)-> 
      InvoiceAng.get({invoiceId: invoiceId}).$promise.then(
        #//success
        (invoice)-> 
          $scope.invoice = invoice
          $location.path("/invoices/#{$scope.invoice.id}/edit")
        #//error
        (httpResponse)->
          console.log("fail")
          $scope.invoice = null
          flash.error   = "There is no invoice with ID #{invoiceId}"
      )
])

