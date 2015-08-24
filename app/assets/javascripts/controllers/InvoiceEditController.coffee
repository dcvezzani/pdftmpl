controllers = angular.module('controllers')

controllers.controller("InvoiceEditController", [ '$scope', '$routeParams', '$resource', '$location', 'flash',
  ($scope,$routeParams,$resource,$location, flash)->

    Invoice = $resource('/invoices_ang/:invoiceId', { invoiceId: "@id", format: 'json' },
      {
        'save':   {method:'PUT'},
        'create': {method:'POST'}
      }
    )    

    if $routeParams.invoiceId
      Invoice.get({invoiceId: $routeParams.invoiceId},
        ( (invoice)-> $scope.invoice = invoice ),
        ( (httpResponse)->
          $scope.invoice = null
          flash.error   = "There is no invoice with ID #{$routeParams.invoiceId}"
        )
      )
    else
      $scope.invoice = {}

    $scope.back   = -> $location.path("/")
    $scope.edit   = -> $location.path("/invoices/#{$scope.invoice.id}/edit")

    $scope.cancel = ->
      if $scope.invoice.id
        $location.path("/invoices/#{$scope.invoice.id}")
      else
        $location.path("/")

    $scope.save = ->
      onError = (_httpResponse)-> flash.error = "Something went wrong"
      flash.success = 'Invoice saved!';
      if $scope.invoice.id
        $scope.invoice.$save(
          ( ()-> $location.path("/invoices/#{$scope.invoice.id}/edit") ),
          onError)
      else
        Invoice.create($scope.invoice,
          ( (newInvoice)-> $location.path("/invoices/#{newInvoice.id}/edit") ),
          onError
        )

    $scope.delete = ->
      $scope.invoice.$delete()
      $scope.back()

])
