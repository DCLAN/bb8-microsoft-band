// TODO: turn this into a real module.
// TODO: use event processors for RX;
// TODO: wanna see how unit testing + dependency injection works in node.. cuz why not...
var sphero = require("sphero");

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

  BB8.prototype.connect = function() {
    var self = this;
    this._sphero.connect(function() {
      console.log("::CONNECTED:: " + self._name);
      self._sphero.color = {red:0, green:0, blue:255};
      // console.log("::START CALIBRATION::");
      //   self._sphero.startCalibration();
      //   setTimeout(function() {
      //       console.log("::FINISH CALIBRATION::");
      //         self._sphero.finishCalibration();
      //         self._isReady = true;
      //   }, 5000);
    });
  };

  BB8.prototype.disconnect = function() {
    this._sphero.disconnect(function() {
      console.log("Disconnected " + this._name);
    });
  };

  BB8.prototype.move = function() {
    console.log("Move " + this._name);
    var direction = Math.floor(Math.random() * 360);
    this._sphero.roll(150, direction);
  };

  BB8.prototype.stop = function() {
    console.log("Stop " + this._name);
    this._sphero.roll(0,0);
  };

  // TODO: local logging call

  return BB8;
})();

module.exports = BB8;
