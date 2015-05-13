//
//  Waypoint.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 13.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import MapKit

class Waypoint: NSObject, MKAnnotation {
    
    @objc var coordinate: CLLocationCoordinate2D { return _coordinate }
    private var _coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, waypointNumber: Int) {
        self._coordinate = coordinate
        self.waypointNumber = waypointNumber
        super.init()
    }
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self._coordinate = newCoordinate
    }
    
    // Title and subtitle for use by selection UI.
    var title: String!
    var subtitle: String!
    
    var waypointNumber:Int
}