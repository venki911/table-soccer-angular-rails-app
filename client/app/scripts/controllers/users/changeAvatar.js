(function () {
  'use strict';

  /**
   * @ngdoc function
   * @name tableSoccerClientAngularApp.controller:ChangeAvatarCtrl
   * @description
   * # ChangeAvatarCtrl
   * Controller of the tableSoccerClientAngularApp
   */
  angular
    .module('tableSoccerClientAngularApp')
    .controller('ChangeAvatarCtrl', [
      '$rootScope',
      '$scope',
      '$uibModalInstance',
      'Upload',
      '$timeout',

      ChangeAvatarCtrl
    ]);

  function ChangeAvatarCtrl($rootScope, $scope, $uibModalInstance, Upload, $timeout) {
    var vm = this;
    $scope.templateUrl = "views/users/avatar_modal.html";
    $scope.title = "Change avatar";
    $scope.action = 'Update';


    $scope.submit = function (dataUrl, name) {
      var text = "";
      var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

      for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

      vm.dataUrl = dataUrl;
      vm.name = text + name;
    };

    $scope.ok = function () {
      $timeout(function() {
        angular.element('#submit').triggerHandler('click');

        Upload.upload({
          url: $rootScope.defaultHost + '/update_avatar.json',
          method: 'POST',
          data: {
            id: $rootScope.user.id,
            file: Upload.dataUrltoBlob(vm.dataUrl, vm.name)
          }
        }).then(function (result) {
          $rootScope.user.avatar.url = result.data.avatar.url;
          $uibModalInstance.close();
        })
      }, 1);
    };

    $scope.cancel = function () {

      $uibModalInstance.dismiss();
    };
  }
})();
