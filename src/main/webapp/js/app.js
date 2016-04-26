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
            // $scope.queryFormData = { }; this does not work when submit form are not entered 
            $scope.queryFormData = { dhlcodes:"",bpostcodes:"" };
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
                            // Showing errors.
                            $scope.parcels=data;
                        } 
                    });
            };
            
            
        });