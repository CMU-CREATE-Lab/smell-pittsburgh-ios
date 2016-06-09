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
    var locationService: CLLocationService
    var httpRequestHandler: HttpRequestHandler
    var settingsHandler: SettingsHandler
    var gpsLocation: Location?
    var firstView: FirstViewController?
    
    
    private init() {
        appDelegate = (UIApplication.sharedApplication().delegate! as! AppDelegate)
        locationService = CLLocationService()
//        locationService.startLocationService()
        httpRequestHandler = HttpRequestHandler()
        settingsHandler = SettingsHandler()
    }
    
    
    func updateGps(location: Location?) {
        self.gpsLocation = location
        if gpsLocation != nil && firstView != nil {
            firstView!.updateLocation(gpsLocation!)
        }
    }
    
}