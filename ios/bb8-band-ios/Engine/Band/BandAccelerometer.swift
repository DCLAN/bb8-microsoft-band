//
//  accelerometer.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-03-31.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

// TODO: Class or struct? Protocol?
// Collects accelerometer data
// Feeds it to a delegate provided by the service.
class BandAccelerometer : BandBaseSensor {
  let TAG = "[Accel] - "
  weak var sensorManager : MSBSensorManagerProtocol?
  
  required init(withSensorManager sensorManager: MSBSensorManagerProtocol?) {
    self.sensorManager = sensorManager
  }
  
  func start() {
    do {
      try self.sensorManager?.startAccelerometerUpdatesToQueue(nil, withHandler: { (accelerometerData: MSBSensorAccelerometerData!, error: NSError!) in
        print(NSString(format: (self.TAG + "Accelerator Data: X=%+0.2f, Y=%+0.2f, Z=%0.2f"), accelerometerData.x, accelerometerData.y, accelerometerData.z))
        // TODO: need to format + send that data to a data broker!
      })
    } catch {
      // TODO: log error
      print(TAG + "start - error")
    }
  }
  
  func stop() {
    do {
      try self.sensorManager?.stopAccelerometerUpdatesErrorRef()
    } catch {
      // TODO: log error
      print(TAG + "stop - error")
    }
  }
  
  func accelerometerDataHandler(accelerometerData: MSBSensorAccelerometerData!, error: NSError!) {
    print("received accelerometer data")
  }
  
  
}