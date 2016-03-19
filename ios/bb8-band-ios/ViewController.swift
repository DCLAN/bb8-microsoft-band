//
//  ViewController.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-01-23.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var discovery : Discovery!
  let serviceName = "dclan-bb8-band"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.discovery = Discovery()
    self.discovery.searchForWebService(serviceName, completion: { (result: Bool, url: NSURL?) in
      if let absoluteString = url?.absoluteString {
        print("Discovered base url: " + absoluteString)
      }
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

