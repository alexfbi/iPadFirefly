//
//  Log.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

@objc(Log)

class Log: NSManagedObject {
    
    @NSManaged var date: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var eintraege: NSSet
    @NSManaged var gps: NSSet
    @NSManaged var bilder: NSSet
    @NSManaged var strecke: Strecke
    
}