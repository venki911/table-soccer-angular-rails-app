(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TournamentDetailsCtrl
   * @description
   * # TournamentDetailsCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TournamentDetailsCtrl', [
      '$scope',
      '$state',
      '$uibModal',
      'tournamentService',
      TournamentDetailsCtrl
    ]);

  function TournamentDetailsCtrl($scope, $state, $uibModal, tournamentService) {
    var vm = this;

    $scope.sortType     = 'datetime';
    $scope.sortReverse  = false;
    $scope.searchMatch   = '';


    vm.editTournamentModalWindow = function (tournament) {
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

    vm.editRoundModalWindow = function (round, tourn_id) {
      $uibModal
        .open({
          templateUrl: 'views/modal.html',
          controller: 'TournamentRoundEditCtrl',
          size: 'lg',
          resolve: {
            round: function () {
              return {
                rounds: round,
                tournament_id: tourn_id
              };
            }
          }
        }).result.then(function (result) {
        for (var i = 0; i < vm.matches.length; i++) {
          if (vm.matches[i].match.id === result.match.id) {
            vm.matches[i].match = result.match;
          }
        }
        var step = 0;
        switch (result.first_tour) {
          case '1/8': step = 17; break;
          case '1/4': step = 9; break;
          case '1/2': step = 5; break;
          case  'final': step = 2; break;
        }
        if (vm.matches[vm.matches.length - step].match.status === 'finished') {
          getAll();
        }
      })
    };

    vm.findWinnerTeam = function (winner_id) {
      var index = vm.teams.map(function(x) {return x.id; }).indexOf(winner_id);
      return index > -1 ? vm.teams[index].name : ''
    };

    function getAll() {
      tournamentService.show($state.params.id)
        .success(
          function (tournament) {
            vm.tournament = tournament.tournament;
            vm.teams = tournament.teams;
            vm.matches = tournament.matches;
            vm.results = tournament.results_table;
            // vm.playoff = tournament.playoff_bracket;

            var playoffBrakcet = tournament.playoff_bracket,
              results = [],
              teams = [];

            teams = playoffBrakcet[0].teams;
            results = playoffBrakcet[0].goals;

            var minimalData = {
              teams : teams,
              results : results
            };

            $('#playoff-bracket').bracket({
              init: minimalData
            });
          })
        .error(function (message) {
          vm.errors = message;
          console.error(vm.errors)
        })
    }
    getAll();

    }
})();
