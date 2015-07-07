//
//  FirstViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 06.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

/**
This class contains the MapView and provides functions to set, delete and drag waypoints. Also it contains the functionality to show the user location and the location of the drone as well as the route that was flown by the drone
*/
class MapViewController: ContentViewController, MKMapViewDelegate, CLLocationManagerDelegate, WaypointTableDelegate, ControlViewDelegate, WaypointViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var connectionStatus: UIButton!
    
    // MARK: - Variables
    
    var locationManager = CLLocationManager()
    var waypointCounter = 0
    var waypoints:[Waypoint] = [Waypoint]()
    var locationWasSet = false
    var selectedAnnotationView:MKAnnotationView?
    var gpsPositions:[GPS_Struct] = [GPS_Struct](){
        didSet{
            createPolyline()
        }
    }
    var currentDronePosition:MKPointAnnotation?
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting delegates
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        // Setting mapType to hybrid (sattelite image with road information)
        self.mapView.mapType = MKMapType.Hybrid
        
        // The location manager shows the actual position of the iOS device
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.showsBuildings = false
        
        // Long press to add a waypoint
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
    
        // Draw line for the route
        createPolyline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Show user location
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }
    
    /**
    Zooms to the location of the device
    */
    func zoomToUserLocation() {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 400, 400)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        // Just zoom to the user location once when the app was started. Otherwise you can't scroll the map.
        if (!locationWasSet) {
            zoomToUserLocation()
            locationWasSet = true
        }
    }
    
    // MARK: - Set and edit annotations
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        // The user location should not be shown as a pin of type WaypointView. nil gives the blue dot.
        if (annotation is MKUserLocation) {
            return nil
        }
        
        // The position of the drone is shown as a purple pin
        if (annotation is MKPointAnnotation) {
            var pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "dronePosition")
            pin.pinColor = MKPinAnnotationColor.Purple
            pin.canShowCallout = true
            
            return pin
        }
            
        // A waypoint returns our custom WaypointView
        else {
            var pin = WaypointView(annotation: annotation, reuseIdentifier: "myPin")
            pin.waypointViewDelegate = self
            pin.animatesDrop = true
            pin.draggable = true
            pin.canShowCallout = false // do not show the default callout view
            
            return pin
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        // Prevents the callout view from dissapearing when tapping inside.
        if let mapPin = view as? WaypointView {
            if mapPin.preventDeselection {
                mapView.selectAnnotation(view.annotation, animated: false)
            }
        }
    }
    
    /**
    Action to place a waypoint. Triggerd by a long tap.
    */
    func longPressAction(gestureRecognizer:UIGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            
            // Translate the touch point into coordiantes
            var touchPoint = gestureRecognizer.locationInView(self.mapView)
            var newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            // Create a new annotation and add it to the map and into the waypoints array
            var newAnnotation = Waypoint(coordinate: newCoord, waypointNumber: ++waypointCounter)
            waypoints.insert(newAnnotation, atIndex: waypointCounter-1)
            self.mapView.addAnnotation(newAnnotation)
            
            // Notify the observers
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        }
    }
    
    /**
    Updates the sequence of waypoints in the waypoints array and posts the "refresh" notification
    */
    func updateNumeration() {
        let count = waypoints.count
        waypointCounter = count
        
        // Update the numeration of all waypoints inside the array
        for (var index = 0; index < count; index++) {
            var annotation = waypoints[index] as Waypoint
            annotation.title = "Waypoint " + String(index+1)
            annotation.waypointNumber = index+1
        }
        
        // Notify the observers
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }
    
    // MARK: - Draw route of drone
    
    func drawLine(gpsList: [GPS_Struct]) {
        self.gpsPositions = gpsList // triggers createPolyline()
        
        // set the position of the drone on the map
        dispatch_async(dispatch_get_main_queue()) {
            self.setDronePosition()
        }
    }
    
    /**
    Draws the route flown by the drone.
    */
    func createPolyline() {
        NSLog("%@", " createPolyLine: ")
        
        if (gpsPositions.count > 0){
            var locations = [CLLocation]()
            for i in 0...gpsPositions.count - 1 {
                locations += [CLLocation(latitude: gpsPositions[i].x, longitude:   gpsPositions[i].y)]
            }
            var coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
            var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
            
            // add the overlay to the map
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addOverlay(polyline)
            }
      }
    }
    
    /**
    Sets the position of the drone on the map
    */
    func setDronePosition() {
        if (gpsPositions.count > 0) {
            // remove old position of the drone
            self.mapView.removeAnnotation(self.currentDronePosition)
            
            // create the annotation
            var dronePosition = MKPointAnnotation()
            dronePosition.coordinate = CLLocationCoordinate2D(latitude: gpsPositions.last!.x, longitude: gpsPositions.last!.y)
            dronePosition.title = "Current position of the drone"
            
            // save the current drone position so it can be deleted later
            currentDronePosition = dronePosition
            
            self.mapView.addAnnotation(dronePosition)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        NSLog("%@" ,"viewForOverlay");
        
        if (overlay is MKPolyline) {
            var pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            pr.lineWidth = 5
            
            return pr
        }
        
        return nil
    }
    
    /**
    Updates the UI
    */
    func updateUI() {
        mapView?.setNeedsDisplay()
    }
    
    // MARK: - Implement delegate functions
    
    /**
    Delete waypoint.
    
    :param: waypointNumber  Number of waypoint to delete.
    */
    func deleteWaypoint(waypointNumber: Int) {
        self.mapView.removeAnnotation(waypoints[waypointNumber])
        self.waypointCounter--
        waypoints.removeAtIndex(waypointNumber)
        self.updateNumeration()
    }
    
    /**
    Select waypoint.
    
    :param: wayointNumber   Number of waypoint to select.
    */
    func waypointWasSelected(waypointNumber: Int) {
        mapView.selectAnnotation(waypoints[waypointNumber], animated: true)
    }
    
    /**
    Reorder waypoints.
    
    :param: waypointNumber  Number of reordered waypoint.
    :param: toPosition  New position of reordered waypoint.
    */
    func waypointsWereReordered(waypointNumber: Int, toPosition: Int) {
        var reorderedWaypoint = waypoints[waypointNumber]
        waypoints.removeAtIndex(waypointNumber)
        waypoints.insert(reorderedWaypoint, atIndex: toPosition)
        self.updateNumeration()
    }

    /**
    Returns the waypoints set by the user.
    
    :returns: An array of waypoints.
    */
    func getWaypoints() -> [Waypoint] {
        return self.waypoints
    }
    
    /**
    Deselects all selected waypoints.
    */
    func deselectWaypoints() {
        if (self.mapView.selectedAnnotations != nil) {
            var selectedWaypoints = self.mapView.selectedAnnotations as! [Waypoint]
            for selectedWaypoint in selectedWaypoints {
                self.mapView.deselectAnnotation(selectedWaypoint, animated: true)
            }
        }
    }
    
    /**
    Changes the connection label to the current connectios status.
    
    :param: isConnected Describes wether the iPad is connected or not. 
    */
    func setConnectionLabel(isConnected: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            if isConnected {
                self.connectionStatus.setTitle("Connected", forState: .Normal)
                self.connectionStatus.setTitleColor(UIColor.greenColor(), forState: .Normal)
            } else {
                self.connectionStatus.setTitle("Not Connected", forState: .Normal)
                self.connectionStatus.setTitleColor(UIColor.redColor(), forState: .Normal)
            }
        }
    }
    
}

