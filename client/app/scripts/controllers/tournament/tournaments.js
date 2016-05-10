(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TournamentsCtrl
   * @description
   * # TournamentsCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TournamentsCtrl', [
      'tournamentService',
      '$uibModal',
      TournamentsCtrl
    ]);

  function TournamentsCtrl(tournamentService, $uibModal) {
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

    vm.openNewModalWindow = function () {
 
      $uibModal
        .open({
        templateUrl: 'views/modal.html',
        controller: 'TournamentsNewCtrl'
        })
        .result.then(function (result) {
        vm.tournaments.push(result);
      })
    };

    vm.editModalWindow = function (tournament) {
      $uibModal
        .open({
          templateUrl: 'views/modal.html',
          controller: 'TournamentsEditCtrl',
          resolve: {
            tournament: function () {
              return tournament;
            }
          }
        })
    };

    vm.deletedItems = [];

    vm.undoDeleting = function (id) {
      var index = vm.deletedItems.indexOf(id);
      if (index > -1) {
        vm.deletedItems.splice(index, 1)
      }
    };

    vm.confirmDelete = function () {
      tournamentService.destroy(vm.deletedItems)
        .success(function () {
          getAll()
        })
        .error(function (msg) {
          console.error(msg)
        });
      vm.deletedItems = [];
    }

  }
})();
