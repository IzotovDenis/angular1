dashboard.controller "OrdersIndexCtrl", OrdersIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->

	$http.get("api/orders").success (data) ->
		$scope.orders = data

]