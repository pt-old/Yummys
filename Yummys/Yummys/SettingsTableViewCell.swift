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
        Settings.sharedInstance.cuisines.setObject(Bool(theSwitch.on), forKey: cuisineKey)
//        if (theSwitch.on) {
//            //titleLable.textColor = UIColor.greenColor()
//            self.backgroundColor = UIColor.purpleColor()
//            self.titleLable.textColor = UIColor.whiteColor()
//        } else {
//            self.backgroundColor = UIColor.purpleColor()
//        }        
    }
    
    func didSelect() {
        theSwitch.on = !theSwitch.on
        if (theSwitch.on) {
            Settings.sharedInstance.cuisines[cuisineKey] = Bool(true)
        }
        else {
            Settings.sharedInstance.cuisines[cuisineKey] = Bool(false)
        }
        if (theSwitch.on) {
            //titleLable.textColor = UIColor.greenColor()
           // self.backgroundColor = UIColor.purpleColor()
           // self.titleLable.textColor = UIColor.whiteColor()
        } else {
            //titleLable.textColor = UIColor.grayColor()
        }
    }

}
