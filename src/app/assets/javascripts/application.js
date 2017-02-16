// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var app = angular.module('myApp', []);
app.controller('dashboardCtrl', function($scope, $http) {
    initialize();
    
    function initialize() {
      $http.get('/access-keys', $scope.accessKeysForm )
        .success(function(data, status, headers, config) {  
        $scope.accessKeysForm = data.keys;      
      })
      .error(function(data, status, headers, config) {
      alert( "failure message: " + JSON.stringify({data: data}));
      });
    }
   
    $scope.refresh = function() {
      $scope.refreshing = true;
      
      $http.get('/stacks', $scope.accessKeysForm )
        .success(function(data, status, headers, config) {  
        $scope.refreshing = false;
        alert(angular.toJson(data));
      })
      .error(function(data, status, headers, config) {
      $scope.refreshing = false;
      alert( "failure message: " + JSON.stringify({data: data}));
      });
    };
    
    $scope.onClickSaveAccessKeysBtn = function() {    
      $http.post('/access-keys', $scope.accessKeysForm )
        .success(function(data, status, headers, config) {  
        $scope.message = data;
      })
      .error(function(data, status, headers, config) {
        alert( "failure message: " + JSON.stringify({data: data}));
      });
    };
});