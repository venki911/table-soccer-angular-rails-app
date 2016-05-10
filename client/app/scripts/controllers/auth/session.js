(function () {
  'use strict';

  angular
    .module('tableSoccerClientAngularApp')
    .controller('SessionCtrl', [
      '$rootScope',
      '$scope',
      '$location',
      SessionCtrl
    ]);

  function SessionCtrl($rootScope, $scope, $location) {
    var vm = this;

    if ($rootScope.user.id) {
      $location.path('/');
    }

    $scope.$on('auth:login-error', function (ev, reason) {
      $scope.error = reason.errors;
      // console.log($scope.error);
    });
  }
})();
