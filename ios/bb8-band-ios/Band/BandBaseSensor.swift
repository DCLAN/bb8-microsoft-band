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