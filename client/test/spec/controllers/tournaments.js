'use strict';

describe('Controller: TournamentsCtrl', function () {

  // load the controller's module
  beforeEach(module('tableSoccerClientAngularApp'));

  var TournamentsCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    TournamentsCtrl = $controller('TournamentsCtrl', {
      $scope: scope
      // place here mocked dependencies
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(TournamentsCtrl.awesomeThings.length).toBe(3);
  });
});
