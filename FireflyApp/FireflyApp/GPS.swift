//
//  GPS.swift
//  FireflyApp
//
//  Created by Christian Adam on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class GPS: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var valueX: NSNumber
    @NSManaged var valueY: NSNumber
    @NSManaged var valueZ: NSNumber
    @NSManaged var log: Log

}
