//
//  ForceCommandTableViewCell.swift
//  bb8-band-ios
//
//  Created by Daniel Lanthier on 2016-05-29.
//  Copyright © 2016 Daniel Lanthier. All rights reserved.
//

import UIKit

class ForceCommandTableViewCell: UITableViewCell {
  
  @IBOutlet weak var commandLabel: UILabel?

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
    
}
