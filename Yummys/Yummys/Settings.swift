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
    
    enum eDistances: String {
        case upto5Miles = "upto5Miles"
        case upto10Miles = "upto10Miles"
        case upto15Miles = "upto15Miles"
    }
    
    enum eRatings: String {
        case ratingOne = "ratingOne"
        case ratingTwo = "ratingTwo"
        case ratingThree = "ratingThree"
        case ratingFour = "ratingFour"
        case ratingFive = "ratingFive"
    }
    
    static let CUISINE_TYPES_SELECTION_KEY = "CUISINE_TYPES_SELECTION"
    
    var rating:eRatings = .ratingFour
    var distance:eDistances = .upto5Miles
    
    
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
            let config:NSMutableDictionary =  NSMutableDictionary(contentsOfFile: self.configFilePath as String)!
            config.objectForKey("Cuisines") as! NSMutableDictionary
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
                let staleCuisineType = userDefaultsTypes.subtract(configFilekeys)
                if (staleCuisineType.count>0){
                    for cuisineType in staleCuisineType {
                        cuisineTypesDict.removeObjectForKey(cuisineType)
                    }
                }
                return cuisineTypesDict;
            } else {
                return config.objectForKey("Cuisines") as! NSMutableDictionary
            }
        //}
       
    }()
    
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.cuisines, forKey: Settings.CUISINE_TYPES_SELECTION_KEY)
    }
    
    func doFilter(cuisineArray: NSArray) -> NSArray {
        let result = NSMutableArray()
        let configCat = self.categories()
        for cuisine in cuisineArray {
            let index = cuisineArray.indexOfObject(cuisine)
            var categories:NSArray? = cuisine["categories"] as? NSArray
            if (categories != nil) {
                let cuisineTypes:NSArray = cuisine["categories"] as! NSArray
                for cui in cuisineTypes {
                    let cc = cui as! NSArray
                    for c in cc {
                        if configCat.indexOfObject(c) != NSNotFound {
                            result.addObject(cuisine)
                            break
                        }
                    }
                }
            }
        }
        return result
    }
    
    func categories() -> NSArray {
        let result = NSMutableArray()
        //let settings = Settings.sharedInstance
        for cuisineType in cuisines {
            if cuisineType.value as! Bool == true {
                result.addObject(cuisineType.key)
            }
        }
        return result
    }
}
