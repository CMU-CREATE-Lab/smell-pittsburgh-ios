//
//  LocationHandler.swift
//  SmellPittsburgh Prototype
//
//  Created by Mike Tasota on 6/17/16.
//  Copyright © 2016 Mike Tasota. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    var serviceEnabled: Bool = false
    var iterationCounter = 0
    var locationManager = CLLocationManager()
    var closestSampledLocation: Location?
    
    // the maximum number of times to try and update our location
    let maxIterations = 10
    // our desired accuracy
    let desiredAccuracy = 10.0
    // if we are within this level of accuracy, stop updating locations
    let accuracyThreshold = 30.0
    
    
    private func updateLocation(location: Location) {
        // update location if it's better than what we already have
        if let closest = self.closestSampledLocation {
            if location.hacc < closest.hacc {
                self.closestSampledLocation = location
            }
        } else {
            self.closestSampledLocation = location
        }
        if self.closestSampledLocation!.hacc <= accuracyThreshold {
            self.stop()
        }
        iterationCounter += 1
        if iterationCounter >= maxIterations {
            self.stop()
        }
    }
    
    
    func start() {
        if serviceEnabled {
            // clear/reset class variables
            iterationCounter = 0
            closestSampledLocation = nil
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = desiredAccuracy
            // start location service
            locationManager.startUpdatingLocation()
            NSLog("LocationHandler started")
        } else {
            NSLog("ERROR - tried to start LocationHandler but service is disabled.")
        }
    }
    
    
    func stop() {
        // stop location service
        locationManager.stopUpdatingLocation()
        NSLog("LocationHandler stopped")
    }
    
    
    // MARK: Location Manager
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus != .Denied && authStatus != .Restricted && authStatus != .NotDetermined {
                serviceEnabled = true
            }
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let managedLocation = manager.location
        NSLog("READING A NEW LOCATION: lat,long=\(managedLocation!.coordinate.latitude) \(managedLocation!.coordinate.longitude);  horiz_accuracy=\(managedLocation!.horizontalAccuracy), vert_accuracy=\(managedLocation!.verticalAccuracy), altitude=\(managedLocation!.altitude)")
        let location = Location(
            latitude: managedLocation!.coordinate.latitude,
            longitude: managedLocation!.coordinate.longitude,
            horizontalAccuracy: managedLocation!.horizontalAccuracy,
            verticalAccuracy: managedLocation!.verticalAccuracy)
        self.updateLocation(location)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("FAIL at CLLocationSService")
        closestSampledLocation = nil
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus != .Denied && authStatus != .Restricted && authStatus != .NotDetermined {
            serviceEnabled = true
        } else {
            serviceEnabled = false
        }
        if authStatus == .Denied || authStatus == .Restricted {
            NSLog("ERROR - authStatus Restricted/Denied")
            closestSampledLocation = nil
        }
        // status changed, so we should restart location handler
        self.start()
    }
    
}