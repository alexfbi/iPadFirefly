//
//  Way_Point.swift
//  FireflyApp
//
//  Created by ak on 24.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Way_Point: NSManagedObject {

    @NSManaged var height: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var wegpunktaktion: String
    @NSManaged var course: Course

}
