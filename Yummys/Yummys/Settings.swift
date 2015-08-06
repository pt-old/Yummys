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
        get
        {
            return NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        }
    }
//    lazy var cuisines : NSMutableDictionary = {
//        let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
//        return config.objectForKey("Cuisines") as! NSMutableDictionary
//    }()
    
    
    lazy var cuisines:NSMutableDictionary = {
        //get
            //{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let cuisineTypesDict: NSMutableDictionary = userDefaults.objectForKey(Settings.CUISINE_TYPES_SELECTION_KEY)?.mutableCopy() as? NSMutableDictionary {
                let userDefaultsTypes = Set(cuisineTypesDict.allKeys as! [String])
                
                let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
                let configFileDict:NSMutableDictionary =  config.objectForKey("Cuisines") as! NSMutableDictionary
                var  configFilekeys = Set(configFileDict.allKeys as! [String])
                let newCuisineTypes = configFilekeys.subtract(userDefaultsTypes)
                if (newCuisineTypes.count > 0){
                    for cuisineType in newCuisineTypes {
                        cuisineTypesDict.setObject(configFileDict[cuisineType]!, forKey: cuisineType)
                    }
                }
                return cuisineTypesDict;
            } else {
                let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
                return config.objectForKey("Cuisines") as! NSMutableDictionary
            }
        //}
       
    }()
    
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.cuisines, forKey: Settings.CUISINE_TYPES_SELECTION_KEY)
    }
}
