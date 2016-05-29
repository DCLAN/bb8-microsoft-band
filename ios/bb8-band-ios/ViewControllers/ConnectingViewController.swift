//
//  ViewController.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-01-23.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import UIKit

class ConnectingViewController: UIViewController {
  
  @IBOutlet weak var searchingStackView: UIStackView?
  @IBOutlet weak var searchingText: UILabel?
  @IBOutlet weak var searchingActivityMonitor: UIActivityIndicatorView?
  @IBOutlet weak var searchingRetryButton: UIButton?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchingActivityMonitor?.color = UIColor.orangeColor()
    searchingText?.text = NSLocalizedString("Searching for your BB8 Droid, and Microsoft Band... \r\nDetecting your midichlorian count...\r\nWait a moment.", comment: "Starting scan for droid and band")

    searchingRetryButton?.titleLabel?.text = NSLocalizedString("Retry", comment:"Retry for a button")
  }
  
  override func viewWillAppear(animated: Bool) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDiscoverDroidService), name: DroidNotifications.kDroidDiscoveryCompleted.rawValue, object: nil);
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didStartSearchingForDroidService), name: DroidNotifications.kDroidDiscoveryStarted.rawValue, object: nil);
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didStopSearchingForDroidService), name: DroidNotifications.kDroidDiscoveryTimedOut.rawValue, object: nil);
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didStopSearchingForDroidService), name: DroidNotifications.kDroidDiscoveryStopped.rawValue, object: nil);

  }
  
  override func viewDidDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self, name:DroidNotifications.kDroidDiscoveryCompleted.rawValue, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name:DroidNotifications.kDroidDiscoveryStopped.rawValue, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name:DroidNotifications.kDroidDiscoveryTimedOut.rawValue, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name:DroidNotifications.kDroidDiscoveryStarted.rawValue, object: nil);
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func didStartSearchingForDroidService(notification: NSNotification) {
    searchingStackView?.hidden = false
    searchingActivityMonitor?.startAnimating()
  }
  
  func didDiscoverDroidService(notification: NSNotification) {
    searchingStackView?.hidden = true
    searchingActivityMonitor?.stopAnimating()
    searchingActivityMonitor?.hidden = true
    
    self.performSegueWithIdentifier("DevicesConnectedSegue", sender: self)

  }
  
  func didStopSearchingForDroidService(notification: NSNotification) {
    searchingStackView?.hidden = false
    searchingActivityMonitor?.stopAnimating()
    searchingActivityMonitor?.hidden = true
    searchingRetryButton?.enabled = true
    
    searchingText?.text = NSLocalizedString("Ooops, something went wrong with finding your midichlorian count. Try again!", comment:"Retry service discovery")
    
  }
  
  // MARK: User Actions
  @IBAction func retry(sender: UIButton) {
    AppEngine.sharedInstance.start()
    searchingRetryButton?.enabled = false
  }
}

