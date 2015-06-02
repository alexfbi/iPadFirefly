//
//  Speed.swift
//  FireflyApp
//
//  Created by ak on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Speed: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var value: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var log: Log

}
