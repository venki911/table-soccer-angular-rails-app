'use strict';

/**
 * @ngdoc overview
 * @name tableSoccerClientAngularApp
 * @description
 * # tableSoccerClientAngularApp
 *
 * Main module of the application.
 */
angular
  .module('tableSoccerClientAngularApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    // 'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ng-token-auth',
    'ui.router',
    'ui.bootstrap',
    'ngFileUpload',
    'ngImgCrop',
    'ui.sortable',
    'angular-loading-bar',
    'angularUtils.directives.dirPagination'
  ])
  .constant('defaultHost', {
    url: '/api'//'http://localhost:3000'
  })
  .config(function ($authProvider, $stateProvider, $urlRouterProvider, $locationProvider, defaultHost) {
    $authProvider.configure({
      apiUrl: defaultHost.url,
      confirmationSuccessUrl: 'https://table-soccer-tournaments.herokuapp.com/#/sign_in',
      authProviderPaths: {
        facebook: '/auth/facebook'
      }

    });

    $stateProvider
      .state('home', {
        url: '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl',
        controllerAs: 'main'
      })
      .state('sign_in', {
        url: '/sign_in',
        templateUrl: 'views/auth/sign_in.html',
        controller: 'SessionCtrl',
        controllerAs: 'session'
      })
      .state('sign_up', {
        url: '/sign_up',
        templateUrl: 'views/auth/sign_up.html',
        controller: 'RegisterCtrl',
        controllerAs: 'register'
      })
      .state('tournaments', {
        url: '/tournaments',
        templateUrl: 'views/tournaments/index.html',
        controller: 'TournamentsCtrl',
        controllerAs: 'tournaments'
      })
      .state('tournaments_show', {
        url: '/tournaments/:id',
        templateUrl: 'views/tournaments/show.html',
        controller: 'TournamentDetailsCtrl',
        controllerAs: 'tournament'
      })
      .state('user_profile', {
        url: '/user/profile',
        templateUrl: 'views/users/profile.html',
        controller: 'ProfileCtrl',
        controllerAs: 'profile'
      })
      .state('setup_tournament', {
        url: '/tournaments/:id/setup',
        templateUrl: 'views/tournaments/setup_tournament.html',
        controller: 'TournamentSetupCtrl',
        controllerAs: 'setup'
      });
    $urlRouterProvider.otherwise('/');
    // $locationProvider.html5Mode(true);
  })
  .run(['$rootScope', '$location', 'defaultHost', '$auth', function ($rootScope, $location, defaultHost, $auth) {
    $rootScope.defaultHost = 'https://table-soccer-tournaments.herokuapp.com';//'http://localhost:3000';

    $rootScope.$on('auth:login-success', function () {
      $location.path('/');
    });

    // $auth.validateUser().then(function() {
    //   console.log($rootScope.user);
    // });

    $rootScope.$on('$stateChangeStart',
      function (event, toState, toParams, fromState, fromParams) {
        $location.url($location.path());

        if (toState.name === 'user_profile' && !$rootScope.user.id){
          $auth.validateUser().then(function () {}, function () {
            $location.path('/sign_in');
          })

        }
      }
    );

    $rootScope.$on('auth:logout-success', function(ev) {
      $location.path('/');
    });
  }]);
