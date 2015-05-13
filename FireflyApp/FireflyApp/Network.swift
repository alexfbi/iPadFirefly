//
//  Network.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 13.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

class Network {
    var waypoints:[Waypoint]
    
    init(waypoints: [Waypoint]) {
        self.waypoints = waypoints
    }
    
    func sendWaypoints() {
        println(waypoints.count)
    }
}