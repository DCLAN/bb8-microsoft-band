//
//  BandSensor.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-04-01.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

protocol BandBaseSensor {
  weak var sensorManager : MSBSensorManagerProtocol? { get }

  init(withSensorManager sensorManager: MSBSensorManagerProtocol?)
  
  func start()
  func stop()
}

struct BandSensorData {
  let THRESHOLD = 80.0
  var x = 0.0
  var y = 0.0
  var z = 0.0
  
  func isSignificantMovement() -> Bool {
    return fabs(x) >= THRESHOLD || fabs(y) >= THRESHOLD || fabs(z) >= THRESHOLD
  }
  
  func isVerticalMovement() -> Bool {
    return fabs(z) >= THRESHOLD;
  }
}

protocol BandSensorDelegate {
  func didGetSensorData(withSensorData sensorData : BandSensorData)
}