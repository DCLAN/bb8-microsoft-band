//
//  Notifications.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-05-14.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

enum DroidNotifications : String {
  case kDroidDiscoveryStarted = "droid-discovery-started"
  case kDroidDiscoveryCompleted = "droid-discovery-completed"
  case kDroidDiscoveryStopped = "droid-discovery-stopped"
  case kDroidDiscoveryTimedOut = "droid-discovery-timedout"
}