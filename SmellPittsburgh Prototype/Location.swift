//
//  Location.swift
//  AirPrototype
//
//  Created by mtasota on 8/26/15.
//  Copyright (c) 2015 CMU Create Lab. All rights reserved.
//

import Foundation

struct Location {
    
    var latitude = Double()
    var longitude = Double()
    var hacc = Double()
    var vacc = Double()
    
    
    init(latitude:Double,longitude:Double,horizontalAccuracy:Double,verticalAccuracy:Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.hacc = horizontalAccuracy
        self.vacc = verticalAccuracy
    }
    
}
