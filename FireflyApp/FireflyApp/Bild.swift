//
//  Bild.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Bild: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var pfad: String
    @NSManaged var log: Log
    
}
