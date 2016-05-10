(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:ChangePasswordCtrl
   * @description
   * # ChangePasswordCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('ChangePasswordCtrl', [
      '$scope',
      '$uibModalInstance',
      '$auth',

      ChangePasswordCtrl
    ]);

  function ChangePasswordCtrl($scope, $uibModalInstance, $auth) {
    var vm = this;
    $scope.templateUrl = "views/users/update_password.html";
    $scope.title = "Change password";
    $scope.action = 'Update';

    $scope.updatePasswordForm = {
      // current_password: '',
      // password: '',
      // password_confirmation: ''
    };

    $scope.ok = function () {
      // console.log($scope.updatePasswordForm);
      $auth.updatePassword($scope.updatePasswordForm).then(function () {
        $uibModalInstance.close();
      }, function (msg) {
        $scope.error = msg;
      });
    };

    $scope.cancel = function () {

      $uibModalInstance.dismiss();
    };
  }
})();
