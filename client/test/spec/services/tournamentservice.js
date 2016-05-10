'use strict';

describe('Service: tournamentService', function () {

  // load the service's module
  beforeEach(module('tableSoccerClientAngularApp'));

  // instantiate service
  var tournamentService;
  beforeEach(inject(function (_tournamentService_) {
    tournamentService = _tournamentService_;
  }));

  it('should do something', function () {
    expect(!!tournamentService).toBe(true);
  });

});
