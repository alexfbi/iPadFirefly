//
//  Eintrag.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
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