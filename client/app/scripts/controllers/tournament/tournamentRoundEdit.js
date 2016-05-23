(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TournamentRoundEditCtrl
   * @description
   * # TournamentRoundEditCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TournamentRoundEditCtrl', [
      '$scope',
      'tournamentService',
      'UserService',
      '$uibModalInstance',
      'round',

      TournamentRoundEditCtrl
    ]);

  function TournamentRoundEditCtrl($scope, tournamentService, UserService, $uibModalInstance, round) {
    var vm = this;
    $scope.templateUrl = "views/tournaments/edit_tournament_round.html";
    $scope.title = "Редактирование раунда № " + round.rounds[0].round_number;
    $scope.action = 'Обновить';

    function setUsers(obj) {
      UserService.getUsersByTeam(obj.team_id).success(function (users) {
        obj.users = users;
      })
    }

    for (var i = 0; i < round.rounds.length; i++) {
      setUsers(round.rounds[i]);
    }

    $scope.round = round;

    $scope.ok = function () {
      var arr = [], x = 0;
      for (var i = 0; i < $scope.round.rounds.length; i++) {
        for (var j = 0; j < $scope.round.rounds[i].users.length; j++) {
          arr[x++] = {
            user_id: $scope.round.rounds[i].users[j].id,
            match_id: $scope.round.rounds[i].match_id,
            team_id: $scope.round.rounds[i].team_id,
            match_round_id: $scope.round.rounds[i].id,
            scored_goals: parseInt($('#' + $scope.round.rounds[i].users[j].id).val())
          };
        }
      }
      UserService.setUsersResults(arr).success(function (result) {
        for (var i = 0; i < round.rounds.length; i++) {
          round.rounds[i] = result.rounds[i];
        }
        $uibModalInstance.close(result);
      });
    };

    $scope.cancel = function () {

      $uibModalInstance.dismiss();
    };
  }
})();
