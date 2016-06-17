//
//  GlobalHandler.swift
//  SmellPittsburgh Prototype
//
//  Created by Mike Tasota on 4/28/16.
//  Copyright © 2016 Mike Tasota. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class GlobalHandler {
    
    // MARK: singleton pattern; this is the only time the class should be initialized
    static var singletonInstantiated: Bool = false
    class var sharedInstance: GlobalHandler {
        struct Singleton {
            static let instance = GlobalHandler()
        }
        return Singleton.instance
    }


    // MARK: Class Functions

    
    var appDelegate: AppDelegate
    var locationHandler: LocationHandler
    var httpRequestHandler: HttpRequestHandler
    var settingsHandler: SettingsHandler
    var firstView: FirstViewController?
    
    
    private init() {
        appDelegate = (UIApplication.sharedApplication().delegate! as! AppDelegate)
        locationHandler = LocationHandler()
        httpRequestHandler = HttpRequestHandler()
        settingsHandler = SettingsHandler()
    }
    
}