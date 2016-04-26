/// <reference path="angular.min.js">
var app =angular
        .module("myModule",[])
        .controller("myController",function($scope,$http){
                  
            var parcels={
              dhlParcels:{
                  notarrivedChina:[],
                  arrivedChina:[]
              },
            
              bpostParcels:{
                  notarrivedChina:[],
                  arrivedChina:[]
              }
            };  
            //$scope.queryFormData = { }; here to force a json object for form param 
            // but we dont need it since our rest service need string instead of json as input
            // calling our submit function.
            $scope.submitForm = function() {
                                     
                $http({
                    method: 'POST',
                    url: 'rest/query/post',
                    data: $.param($scope.queryFormData),
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                }) .success(function(data,status) {
                        console.log(data);
                        console.log(status);
                        if (status=200) {
                            // Successful
                            parcels=data;
                            $scope.parcels=parcels;
                        } 
                    });
            };
            
            
        });