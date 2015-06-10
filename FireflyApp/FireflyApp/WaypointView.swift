//
//  WaypointView.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 20.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import MapKit

class WaypointView: MKPinAnnotationView, UITextFieldDelegate {
    
    @IBOutlet var calloutView:CallOutView?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var speedText: UITextField!
    
    var hitOutside:Bool = true
    var waypoint:Waypoint?
    var mainView:FirstViewController?
    
//    init!(annotation: MKAnnotation!, reuseIdentifier: String!, mainView:FirstViewController!) {
//        self.mainView = mainView
//        self.waypoint = annotation as? Waypoint
//        calloutView = CallOutView(waypoint: waypoint, mainView: mainView)
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        NSBundle.mainBundle().loadNibNamed("CallOutView", owner: self, options: nil)
//    }
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        NSBundle.mainBundle().loadNibNamed("CallOutView", owner: self, options: nil)
        
        self.heightText.delegate = self
        self.speedText.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var preventDeselection:Bool {
        return !hitOutside
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
                
        let calloutViewAdded = calloutView?.superview != nil
        
        if (selected || !selected && hitOutside) {
            super.setSelected(selected, animated: animated)
        }
        
        self.superview?.bringSubviewToFront(self)
        
        if (calloutView == nil) {
            calloutView = CallOutView()
        }
        
        if (self.selected && !calloutViewAdded) {
            calloutView!.frame.origin.x = -100
            calloutView!.frame.origin.y = -200
            self.label.text = "Waypoint \(waypoint!.waypointNumber)"
            self.heightText.text = "\(waypoint!.height/1000)"
            self.speedText.text = "\(waypoint!.speed)"
            addSubview(calloutView!)
        }
        
        if (!self.selected) {
            calloutView?.removeFromSuperview()
        }
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        waypointsForMission.removeAtIndex(waypoint!.waypointNumber - 1)
        self.mainView!.mapView.removeAnnotation(waypoint)
        self.mainView!.waypointCounter--
        self.mainView!.updateNumeration()
    }
    
    @IBAction func heightChanged(sender: AnyObject) {
        var heightMilli = self.heightText.text.toInt()
        var height = heightMilli!*1000
        waypoint!.height = height
    }
    
    @IBAction func speedChanged(sender: AnyObject) {
        waypoint!.speed = self.speedText.text.toInt()!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, withEvent: event)
        
        if let callout = calloutView {
            if (hitView == nil && self.selected) {
                hitView = callout.hitTest(point, withEvent: event)
            }
        }
        
        hitOutside = hitView == nil
        
        return hitView;
    }
}