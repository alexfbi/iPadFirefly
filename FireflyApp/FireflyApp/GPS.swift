//
//  GPS.swift
//  FireflyApp
//
//  Created by ak on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class GPS: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var valueX: Double
    @NSManaged var valueY: Double
    @NSManaged var valueZ: Double
    @NSManaged var date: NSDate
    @NSManaged var log: Log

}
