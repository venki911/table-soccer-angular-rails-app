(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:TournamentSetupCtrl
   * @description
   * # TournamentSetupCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('TournamentSetupCtrl', [
      '$scope',
      '$state',
      '$location',
      'SetupTournamentService',

      TournamentSetupCtrl
    ]);

  function TournamentSetupCtrl($scope, $state, $location, SetupTournamentService) {
    var vm = this;

    vm.selectedUsers = [];
    vm.count = 0;
    vm.tour = 0;
    vm.systems = [
      {
        name: 'Лучший из 1',
        count: 1
      },
      {
        name: 'Лучший из 2',
        count: 2
      },
      {
        name: 'Лучший из 3',
        count: 3
      },
      {
        name: 'Лучший из 5',
        count: 5
      }
    ];
    vm.tours = [
      {
        name: '1/8',
        id: 1
      },
      {
        name: '1/4',
        id: 2
      },
      {
        name: '1/2',
        id: 3
      },
      {
        name: 'Финал',
        id: 4
      }
    ];
    vm.teamscount = [];

    $scope.users = [];

    SetupTournamentService
      .getUsers($state.params.id)
      .success(function (users) {
        angular.copy(users, $scope.users);
        $('section').fadeIn('slow')
      });

    vm.selectOrRemoveUser = function (user) {
      if (user.selected) {
        vm.selectedUsers.push(user);
      } else {
        for (var i = 0; i < vm.selectedUsers.length; i++) {
          if (vm.selectedUsers[i].id === user.id) {
            vm.selectedUsers.splice(i, 1);
            break;
          }
        }
      }
    };

    vm.selectSystem = function (system) {
      select(system, vm.systems);
      vm.count = system.count;
    };

    vm.selectStartTour = function (tour) {
      select(tour, vm.tours);
      vm.tour = tour.id;
    };

    function select(obj, arr) {
      for (var i = 0; i < arr.length; i++) {
        arr[i].selected = false
      }
      obj.selected = true;
    }

    vm.teamsCount = function () {
      if (vm.selectedUsers.length % 2 == 0)
        vm.teamscount = new Array(vm.selectedUsers.length / 2);
    };


    vm.generateSetup = function (manually) {
      var selectedUsersIds = [],
          i = 0;

      if (manually) {
        var x = 0;

        for (i = 0; i < vm.teamscount.length; i++){
          $('#team-' + (i+1)).children().each(function(){
            selectedUsersIds[x] = parseInt($(this).attr('id'));
            x++;
          });
        }
      } else {
        for (i = 0; i < vm.selectedUsers.length; i++) {
          selectedUsersIds[i] = vm.selectedUsers[i].id;
        }
      }

      SetupTournamentService
        .createTeams({
          g_method: manually ? 2 : 1,
          ids: selectedUsersIds,
          t_id: $state.params.id
        })
        .success(function () {
          SetupTournamentService
            .createMatches({
              count: vm.count,
              t_id: $state.params.id,
              tour: vm.tour
            })
            .success(function () {
              $location.path('/tournaments/' + $state.params.id)
            })
        })
      };
  }
})();


