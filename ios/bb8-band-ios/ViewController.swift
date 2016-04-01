//
//  ViewController.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-01-23.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let serviceName = "dclan-bb8-band"
  var discovery: Discovery!
  var bandService: BandService!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: not a view controller thing, should be in 
    // Do any additional setup after loading the view, typically from a nib.
    self.discovery = Discovery()
    self.discovery.searchForWebService(serviceName, completion: { (result: Bool, url: NSURL?) in
      if let absoluteString = url?.absoluteString {
        print("Discovered base url: " + absoluteString)
      }
    })
    
    self.bandService = BandService()
    self.bandService.connect()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

