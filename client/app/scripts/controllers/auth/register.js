(function () {
  'use strict';

  angular
    .module('tableSoccerClientAngularApp')
    .controller('RegisterCtrl', [
      '$rootScope',
      '$scope',
      '$location',
      '$auth',
      RegisterCtrl
    ]);

  function RegisterCtrl($rootScope, $scope, $location, $auth) {
    var vm = this;
        
    if ($rootScope.user.id) {
      $location.path('/');
    }

    $scope.$on('auth:registration-email-error', function(ev, reason) {
      $scope.error = reason.errors;
    });
    $scope.$on('auth:registration-email-success', function(ev, message) {
      window.alert("A confirmation email was sent to " + message.email);
    });
    $scope.handleRegBtnClick = function () {
      $auth.submitRegistration($scope.registrationForm)
        .then(function () {
          $location.path('/');
          // $auth.submitLogin({
          //   // first_name: $scope.registrationForm.first_name,
          //   // last_name: $scope.registrationForm.last_name,
          //   email: $scope.registrationForm.email,
          //   password: $scope.registrationForm.password
          // })
        })
    }

  }
})();
