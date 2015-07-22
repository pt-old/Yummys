//
//  SettingsTableViewCell.swift
//  Yummys
//
//  Created by Piyush Tank on 7/21/15.
//  Copyright (c) 2015 Piyush Tank. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var theSwitch : UISwitch!
    
    var cuisineKey : String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func swtichChanged() {
        if (theSwitch.on) {
            titleLable.textColor = UIColor.greenColor()
        } else {
            titleLable.textColor = UIColor.grayColor()
        }
        Settings.sharedInstance.cuisines.setObject(NSNumber(bool: true), forKey: cuisineKey)
        
    }

}
