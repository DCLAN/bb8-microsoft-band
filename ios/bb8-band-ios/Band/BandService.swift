//
//  bandservice.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-03-31.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

class BandService : NSObject {
  
  let TAG = "[BAND] - "
  var messageProcessedTime = NSDate()
  var isConnected: Bool {
    get {
      return self.client != nil
    }
  }
  
  weak var client: MSBClient?
  var gyroscope: BandGyro?
  
  override init() {
    super.init()

    MSBClientManager.sharedManager().delegate = self
  }
  
  func connect() {
    if isConnected {
      if let bandname = self.client?.name! {
        print(TAG + "Can't connect - connected to band: " + bandname)
      }
      
      return
    }
    
    print(TAG + "Discovering Microsoft Bands...")
    
    if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
      self.client = client
      
      self.gyroscope = BandGyro(withSensorManager: self.client?.sensorManager)
      self.gyroscope?.delegate = self
      
      print(TAG + "Connecting to Microsoft Bands...")
      MSBClientManager.sharedManager().connectClient(self.client)
    } else {
      print(TAG + "no bands detected")
    }
  }
  
  func disconnect() {
    if !isConnected {
      print(TAG + "Can't disconnect, not connected")
      return
    }
    
    self.client = nil
  }
  
  // Mark - Accelerometer Functions
  func startSensing() {
    self.gyroscope?.start()
  }
  
  func stopSensing() {
    self.gyroscope?.stop()
    self.gyroscope = nil
  }
}

// Mark - BandSensorDelegate
extension BandService : BandSensorDelegate {
  func didGetSensorData(withSensorData sensorData: BandSensorData) {
    // Really should move debouning to the sensor.
    // This should be able to detect 3 things:
    // Movement isSingificant.
    // Turn
    // Forward/backwards
    
    // BUT - for now, testing full path, make it toggle w/ significant movement.
    // Bonus with gross debouncing
    if(sensorData.isVerticalMovement()) {
      
      if messageProcessedTime.timeIntervalSinceNow < 5.0 * 1000 {
        messageProcessedTime = NSDate()
        
        // HACK - gross - Proof of concept
        if(sensorData.z < 0) {
          // Move up - This means start!
          print("moving up")
        } else if ( sensorData.z > 0 ) {
          // Move down - This means stop!
          print("moving down")
        }

        
      }
    }
  }
}

// Mark - MSBClientManagerDelegate
extension BandService : MSBClientManagerDelegate {
  func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
    print(TAG + "connected")
    
    startSensing()
  }
  
  func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
    print(TAG + "disconnected")
    stopSensing()
  }
  
  func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error : NSError!) {
    print(TAG + "error: " + error.description)
  }
}
