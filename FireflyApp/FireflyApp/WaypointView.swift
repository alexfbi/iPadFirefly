//
//  WaypointView.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 20.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import MapKit

class WaypointView: MKPinAnnotationView {
    
    @IBOutlet var calloutView: CallOutView!
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        NSBundle.mainBundle().loadNibNamed("CallOutView", owner: self, options: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            
            calloutView.frame.origin.x = -100
            calloutView.frame.origin.y = -150
            
            self.addSubview(calloutView)
        }
        
        else {
            self.subviews[0].removeFromSuperview()
        }
    }
    
//    - (NSView *)hitTest:(NSPoint)point
//    {
//    NSView *hitView = [super hitTest:point];
//    if (hitView == nil && self.selected) {
//    NSPoint pointInAnnotationView = [self.superview convertPoint:point toView:self];
//    NSView *calloutView = self.calloutViewController.view;
//    hitView = [calloutView hitTest:pointInAnnotationView];
//    }
//    return hitView;
//    }
    
    
}