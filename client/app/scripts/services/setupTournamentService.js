(function () {
  'use strict';

  /**
   * @ngdoc service
   * @name tableSoccerClientAngularApp.SetupTournamentService
   * @description
   * # SetupTournamentService
   * Service in the tableSoccerClientAngularApp.
   */
  angular
    .module('tableSoccerClientAngularApp')
    .factory('SetupTournamentService', [
      'defaultHost',
      '$http',
      SetupTournamentService
    ]);

  function SetupTournamentService(defaultHost, $http) {
    var service = {

      getUsers : getUsers,
      createTeams: createTeams,
      createMatches: createMatches
    };

    return service;
    ///////////////////

    function getUsers(tournament_id) {
      return $http.get(defaultHost.url + '/teams/new.json?t_id='+ tournament_id)
    }
    function createTeams(teams) {
      return $http.post(defaultHost.url + '/teams.json', {
        team: {
          generate_method: teams.g_method,
          ids: teams.ids,
          tournament_id: teams.t_id
        }
      })
    }
    function createMatches(obj) {
      return $http.post(defaultHost.url + '/matches.json', {
        count: obj.count,
        match: {
          tournament_id: obj.t_id,
          tour: obj.tour
        }
      })
    }
  }
})();
