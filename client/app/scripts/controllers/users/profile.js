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
      'tournamentService',
      '$uibModal',
      ProfileCtrl
    ]);

  function ProfileCtrl(tournamentService, $uibModal) {
    var vm = this;

    function getAll() {
      tournamentService.all()
        .success(function (tournaments) {
          vm.tournaments = tournaments;
        })
        .error(function (message) {
          vm.errors = message;
          console.log(message)
        });
    }
    getAll();

    vm.changeAvatarModal = function () {
      $uibModal
        .open({
          templateUrl: 'views/modal.html',
          controller: 'ChangeAvatarCtrl',
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
