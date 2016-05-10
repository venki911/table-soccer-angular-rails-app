(function () {
  'use strict';

  /**
   * @ngdoc service
   * @name tableSoccerClientAngularApp.tournamentService
   * @description
   * # tournamentService
   * Service in the tableSoccerClientAngularApp.
   */
  angular
    .module('tableSoccerClientAngularApp')
    .factory('tournamentService', [
      'defaultHost',
      '$http',
      tournamentService
    ]);

  function tournamentService(defaultHost,$http) {
    var service = {

      all : all,
      show: show,
      create: create,
      update: update,
      destroy: destroy
    };

    return service;
    ///////////////////

    function all() {
      return $http.get(defaultHost.url + '/tournaments.json')
    }

    function show(id) {
      return $http.get(defaultHost.url + '/tournaments/' + id + '.json')
    }

    function create(tournament) {
      return $http.post(defaultHost.url + '/tournaments.json', tournament)
    }

    function update(tournament) {
      return $http.put(defaultHost.url + '/tournaments/' + tournament.tournament.id + '.json', tournament)
    }

    function destroy(ids) {
      return $http.post(defaultHost.url + '/tournaments_destroy.json', {ids: ids})
    }
  }
})();
