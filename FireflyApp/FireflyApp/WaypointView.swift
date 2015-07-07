//
//  WaypointView.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 20.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import MapKit

protocol WaypointViewDelegate {
    /**
    Calls the delegate to delete the waypoint from the array
    
    :param: waypointNumber  Number of waypoint to delete
    */
    func deleteWaypoint(waypointNumber: Int)
}

class WaypointView: MKPinAnnotationView, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var calloutView:CallOutView?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var speedText: UITextField!
    
    // MARK: - Variables
    var hitOutside:Bool = true
    var preventDeselection:Bool {
        return !hitOutside
    }
    var waypoint:Waypoint?
    var waypointViewDelegate:WaypointViewDelegate?
    
    // MARK:
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        NSBundle.mainBundle().loadNibNamed("CallOutView", owner: self, options: nil)
        
        self.heightText.delegate = self
        self.speedText.delegate = self
        
        waypoint = self.annotation as? Waypoint
        self.label.text = "Waypoint \(self.waypoint!.waypointNumber)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    
    /**
    Called when the delelte button is pressed.
    Deletes the corresponding waypoint to this view.
    
    :param: sender  The object sending the action.
    */
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        waypointViewDelegate!.deleteWaypoint(waypoint!.waypointNumber - 1)
    }
    
    /**
    Called when the height value was changed. 
    Changes the height of the corresponding waypoint.
    
    :param: sender  The object sending the action.
    */
    @IBAction func heightChanged(sender: AnyObject) {
        var heightMilli = self.heightText.text.toInt()
        var height = heightMilli!
        waypoint!.height = height
    }
    
    /**
    Called when the speed value was changed.
    Changes the speed of the corresponding waypoint.
    
    :param: sender  The object sending the action.
    */
    @IBAction func speedChanged(sender: AnyObject) {
        waypoint!.speed = self.speedText.text.toInt()!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Show the callout view 
    override func setSelected(selected: Bool, animated: Bool) {
                
        let calloutViewAdded = calloutView?.superview != nil
        
        
        if (selected || !selected && hitOutside) {
            super.setSelected(selected, animated: animated)
        }
        
        self.superview?.bringSubviewToFront(self)
        
        if (calloutView == nil) {
            calloutView = CallOutView()
        }
        
        // Show the callout view if selected and not already shown
        if (self.selected && !calloutViewAdded) {
            // Get the view to the right position
            calloutView!.frame.origin.x = -100
            calloutView!.frame.origin.y = -200
            
            // Show the waypoint information
            self.label.text = "Waypoint \(waypoint!.waypointNumber)"
            self.heightText.text = "\(waypoint!.height)"
            self.speedText.text = "\(waypoint!.speed)"
            
            addSubview(calloutView!)
        }
        
        // Remove the view if not selected
        if (!self.selected) {
            calloutView?.removeFromSuperview()
        }
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