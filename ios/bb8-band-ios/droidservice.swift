//
//  droidservice.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-03-19.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation
import AFNetworking

class DroidService : NSObject {
  
  let serviceName = "dclan-bb8-band"
  let ROUTE = "/bb8"
  let STATUS = "/status"
  
  var isStarted : Bool
  var baseURL : NSURL!
  var discovery : Discovery!
  
  override init() {
    self.isStarted = false
    super.init()
  }
  
  func start() {
    if isStarted {
      return
    }
    
    self.discovery = Discovery()
    self.discovery.searchForWebService(serviceName, completion: { (result: Bool, url: NSURL?) in
      if let absoluteString = url?.absoluteString {
        print("Discovered base url: " + absoluteString)
        self.baseURL = url
        self.checkServerStatus()
        
      }
    })
    
    isStarted = !isStarted
  }
  
  func stop() {
    // TODO: err, whatever that entails... Stop discover if in progress, etc...
    if !isStarted {
      return
    }
    
    isStarted = !isStarted
  }
  
  private func checkServerStatus() {
    // When we get a url, we validate the call...
    let url = baseURL.absoluteString + ROUTE + STATUS
    AFHTTPSessionManager().GET(url, parameters: nil, progress: nil,
      success: { (task: NSURLSessionDataTask, sender: AnyObject?) in
        print("Success")
      }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
        print("Failure")
      }
    )
  }
  
}