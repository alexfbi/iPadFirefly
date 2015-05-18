//
//  Strecke.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Strecke: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var id: NSNumber
    @NSManaged var logs: NSSet
    @NSManaged var wegpunkte: NSSet
    
}
