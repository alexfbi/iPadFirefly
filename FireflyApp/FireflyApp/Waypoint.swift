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
    
    init(coordinate: CLLocationCoordinate2D, waypointNumber: Int) {
        self.coordinate = coordinate
        self.waypointNumber = waypointNumber
        self.speed = 30
        self.height = 10
        super.init()
    }
    
    // Coordinates of the waypoint
    var coordinate: CLLocationCoordinate2D
    
    // Title for use by selection UI.
    var title: String!

    // Custom attributes for the waypoint
    var waypointNumber:Int
    var speed:Int  // %
    var height:Int //m
}