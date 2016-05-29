//
//  Droid.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-05-29.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import Foundation

enum Type {
  case BB8
  case Unknown
}

class Droid {
  var name: String!
  var uuid: String!
  var type: Type!
}