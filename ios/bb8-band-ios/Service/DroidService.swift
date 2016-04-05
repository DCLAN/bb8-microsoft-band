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
  
  // HACK: there must be a better way to build urls in osx
  let ROUTE_SUBSCRIBE = "/subscribe"

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
    let subscribeUrl = serviceUrl + ROUTE_SUBSCRIBE
    let manager = AFHTTPSessionManager()
    manager.responseSerializer.acceptableContentTypes = Set(["application/json"])
    
    print(self.TAG + "subscribing to robot...");

    
    manager.POST(subscribeUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, sender: AnyObject?) in
        print(self.TAG + "subscribed to robot successfully!")
      },
      failure: { (task: NSURLSessionDataTask?, error: NSError) in
        print(self.TAG + "failure to subscribe to robot: " + error.description)
    })
  }
  
  func move() {
    
  }
}