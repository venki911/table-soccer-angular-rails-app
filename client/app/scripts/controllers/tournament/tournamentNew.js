(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TournamentsNewCtrl
   * @description
   * # TournamentsNewCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TournamentsNewCtrl', [
      '$scope',
      '$filter',
      'tournamentService',
      '$uibModalInstance',

      TournamentsNewCtrl
    ]);

  function TournamentsNewCtrl($scope, $filter, tournamentService, $uibModalInstance) {
    var vm = this;
    $scope.templateUrl = "views/tournaments/tournament_form.html";
    $scope.title = "Создание нового турнира";
    $scope.action = 'Создать';

    $scope.tournament = {
      name: '',
      tourn_type: 'not started',
      place: '',
      datetime: ''
    };

    // $scope.$watch('tournament.datetime', function (newValue) {
    //   if (newValue) {
    //     // $scope.tournament.datetime = $filter('date')(newValue, 'd MMM y H:mm');
    //     var temp = newValue;
    //
    //     console.log(temp);
    //     $scope.tournament.datetime = $filter('date')(new Date(newValue), 'd MMM y H:mm'); //MMM d, y H:m
    //   }
    // });

    $scope.ok = function () {
      $scope.tournament.datetime = new Date($scope.tournament.datetime).toUTCString();
      tournamentService

        .create({tournament: $scope.tournament})
        .success(function (tournament) {
          $uibModalInstance.close(tournament);
        })
        .error(function (msg) {
          console.error(msg)
        });


    };

    $scope.cancel = function () {

      $uibModalInstance.dismiss();
    };
  }
})();
