//
//  ViewController.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-01-23.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var droidService : DroidService!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // TODO: Move actual discovery to service once done.
    // TODO: Validate Server status - APIs up - Robot(s) currently connected to consider things good to go.
    // TODO: Make sure all that happens on a background thread.
    // TODO: Show that server was discovered on UI.
    
    self.droidService = DroidService()
    self.droidService.start()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

