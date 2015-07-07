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
