//
//  AppEngine.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-05-15.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

class AppEngine {
  static let sharedInstance = AppEngine()

  var bandService: BandService!
  var droidService: DroidService!
  
  let TAG = "[APPENGINE] - "
  
  init() {
    self.droidService = DroidService()
    self.bandService = BandService()
    self.bandService.delegate = self.droidService
  }
  
  func start() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
      self.droidService.start()
    })
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      self.bandService.connect()
    })
  }
}