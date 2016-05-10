(function () {
  'use strict';

  /**
   * @ngdoc service
   * @name tableSoccerClientAngularApp.UserService
   * @description
   * # UserService
   * Service in the tableSoccerClientAngularApp.
   */
  angular
    .module('tableSoccerClientAngularApp')
    .factory('UserService', [
      'defaultHost',
      '$http',
      UserService
    ]);

  function UserService(defaultHost, $http) {
    var service = {

      getUsersByTeam : getUsersByTeam,
      setUsersResults: setUsersResults
    };

    return service;
    ///////////////////

    function getUsersByTeam(id) {
      return $http.get(defaultHost.url + '/find_users_by_team.json?team_id=' + id)
    }

    function setUsersResults(arr) {
      return $http.post(defaultHost.url + '/user_results.json', {
        users_results: arr
      })
    }
  }
})();
