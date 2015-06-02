//
//  Akku.swift
//  FireflyApp
//
//  Created by Christian Adam on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Akku: NSManagedObject {

    @NSManaged var akku: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var log: Log

}
