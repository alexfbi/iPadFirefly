//
//  Log.swift
//  FireflyApp
//
//  Created by ak on 24.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Log: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var course: Course
    @NSManaged var entries: NSSet
    @NSManaged var gpsFiles: NSSet
    @NSManaged var pictures: NSSet

}
