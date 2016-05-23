(function () {
  'use strict';

  /**
   * @ngdoc directive
   * @name tableSoccerClientAngularApp.directive:dateTimePicker
   * @description
   * # dateTimePicker
   */
  angular.module('tableSoccerClientAngularApp')
    .directive('dateTimePicker', function ($timeout) {
      return {
        // restrict: 'A',
        link: function postLink(scope, element, attrs) {
          $timeout(function () {
            $.datetimepicker.setLocale('ru');

            $(element).datetimepicker({
              format: 'c', //Y-m-d H:i Y-m-d H:i O   F j, Y  H:i
              // formatDate: 'F j, Y',
              // formatTime: 'H:i',
              timepicker: true,
              validateOnBlur: false,
              step: 10,
              yearStart: 2016,
              // lang: 'ru',
              onShow: function(ct) {
                var date = Date.now();
                this.setOptions({
                  minDate: date,
                  minTime: ct > date ? false : date
                });
              },
              onChangeDateTime: function (ct) {
                var date = Date.now();
                this.setOptions({
                  minTime: ct > date ? false : date
                });

                // console.log(this.getValue());
              }
            });
          }, 0);
        }
      };
    });

})();
