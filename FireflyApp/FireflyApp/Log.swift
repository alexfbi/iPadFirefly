//
//  Log.swift
//  FireflyApp
//
//  Created by Christian Adam on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Log: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var akku: Akku
    @NSManaged var course: Course
    @NSManaged var entries: NSSet
    @NSManaged var gps: NSSet
    @NSManaged var pictures: NSSet

}
