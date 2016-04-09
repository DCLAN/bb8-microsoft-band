//** bb8.js **//
// TODO: discover, keep track of bb8, do operations, etc...
var sphero = require("sphero");
var model = require("../models/bb8.js")

var BB8Controller = function(){
  function BB8Controller(model) {
    this._model = null;
    this._sphero = null;
  };

  BB8Controller.prototype.initialize = function(model) {
    this._model = model;

    console.log("::Initialized:: " + this._model.name() + "/" + this._model.uuid());
  };

  BB8Controller.prototype.isInitialized = function() {
    return this._model != null;
  }

  BB8Controller.prototype.isReady = function() {
    return this._sphero != null && this._sphero.ready;
  }

  BB8Controller.prototype.JSONModel = function() {
    return this._model.toJSON();
  }

  BB8Controller.prototype.connect = function(cb) {
    if(!this.isInitialized()) {
      console.log("::CONNECTING:: Aborted - not initialized.");
      return;
    }

    console.log("::CONNECTING:: " + this._model.name() + "/" + this._model.uuid());
    this._sphero = sphero(this._model.uuid());
    var self = this;
    this._sphero.connect(function() {
      console.log("::CONNECTED:: " + self._model.name());
      console.log("::START CALIBRATION:: " + self._model.name());
      self._sphero.startCalibration();
      setTimeout(function() {
        self._sphero.finishCalibration();
        console.log("::FINISHED CALIBRATION:: " + self._model.name());
        cb(true)
      }, 5000);
    });
  };

  BB8Controller.prototype.disconnect = function() {
    if(!this.isInitialized() || !this._sphero.ready) {
      console.log("::DISCONNECTING:: Aborted - not initialized.");
      return;
    }

    console.log("::DISCONNECTING:: " + this._model.name());
    var self = this;
    this._sphero.disconnect(function() {
      console.log("::DISCONNECTED:: " + self._model.name());
      self._sphero = null;
    });
  };

  BB8Controller.prototype.move = function() {
    if(!this.isReady()) {
        console.log("::MOVING:: Aborted - not ready.");
      return;
    }

    console.log("::MOVING:: " + this._model.name());
    var direction = Math.floor(0.5* 360);
    this._sphero.roll(50, direction);
    return true;
  };

  BB8Controller.prototype.stop = function() {
    if(!this.isReady()) {
      console.log("::STOP:: Aborted - not ready.");
      return;
    }

    console.log("::STOP:: " + this._model.name());
    this._sphero.roll(0,0);
  };

  return BB8Controller;
}();

module.exports = BB8Controller;
