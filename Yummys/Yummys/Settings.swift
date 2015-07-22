//
//  Settings.swift
//  Yummys
//
//  Created by Piyush Tank on 7/21/15.
//  Copyright (c) 2015 Piyush Tank. All rights reserved.
//

import Foundation

class Settings : NSObject {
    
    static let sharedInstance = Settings()
    
    var configFilePath : String {
        return NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
    }
    lazy var cuisines : NSMutableDictionary = {
        let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
        return config.objectForKey("Cuisines") as! NSMutableDictionary
    }()
    
    
    func save() {
        print (Settings.sharedInstance.cuisines)
        print ("---")
        if (self.cuisines.writeToFile(self.configFilePath, atomically: false)) {
            print ("YES")
        }
        else {
            print ("NO")
        }
    }
}
