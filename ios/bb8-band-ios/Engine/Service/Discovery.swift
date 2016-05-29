//
//  discovery.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-03-18.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

class Discovery : NSObject {
  var serviceBrowser: NSNetServiceBrowser!
  var service: NSNetService!
  var serviceName: String!
  var completion: ((result: Bool, url: NSURL?) -> Void)!
  var isSearching: Bool
  
  let TAG = "[DISCOVER] - "
  let timeout: Timeout = Timeout(2.0 * 60.0)
  
  init(serviceName: String) {
    self.isSearching = false
    
    super.init()
    
    self.serviceBrowser = NSNetServiceBrowser()
    self.serviceBrowser.delegate = self
    
    self.serviceName = serviceName
  }
  
  func searchForWebService(completion: ((result: Bool, url: NSURL?) -> Void)?) {
    
    if (isSearching) {
      print(self.TAG + "[\(self.serviceName)] - WARNING - Already searching for Web Service")
    }
    
    isSearching = true
    self.completion = completion
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      print(self.TAG + "[\(self.serviceName)] - Starting to search for Web Service")
      
      self.timeout.start({
        print(self.TAG + "[\(self.serviceName)] - Timed out. Stopping Discovery.")
        self.serviceBrowser.stop()
        
        NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDroidDiscoveryTimedOut.rawValue, object: nil)
      })
 
      self.serviceBrowser.searchForServicesOfType("_http._tcp.", inDomain: "local")
      self.serviceBrowser.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
      
      NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDroidDiscoveryStarted.rawValue, object: nil)
    })
  }
}

// MARK: NSNetServiceDelegate
extension Discovery: NSNetServiceDelegate {
  func netServiceDidResolveAddress(sender: NSNetService) {
    print("netServiceResolved: " + sender.name)
    
    self.timeout.cancel()
    let serviceUrl = NSURL(string: String(format:"https://%@:%d", sender.hostName!, sender.port))
    self.completion?(result: true, url: serviceUrl)
  }
}

// MARK: NSNetServiceBrowserDelegate
extension Discovery: NSNetServiceBrowserDelegate {
  func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                         didFindDomain domainName: String,
                                       moreComing moreDomainsComing: Bool) {
    print("netServiceDidFindDomain")
  }
  
  func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                         didRemoveDomain domainName: String,
                                         moreComing moreDomainsComing: Bool) {
    print("netServiceDidRemoveDomain")
  }
  
  func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                         didFindService netService: NSNetService,
                                        moreComing moreServicesComing: Bool) {
    NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDroidDiscoveryStarted.rawValue, object: nil)

    print("netServiceDidFindService: " + netService.name)
    
    if(netService.name == self.serviceName) {
      self.service = netService
      self.service.delegate = self
      
      self.service.resolveWithTimeout(5.0)
    }
  }
  
  func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser,
                         didRemoveService netService: NSNetService,
                                          moreComing moreServicesComing: Bool) {
    print("netServiceDidRemoveService")
  }
  
  func netServiceBrowserWillSearch(aNetServiceBrowser: NSNetServiceBrowser){
    NSNotificationCenter.defaultCenter().postNotificationName(DroidNotifications.kDroidDiscoveryStarted.rawValue, object: nil)
    isSearching = true
  }
  
  func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
    print("netServiceDidNotSearch")
  }
  
  func netServiceBrowserDidStopSearch(netServiceBrowser: NSNetServiceBrowser) {
    isSearching = false
  }
}
