//
//  Bild.swift
//  AFC1
//
//  Created by ak on 12.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import Foundation
import CoreData

class Bild: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var pfad: String
    @NSManaged var log: Log

}
