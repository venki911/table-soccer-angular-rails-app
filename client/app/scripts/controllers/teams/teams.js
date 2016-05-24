(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TeamsCtrl
   * @description
   * # TeamsCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TeamsCtrl', [
      'TeamService',
      TeamsCtrl
    ]);

  function TeamsCtrl(TeamService) {
    var vm = this;

    TeamService.getAll().success(function (teams) {
      vm.teams = teams;
      $('section').fadeIn('slow')

    });

    vm.changeName = function (team, newName) {

      TeamService.editName(team.id,newName).success(function (response) {
        console.log(response);
        team.name = response.name;
      })
    }
  }
})();
