var bonjour = require("bonjour")();
var constants = require("../bb8/constants.js");

var Discovery = (function() {
  function Discovery(port) {
    this.__port = port;

  };

  Discovery.prototype.publish = function() {
    console.log("Published " + constants.BB8_BAND_SERVICE_NAME + " on port: " + this.__port);
    var service = bonjour.publish({ name: constants.BB8_BAND_SERVICE_NAME, type: 'http', port: this.__port });
    console.log("Service (fqdn): " + service.fqdn + " host: " + service.host);
  };

  Discovery.prototype.find = function() {
    bonjour.find({ name: constants.BB8_BAND_SERVICE_NAME }, function (service) {
      console.log('Found an HTTP server:', service)
    });
  };

  return Discovery;

})();

module.exports = Discovery;
