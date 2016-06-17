//
//  SettingsHandler.swift
//  SmellPittsburgh Prototype
//
//  Created by Mike Tasota on 6/1/16.
//  Copyright © 2016 Mike Tasota. All rights reserved.
//

import Foundation
import UIKit
import SwiftSSL

class SettingsHandler {
    
    struct SettingsKeys {
        static let userHash = "user_hash"
    }
    
    var userDefaults: NSUserDefaults
    var appDelegate: AppDelegate
    var userHash: String
    // TODO testing only; delete me later
    var myPoints = [String]()
    
    
    private static func generateUserHash() -> String {
        // INPUT: Random Number + Epoch Time
        let input = String.init(format: "%d %d", arc4random(), Int(NSDate().timeIntervalSince1970))
        // Digest input string with MD5
        let result = "ios_" + input.digest(SwiftSSL.DigestAlgorithm.MD5)
        NSLog("Returning genreated user_hash=\(result)")
        return result
    }
    
    
    // TODO testing only; delete me later
    func addPoint(point: String) {
        myPoints.append(point)
        userDefaults.setValue(myPoints, forKey: "my_points")
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
        // TODO testing only; delete me later
        let lastPoints = userDefaults.valueForKey("my_points") as? [String]
        NSLog("lastPoints were \(lastPoints); now clearing")
        userDefaults.setValue(myPoints, forKey: "my_points")
    }
    
}