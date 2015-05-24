//
//  GPS.swift
//  FireflyApp
//
//  Created by ak on 24.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class GPS: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var valueX: CLLocationDegrees
    @NSManaged var valueZ: CLLocationDegrees
    @NSManaged var valueY: CLLocationDegrees
    @NSManaged var log: Log

}
