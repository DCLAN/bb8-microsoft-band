var assert = require('chai').assert;
var sinon = require('sinon');
var btDiscovery = require('../app/controllers/bt-discovery.js');
var Buffer = require('buffer').Buffer;

var noble = require('noble');
// HACK: suppressing any notifications that noble would want us to get,
// but are not useful for the tests.
noble._bindings.removeAllListeners();

describe('bt-discovery', function() {
  describe('#initialization()', function() {
    var controller;
    before(function() {
      sinon.stub(noble, "startScanning");
      sinon.stub(noble, "stopScanning");

      controller = new btDiscovery(noble);
      sinon.spy(controller, "startScanning");
      sinon.spy(controller, "stopScanning");
    });
    it('should should handle initialization - powered off', function(done) {
      var callback = function(state) {
        noble.removeListener('stateChange', callback);
        assert(controller.stopScanning.calledOnce, 'Did not receive BT state change on initialization.');
        done();
      };
      noble.on('stateChange', callback);
      noble.emit('stateChange', 'poweredOff');
    });
    it('should should handle initialization - powered on', function(done) {
      var callback = function(state) {
        noble.removeListener('stateChange', callback);
        assert(controller.startScanning.calledOnce, 'Did not receive BT state change on initialization.');
        done();
      };
      noble.on('stateChange', callback);
      noble.emit('stateChange', 'poweredOn');
    });
    after(function() {
      noble.removeAllListeners();
      noble.startScanning.restore();
      noble.stopScanning.restore();
      controller.startScanning.restore();
      controller.stopScanning.restore();
    });
  });
  describe('#scanning()', function() {
    before(function() {
      sinon.stub(noble, "startScanning");
      sinon.stub(noble, "stopScanning");
    });
    beforeEach(function() {
      controller = new btDiscovery(noble);
    });
    it('should emit an event when it starts scanning', function(done) {
      var spy = sinon.spy();
      controller.on('isScanning', spy);
      controller.on('isScanning', function(isScanning) {
        assert.isTrue(isScanning, 'Is not scanning after started scan');
        assert.isTrue(spy.calledOnce, 'Callback was not called once.');
        done();
      });
      controller.startScanning();
    });
    it('should only emit one event when starting to scan', function() {
      var spy = sinon.spy();
      spy.withArgs(true);

      controller.on('isScanning', spy);
      controller.startScanning();
      controller.startScanning();

      assert.isTrue(spy.withArgs(true).calledOnce, 'Callback was not called once.');
    });
    it('should not emit an event when stopping and it already not scanning', function() {
      var spy = sinon.spy();
      controller.on('isScanning', spy);
      controller.stopScanning();

      assert.isFalse(spy.called, "Was already not scanning.");
    });
    it('should emit when it stops scanning', function() {
      var spy = sinon.spy();
      spy.withArgs(false);

      controller.on('isScanning', spy);
      controller.startScanning();
      controller.stopScanning();

      assert.isTrue(spy.withArgs(false).calledOnce, 'Spy should have been called twice.');
    });
    afterEach(function() {
      noble.removeAllListeners();
      controller.removeAllListeners();
    });
    after(function() {
      noble.startScanning.restore();
      noble.stopScanning.restore();
    });
  });
  describe('#discovery()', function() {
    before(function() {
      sinon.stub(noble, "startScanning");
      sinon.stub(noble, "stopScanning");
    });
    beforeEach(function() {
      controller = new btDiscovery(noble);
    });
    it('stops scanning when bb8 device is discovered', function(done) {
      sinon.stub(controller, "isBB8Peripheral").returns(true);
      var spy = sinon.spy(controller, 'stopScanning');
      controller.startScanning();
      noble.on('discover', function(peripheral) {
        assert.isFalse(controller._isScanning, 'Should not be scanning');
        assert.isTrue(spy.calledOnce, 'Scanning was not stopped after discovery');
        done();
      });
      noble.emit('discover', {});
    });
    it('should emit an event when discovering a device', function() {
      sinon.stub(controller, "isBB8Peripheral").returns(true);

      var mockPeripheral = { name: "Peripheral McPeripheral"};
      var spy = sinon.spy();
      spy.withArgs(mockPeripheral);

      controller.on('discovered', spy);
      controller.startScanning();
      noble.emit('discover', mockPeripheral);

      assert.isTrue(spy.withArgs(mockPeripheral).calledOnce, 'Event was emitted with discovered peripheral');
    });
    it('should emit one event when doing multiple scans', function() {
      sinon.stub(controller, "isBB8Peripheral").returns(true);

      var mockPeripheral = { name: "Peripheral McPeripheral"};
      var spy = sinon.spy();
      spy.withArgs(mockPeripheral);

      controller.on('discovered', spy);
      controller.startScanning();
      controller.stopScanning();
      controller.startScanning();
      noble.emit('discover', mockPeripheral);

      assert.isTrue(spy.withArgs(mockPeripheral).calledOnce, 'Event should be emitted once when discovering peripheral. Actual: ' + spy.callCount);
    });
    it('does not stop scanning when bb8 device not discovered', function(done) {
      sinon.stub(controller, "isBB8Peripheral").returns(false);
      var spy = sinon.spy(controller, 'stopScanning');
      controller.startScanning();
      noble.on('discover', function(peripheral) {
        assert.isTrue(controller._isScanning, 'Should still be scanning');
        assert.isFalse(spy.called, 'Scanning was not stopped after discovery');
        done();
      });
      noble.emit('discover', {});
    });
    it('does not replace bb8 if we have already found a bb8 device', function() {
      sinon.stub(controller, "isBB8Peripheral").returns(true);

      var mockPeripheral = { name: "Peripheral McPeripheral"};
      var mockPeripheralTwo = {name: "Second McPeripheral"};
      var spy = sinon.spy();
      spy.withArgs(mockPeripheral);

      controller.on('discovered', spy);
      controller.startScanning();
      noble.emit('discover', mockPeripheral);
      noble.emit('discover', mockPeripheralTwo);

      assert.equal(controller._btBB8, mockPeripheral, 'We should not be replacing our BB8. By default, we stick to the first one discovered.');
      assert.isFalse(spy.withArgs(mockPeripheralTwo).called, 'Event should be emitted once when discovering peripheral. Actual: ' + spy.callCount);
    });
    afterEach(function() {
      controller.isBB8Peripheral.restore();
      noble.removeAllListeners();
      controller.removeAllListeners();
    });
    after(function() {
      noble.startScanning.restore();
      noble.stopScanning.restore();
    });
  });
  describe('#bb8detection()', function() {

    beforeEach(function() {
      controller = new btDiscovery(noble);
    });
    it('needs to not detect undefined peripherals', function() {
      assert.isFalse(controller.isBB8Peripheral(undefined), 'Undefined peripheral is not a BB8 BT device.');
    })
    it('needs to not detect an invalid peripheral', function() {
      assert.isFalse(controller.isBB8Peripheral({}), 'Invalid peripheral is not a BB8 BT device.');
    });
    it('needs to not detect an invalid advertisment', function() {
      var peripheral = {
        advertisement: undefined,
        rssi: -43
      };
      assert.isFalse(controller.isBB8Peripheral(peripheral), 'Invalid advertisment is not a BB8 BT device.');
    });
    it('needs to not detect an invalid manufacturerData', function() {
      var peripheral = {
        advertisement: {
          localName: "BB8 McDroidster",
          manufacturerData: undefined
        },
        rssi: -43
      };
      assert.isFalse(controller.isBB8Peripheral(peripheral), 'Invalid manufacturer data');
    })
    it('needs to fail wrong manufacturer data', function() {
      var peripheral = {
        advertisement: {
          localName: "BB-McDroidster",
          manufacturerData: {
            type:"Buffer",
            data:[11,22]
          }
        },
        rssi: -43
      };
      assert.isFalse(controller.isBB8Peripheral(peripheral), 'Wrong manufacturerData');
    });
    it('needs to fail right manufacturer data, but wrong local name', function() {
      const buf = new Buffer([51, 48]);
      var peripheral = {
        advertisement: {
          localName: "Some Bluetooth device",
          manufacturerData: buf
        },
        rssi: -43
      };
      assert.isFalse(controller.isBB8Peripheral(peripheral), 'Wrong manufacturerData');
    });
    it('needs to succeed with correct manufacturer data and local name prefix', function() {
      const buf = new Buffer([51, 48]);
      var peripheral = {
        advertisement: {
          localName: "BB-McDroidster",
          manufacturerData: buf
        },
      };
      assert.isTrue(controller.isBB8Peripheral(peripheral), 'This is should be detected as a BB8 device.');
    });
    afterEach(function() {
      controller.removeAllListeners();
    });
  });
});
