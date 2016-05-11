(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:ProfileCtrl
   * @description
   * # ProfileCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('ProfileCtrl', [
      '$rootScope',
      '$auth',
      'UserService',
      '$uibModal',
      ProfileCtrl
    ]);

  function ProfileCtrl($rootScope, $auth, UserService, $uibModal) {
    var vm = this;
    function getAll() {
      $auth.validateUser().then(function () {
        UserService.profileInfo($rootScope.user.id)
          .success(function (info) {
            vm.tournaments = info.profile.tournaments;
            vm.teams = info.profile.teams;
          })
          .error(function (message) {
            vm.errors = message;
            console.log(message)
          });
      });
    }
    getAll();

    vm.changeAvatarModal = function () {
      $uibModal
        .open({
          templateUrl: 'views/modal.html',
          controller: 'ChangeAvatarCtrl'
        })
    };

    vm.changePasswordModal = function () {
      $uibModal
        .open({
          templateUrl: 'views/modal.html',
          controller: 'ChangePasswordCtrl'
        })
    }
  }
})();
