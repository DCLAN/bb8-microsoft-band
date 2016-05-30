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
  let BB8_SERVICE_NAME = "dclan-bb8-band"
  var discovery: Discovery!
  var serviceUrl: String = ""
  
  var droid: Droid!
  
  let ROUTE_BASE = "/droid"
  let ROUTE_DISCOVER = "/discover"
  let ROUTE_SUBSCRIBE = "/subscribe"
  let ROUTE_START = "/move"
  let ROUTE_STOP = "/stop"
  
  let manager = AFHTTPSessionManager()
  
  private enum DroidProperties : String {
    case kDroidName = "name"
    case kDroidUUID = "uuid"
  }
  
  override init() {
    super.init()
    
    self.discovery = Discovery(serviceName:BB8_SERVICE_NAME)
    
    manager.responseSerializer.acceptableContentTypes = Set(["application/json"])
    let policy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.Certificate)
    policy.validatesDomainName = false
    policy.allowInvalidCertificates = true
    
    let certificatePath = NSBundle.mainBundle().pathForResource("cert", ofType: "cer")!
    let certificateData = NSData(contentsOfFile: certificatePath)!
    policy.pinnedCertificates = [certificateData]
    
    manager.securityPolicy = policy

  }
  
  func start() {
    self.discovery.searchForWebService({ (result: Bool, url: NSURL?) in
      if let absoluteString = url?.absoluteString {
        print(self.TAG + "Discovered base url: " + absoluteString)
        self.serviceUrl = absoluteString + self.ROUTE_BASE
        self.discover()
      }
    })
  }
  
  func discover() {
    print(self.TAG + "discovering droids...")
    let discoverURL = serviceUrl + ROUTE_DISCOVER
    manager.GET(discoverURL, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
      print(self.TAG + "discovered to robot successfully: ")
      
      let responseDict = responseObject as! Dictionary<String, AnyObject>
      
      let model = Droid();
      model.name = responseDict[DroidProperties.kDroidName.rawValue] as! String;
      model.uuid = responseDict[DroidProperties.kDroidUUID.rawValue] as! String;

      NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDidDiscoverDroid.rawValue, object: model);
      NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDroidDiscoveryCompleted.rawValue, object: responseObject)


      self.subscribe()
      },failure: { (task: NSURLSessionDataTask?, error: NSError) in
        print(self.TAG + "discovery failed (this isn't the droid you are looking for):" + error.description)
    })
  }
  
  func subscribe() {
    print(self.TAG + "subscribing to robot...")
    
    let subscribeUrl = serviceUrl + ROUTE_SUBSCRIBE
    manager.POST(subscribeUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
      print(self.TAG + "subscribed to robot successfully!")
      
      // HACK: Subscribe isn't working - why! :(
//      NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDroidDiscoveryCompleted.rawValue, object: responseObject)
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