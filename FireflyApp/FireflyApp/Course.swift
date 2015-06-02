//
//  Course.swift
//  FireflyApp
//
//  Created by Christian Adam on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Course: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var log: NSSet
    @NSManaged var waypoints: NSSet

}
