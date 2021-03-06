//
//  BandGyro.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-04-01.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

class BandGyro : BandBaseSensor {
  let TAG = "[Gyro] - "
  weak var sensorManager : MSBSensorManagerProtocol?
  var delegate : BandSensorDelegate?
  
  required init(withSensorManager sensorManager: MSBSensorManagerProtocol?) {
    self.sensorManager = sensorManager
  }
  
  func start() {
    do {
      try self.sensorManager?.startGyroscopeUpdatesToQueue(nil, withHandler: { (gyroData: MSBSensorGyroscopeData!, error: NSError!) in
//        print(NSString(format: (self.TAG + "Accelerator Data: X=%+0.2f, Y=%+0.2f, Z=%0.2f"), gyroData.x, gyroData.y, gyroData.z))
        self.delegate?.didGetSensorData(withSensorData: BandSensorData(x:gyroData.x, y: gyroData.y, z: gyroData.z))
      })
    } catch {
      // TODO: log error
      print(TAG + "start - error")
    }
  }
  
  func stop() {
    do {
      try self.sensorManager?.stopGyroscopeUpdatesErrorRef()
    } catch {
      // TODO: log error
      print(TAG + "stop - error")
    }
  }

}
