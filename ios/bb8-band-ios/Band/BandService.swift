//
//  bandservice.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-03-31.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

class BandService : NSObject, MSBClientManagerDelegate {
  
  let TAG = "[BAND] - "
  var isConnected: Bool {
    get {
      return self.client != nil
    }
  }
  
  weak var client: MSBClient?
  var accelerometer: BandAccelerometer?
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
    
    if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
      self.client = client
      self.accelerometer = BandAccelerometer(withSensorManager: self.client?.sensorManager)
      self.gyroscope = BandGyro(withSensorManager: self.client?.sensorManager)
      
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
    self.accelerometer?.start()
    self.gyroscope?.start()
  }
  
  func stopSensing() {
    self.accelerometer?.stop()
    self.accelerometer = nil
    
    self.gyroscope?.stop()
    self.gyroscope = nil
  }
  
  // Mark - Client Manager Delegates
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
