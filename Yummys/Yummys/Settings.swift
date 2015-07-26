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
    
    static let CUISINE_TYPES_SELECTION_KEY = "CUISINE_TYPES_SELECTION"
    
    
    var configFilePath : String {
        return NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
    }
//    lazy var cuisines : NSMutableDictionary = {
//        let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
//        return config.objectForKey("Cuisines") as! NSMutableDictionary
//    }()
    
    var cuisines : NSMutableDictionary 
    {
        get
            {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let cuisineTypesDict: NSMutableDictionary = userDefaults.objectForKey(Settings.CUISINE_TYPES_SELECTION_KEY) as? NSMutableDictionary {
                return cuisineTypesDict
            } else {
                let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
                return config.objectForKey("Cuisines") as! NSMutableDictionary
            }
        }
       
    }
    
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(cuisines, forKey: Settings.CUISINE_TYPES_SELECTION_KEY)
    }
}
