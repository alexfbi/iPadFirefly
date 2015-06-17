//
//  FirstViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 06.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ContentViewController, MKMapViewDelegate, CLLocationManagerDelegate, WaypointTableDelegate, ControlViewDelegate, WaypointViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var picturesFromDrone: UIImageView!
    
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
        
        // TODO: Add waypoints of existing mission from database
    
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
    Zooms to the location of the iPad
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
            
        else {
            var pin = WaypointView(annotation: annotation, reuseIdentifier: "myPin")
            pin.waypointViewDelegate = self
            pin.animatesDrop = true
            pin.draggable = true
            pin.canShowCallout = false
            
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
    
    // TODO: Just needed if the coordinates were shown
    /*
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if (newState == MKAnnotationViewDragState.Ending)
        {
            var droppedAt = view.annotation.coordinate
            var latitudeString = String(stringInterpolationSegment: droppedAt.latitude)
            var longitudeString = String(stringInterpolationSegment: droppedAt.longitude)
            var annotation = view.annotation as! Waypoint
            annotation.subtitle = "Latitude: \(latitudeString), Longitude: \(longitudeString)"
        }
    } */
    
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
        self.gpsPositions = gpsList
    }
    
    func createPolyline() {
        NSLog("%@", " createPolyLine: ")
        
        if (gpsPositions.count > 0){
            
            let location = CLLocationCoordinate2D(
                latitude: gpsPositions[0].x,
                longitude: gpsPositions[0].y)
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
            
            var locations = [CLLocation]()
            
            for i in 0...gpsPositions.count - 1 {
                
                locations += [CLLocation(latitude: gpsPositions[i].x, longitude:   gpsPositions[i].y)]
                
                
            }
            var coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
            
            var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
            
            
            
            self.mapView.addOverlay(polyline)
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
    
    func updateUI(){
        
        mapView?.setNeedsDisplay()
    }
    
    // MARK: - Implement delegates
    
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
    
    // MARK: - Implement ControlViewDelegate
    func getWaypoints() -> [Waypoint] {
        return self.waypoints
    }
    
    func deselectWaypoints() {
        if (self.mapView.selectedAnnotations != nil) {
            var selectedWaypoints = self.mapView.selectedAnnotations as! [Waypoint]
            for selectedWaypoint in selectedWaypoints {
                self.mapView.deselectAnnotation(selectedWaypoint, animated: true)
            }
        }
    }
    
}

