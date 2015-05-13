//
//  Wegpunkt.swift
//  AFC1
//
//  Created by ak on 12.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import Foundation
import CoreData

class Wegpunkt: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var height: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var name: String
    @NSManaged var wegpunktaktion: String
    @NSManaged var strecke: Strecke

}
