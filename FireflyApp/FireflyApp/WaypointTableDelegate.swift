//
//  WaypointTableDelegate.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 13.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

protocol WaypointTableDelegate: class {
    /**
    Tells the delegate that a waypoint was deleted.
    
    :param: waypointNumber  Number of deleted waypoint.
    */
    func deleteWaypoint(waypointNumber: Int)
    
    /**
    Tells the delegate that a waypoint was selected.
    
    :param: wayointNumber   Number of selected waypoint.
    */
    func waypointWasSelected(waypointNumber: Int)
    
    /**
    Tells the delegate that the waypoints were reordered.
    
    :param: waypointNumber  Number of reordered waypoint.
    :param: toPosition  New position of reordered waypoint.
    */
    func waypointsWereReordered(waypointNumber: Int, toPosition: Int)
}