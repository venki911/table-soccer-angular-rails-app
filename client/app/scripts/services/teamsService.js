(function () {
  'use strict';

  /**
   * @ngdoc service
   * @name tableSoccerClientAngularApp.TeamService
   * @description
   * # TeamService
   * Service in the tableSoccerClientAngularApp.
   */
  angular
    .module('tableSoccerClientAngularApp')
    .factory('TeamService', [
      'defaultHost',
      '$http',
      TeamService
    ]);

  function TeamService(defaultHost, $http) {
    var service = {

      getAll: getAll,
      editName: editName
    };

    return service;
    ///////////////////

    function getAll() {
      return $http.get(defaultHost.url + '/teams.json')
    }
    function editName(id, name) {
      return $http.put(defaultHost.url + '/teams/' + id + '.json', {name: name})
    }
  }
})();
