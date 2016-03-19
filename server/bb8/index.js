// TODO: turn this into a real module.
// TODO: use event processors for RX;
// TODO: wanna see how unit testing + dependency injection works in node.. cuz why not...
var sphero = require("sphero");
var constants = require("./constants.js");
var EventEmitter = require("events").EventEmitter;

var BB8 = (function() {
  function BB8(uuid, name) {
    this._uuid = uuid;
    this._name = name;
    this._sphero = sphero(this._uuid);
    this._isReady = false;

    this._sphero.on("error", function(err, data) {
      console.log("Error!");
    });
  };

  var util = require("util");
  util.inherits(BB8, EventEmitter);

  BB8.prototype.connect = function() {
    var self = this;
    this._sphero.connect(function() {
      console.log("::CONNECTED:: " + self._name);
      console.log("::START CALIBRATION::");
      self._sphero.startCalibration();
      setTimeout(function() {
        console.log("::FINISH CALIBRATION::");
        self._sphero.finishCalibration();
        self._isReady = true;
        // self.emit(constants.BB8EVENTS.CONNECTED);
      }, 5000);
    });
  };

  BB8.prototype.disconnect = function() {
    this._sphero.disconnect(function() {
      self._isReady = false;
      console.log("::DISCONNECTED:: " + this._name);
      // self.emit(constants.BB8EVENTS.CONNECTED);
    });
  };

  BB8.prototype.move = function() {
    if(this._isReady == false) {
      console.log("ERR::MOVING:: not ready");
      // self.emit(constants.BB8EVENTS.ERROR);
      return false;
    }

    console.log("::MOVING:: " + this._name);
    // this._sphero.color = {red: 0, green: 255, blue: 0};
    var direction = Math.floor(0.5* 360);
    this._sphero.roll(150, direction);
    return true;
  };

  BB8.prototype.stop = function() {
    console.log("::STOP:: " + this._name);
    this._sphero.roll(0,0);
  };

  // TODO: local logging call

  return BB8;
})();

module.exports = BB8;
