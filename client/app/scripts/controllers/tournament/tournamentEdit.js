(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TournamentsEditCtrl
   * @description
   * # TournamentsEditCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TournamentsEditCtrl', [
      '$scope',
      '$filter',
      'tournamentService',
      '$uibModalInstance',
      'tournament',

      TournamentsEditCtrl
    ]);

  function TournamentsEditCtrl($scope, $filter, tournamentService, $uibModalInstance, tournament) {
    var vm = this;
    $scope.templateUrl = "views/tournaments/tournament_form.html";
    $scope.title = "Edit tournament";
    $scope.action = 'Update';

    $scope.tournament ={
      id: tournament.id,
      name: tournament.name,
      tourn_type: tournament.tourn_type,
      place: tournament.place,
      datetime: tournament.datetime
    };

    $scope.$watch('tournament.datetime', function (newValue) {
      if (newValue) {
        $scope.tournament.datetime = $filter('date')(newValue, 'MMM d, y H:mm');
      }
    });

    $scope.ok = function () {
      var formattedDate = $scope.tournament.datetime;
      $scope.tournament.datetime = new Date($scope.tournament.datetime).toUTCString();
      tournamentService
        .update({tournament: $scope.tournament})
        .success(function () {
          $scope.tournament.datetime = formattedDate;
          angular.copy($scope.tournament, tournament);
          $uibModalInstance.close();
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
