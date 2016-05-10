(function () {
  'use strict';

  /**
   * @ngdoc directive
   * @name tableSoccerClientAngularApp.directive:slideTable
   * @description
   * # slideTable
   */
  angular.module('tableSoccerClientAngularApp')
    .directive('slideTable', function () {
      return {
        restrict: 'A',
        //transclude: false,
        link: function (scope, element) {
          // wait for the last item in the ng-repeat then call init
          if (scope.$last) {
            $('span.glyphicon-info-sign').click(function () {
              var $details = $(this).parents().next().find('.match-info');

              if ($details.css('display') === 'block') {
                $details.slideUp();
              } else {
                $('.match-info').slideUp();
                $details.slideDown('slow');
              }
            });
          }
        }
      }
    });

})();
