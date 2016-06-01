//
//  SettingsHandler.swift
//  SmellPittsburgh Prototype
//
//  Created by Mike Tasota on 6/1/16.
//  Copyright © 2016 Mike Tasota. All rights reserved.
//

import Foundation
import UIKit

class SettingsHandler {
    
    struct SettingsKeys {
        static let userHash = "user_hash"
    }
    
    var userDefaults: NSUserDefaults
    var appDelegate: AppDelegate
    var userHash: String
    
    
    private static func generateUserHash() -> String {
        var result: String = ""
        
        // TODO Digest using random number + timestamp
        result = Constants.USER_HASH
        
        NSLog("Returning genreated user_hash=\(result)")
        return result
    }
    
    
    init() {
        appDelegate = (UIApplication.sharedApplication().delegate! as? AppDelegate)!
        userDefaults = NSUserDefaults.standardUserDefaults()
        if let hash = userDefaults.valueForKey(SettingsKeys.userHash) as? String {
            userHash = hash
        } else {
            userHash = SettingsHandler.generateUserHash()
            userDefaults.setValue(userHash, forKey: SettingsKeys.userHash)
        }
    }
    
}