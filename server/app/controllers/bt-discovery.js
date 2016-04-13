//** bt-discovery.js **//
// searches and looks for BT devices.
var util = require("util"),
    EventEmitter = require("events").EventEmitter;

const BB8_MANUFACTURER_DATA = "3330";
const BB8_BT_NAME_PREFIX = "BB-";
const TAG = "[BT-DISC] - ";

var BTDiscovery = function() {
  function BTDiscovery(noble) {
    this._noble = noble;
    this._isScanning = false;

    var self = this;
    this._noble.on('stateChange', function(state) {
      console.log(TAG + "BT changed state: " + state)
      if (state === 'poweredOn') {
        self.startScanning();
      } else {
        self.stopScanning();
      }
    });
    this._noble.on('discover', function(peripheral) {
      if (self.isBB8Peripheral(peripheral)) {
        console.log(TAG + "Discovered BB8 peripheral! " + peripheral);

        if (self._btBB8 == undefined) {
          self.stopScanning();
          self._btBB8 = peripheral;
          self.emit('discovered', self._btBB8);
        }
      }
    });
  };

  util.inherits(BTDiscovery, EventEmitter);

  BTDiscovery.prototype.startScanning = function() {
    if(this._isScanning) {
      return;
    }

    console.log(TAG + "Scanning for BT Devices...");
    this._isScanning = true;
    this._noble.startScanning();
    this.emit('isScanning', this._isScanning);
  };

  BTDiscovery.prototype.stopScanning = function() {
    if(!this._isScanning) {
      return;
    }

    console.log(TAG + "Stopping to scan for BT Devices...");
    this._isScanning = false;
    this._noble.stopScanning();
    this.emit('isScanning', this._isScanning);
  };

  BTDiscovery.prototype.isBB8Peripheral = function(peripheral) {
    var isRightManufacturer = false;
    var isRightLocalName = false;

    if(peripheral && peripheral.advertisement) {
      if (peripheral.advertisement.manufacturerData) {
        var hexManufacturerString = peripheral.advertisement.manufacturerData.toString('hex');
        isRightManufacturer = hexManufacturerString == BB8_MANUFACTURER_DATA
      }

      if (peripheral.advertisement.localName) {
        isRightLocalName = peripheral.advertisement.localName.lastIndexOf(BB8_BT_NAME_PREFIX,0) === 0;
      }
    }

    return isRightManufacturer && isRightLocalName;
  };

  return BTDiscovery;
}();

module.exports = BTDiscovery;
