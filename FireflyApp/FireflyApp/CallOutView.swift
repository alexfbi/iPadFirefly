//
//  CallOutView.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 19.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

class CallOutView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var waypoint:Waypoint?
    var mainView:FirstViewController?
    
    init(waypoint: Waypoint!, mainView:FirstViewController!) {
        self.waypoint = waypoint;
        self.mainView = mainView;
        super.init(frame: CGRect(x: 0, y: 0, width: 4000, height: 4000))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
//        println("Delete pressed!")
//        self.mainView!.waypoints.removeAtIndex(waypoint!.waypointNumber - 1)
//        self.mainView!.mapView.removeAnnotation(waypoint)
//        self.mainView!.waypointCounter--
//        self.mainView!.updateNumeration()
    }
    
    override func hitTest(var point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let viewPoint = superview?.convertPoint(point, toView: self) ?? point
        
        let isInsideView = pointInside(viewPoint, withEvent: event)
        
        var view = super.hitTest(viewPoint, withEvent: event)
        
        return view
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return CGRectContainsPoint(bounds, point)
    }
}
