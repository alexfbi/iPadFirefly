//
//  Strecke.swift
//  AFC1
//
//  Created by ak on 12.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import Foundation
import CoreData

class Strecke: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var id: NSNumber
    @NSManaged var logs: NSSet
    @NSManaged var wegpunkte: NSSet

}
