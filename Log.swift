//
//  Log.swift
//  AFC1
//
//  Created by ak on 12.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import Foundation
import CoreData

class Log: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var eintraege: NSSet
    @NSManaged var gps: NSSet
    @NSManaged var bilder: NSSet
    @NSManaged var strecke: Strecke

}
