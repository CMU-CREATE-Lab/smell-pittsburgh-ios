//
//  CLLocationService.swift
//  AirPrototype
//
//  Created by mtasota on 9/16/15.
//  Copyright (c) 2015 CMU Create Lab. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class CLLocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    // This is set to false if location services are not enabled on the device or if this app is denied service
    var serviceEnabled: Bool = false
    
    
    private func updateCurrentLocation(location: Location?, name: String) {
//        GlobalHandler.sharedInstance.readingsHandler.gpsReadingHandler.gpsAddress.name = name
//        GlobalHandler.sharedInstance.readingsHandler.refreshHash()
//        GlobalHandler.sharedInstance.gpsLocation = location
        GlobalHandler.sharedInstance.updateGps(location)
    }
    
    
    func startLocationService() {
        if (serviceEnabled) {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 1000
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func stopLocationService() {
        locationManager.stopUpdatingLocation()
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
        let location = manager.location
//        GlobalHandler.sharedInstance.readingsHandler.gpsReadingHandler.setGpsAddressLocation(Location(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
        
        geocoder.reverseGeocodeLocation(location!, completionHandler: { (results: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil && results!.count > 0 {
                let placemark = results![results!.endIndex-1]
                self.updateCurrentLocation(Location(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude), name: placemark.locality!)
            }
        })
        // TODO should we stop updating location once we find one?
        //        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("FAIL at CLLocationSService")
        updateCurrentLocation(nil, name: "Unknown Location")
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus != .Denied && authStatus != .Restricted && authStatus != .NotDetermined {
            serviceEnabled = true
            startLocationService()
        } else {
            serviceEnabled = false
        }
        if authStatus == .Denied || authStatus == .Restricted {
//            GlobalHandler.sharedInstance.settingsHandler.setAppUsesCurrentLocation(false)
//            GlobalHandler.sharedInstance.gpsLocation = nil
            GlobalHandler.sharedInstance.updateGps(nil)
        }
    }
    
}