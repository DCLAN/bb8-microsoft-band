//
//  DroidService.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-04-05.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation
import AFNetworking

class DroidService : NSObject {
  let TAG = "[DROIDSRV] - "
  let serviceName = "dclan-bb8-band"
  var discovery: Discovery! = Discovery()
  var serviceUrl: String = ""
  
  let ROUTE_SUBSCRIBE = "/subscribe"
  let ROUTE_START = "/start"
  let ROUTE_STOP = "/stop"
  
  let manager = AFHTTPSessionManager()
  
  override init() {
    super.init()
    
    manager.responseSerializer.acceptableContentTypes = Set(["application/json"])

  }
  
  func start() {
    self.discovery.searchForWebService(self.serviceName, completion: { (result: Bool, url: NSURL?) in
      if let absoluteString = url?.absoluteString {
        print(self.TAG + "Discovered base url: " + absoluteString)
        self.serviceUrl = absoluteString + "/bb8"
        self.subscribe()
      }
    })
  }
  
  
  func subscribe() {
    print(self.TAG + "subscribing to robot...");
    
    let subscribeUrl = serviceUrl + ROUTE_SUBSCRIBE
    manager.POST(subscribeUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, sender: AnyObject?) in
      print(self.TAG + "subscribed to robot successfully!")
      },failure: { (task: NSURLSessionDataTask?, error: NSError) in
        print(self.TAG + "failure to subscribe to robot: " + error.description)
      })
  }
  
  func unsubscribe() {
    print(self.TAG + "not implemented - unsubscribe...")
  }
}

extension DroidService: BandMotionDelegate {
  func move() {
    print(self.TAG + "Starting to move robot.")
    
    let subscribeUrl = serviceUrl + ROUTE_START
    manager.POST(subscribeUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, sender: AnyObject?) in
      print(self.TAG + "moving robot successfully!")
      }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
        print(self.TAG + "failure to subscribe to robot: " + error.description)
      })
  }
  
  func stop() {
    print(self.TAG + "Stopping to move robot.")
    
    let subscribeUrl = serviceUrl + ROUTE_STOP
    manager.POST(subscribeUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, sender: AnyObject?) in
      print(self.TAG + "stopped robot successfully!")
      }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
        print(self.TAG + "failure to subscribe to robot: " + error.description)
      })
  }
}