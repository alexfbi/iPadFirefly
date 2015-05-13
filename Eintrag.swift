//
//  Eintrag.swift
//  AFC1
//
//  Created by ak on 12.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import Foundation
import CoreData

class Eintrag: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var valueZ: NSNumber
    @NSManaged var valueX: NSNumber
    @NSManaged var valueY: NSNumber
    @NSManaged var name: String
    @NSManaged var log: Log

}
