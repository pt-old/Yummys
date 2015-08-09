//
//  Filter.swift
//  Yummys
//
//  Created by Piyush Tank on 8/4/15.
//  Copyright (c) 2015 Piyush Tank. All rights reserved.
//

import Foundation

class Filter : NSObject {
    static let sharedInstance = Filter()
    
    func run(cuisineArray: NSArray) -> NSArray {
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
        let settings = Settings.sharedInstance
        for cuisineType in settings.cuisines {
            if cuisineType.value as! Bool == true {
                result.addObject(cuisineType.key)
            }
        }
        return result
    }
}