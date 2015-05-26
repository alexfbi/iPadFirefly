//
//  Picture.swift
//  FireflyApp
//
//  Created by ak on 24.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import CoreData

class Picture: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var path: String
    @NSManaged var log: Log

}
