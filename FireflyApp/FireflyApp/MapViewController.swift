//
//  FirstViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 06.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ContentViewController, MKMapViewDelegate, CLLocationManagerDelegate, WaypointTableDelegate, ControlViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var picturesFromDrone: UIImageView!
    
    // MARK: - Variables
    
    var locationManager = CLLocationManager()
    var waypointCounter = 0
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
        
        // Add waypoints after reload
        for index in 0..<waypointsForMission.count {
            self.mapView.addAnnotation(waypointsForMission[index])
        }
        
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
        if (!locationWasSet) {
            zoomToUserLocation()
            locationWasSet = true
        }
    }
    
    // MARK: - Set and edit annotations
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        // The user location should not be shown as a pin of type WaypointView
        if (annotation is MKUserLocation) {
            return nil
        }
            
        else {
            var pin = WaypointView(annotation: annotation, reuseIdentifier: "myPin"/*, mainView: self*/)
            pin.mainView = self
            pin.waypoint = annotation as? Waypoint
            pin.label.text = "Waypoint \(pin.waypoint!.waypointNumber)"
            pin.animatesDrop = true
            pin.draggable = true
            pin.canShowCallout = false
            
            return pin
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        if let mapPin = view as? WaypointView {
            if mapPin.preventDeselection {
                mapView.selectAnnotation(view.annotation, animated: false)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if (newState == MKAnnotationViewDragState.Ending)
        {
            var droppedAt = view.annotation.coordinate
            var latitudeString = String(stringInterpolationSegment: droppedAt.latitude)
            var longitudeString = String(stringInterpolationSegment: droppedAt.longitude)
            var annotation = view.annotation as! Waypoint
            annotation.subtitle = "Latitude: \(latitudeString), Longitude: \(longitudeString)"
        }
    }
    
    /**
    Action to place a waypoint. Triggerd by a long tap.
    */
    func longPressAction(gestureRecognizer:UIGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            
            var touchPoint = gestureRecognizer.locationInView(self.mapView)
            var newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            var newAnnotation = Waypoint(coordinate: newCoord, waypointNumber: ++waypointCounter)
            waypointsForMission.insert(newAnnotation, atIndex: waypointCounter-1)
            self.mapView.addAnnotation(newAnnotation)
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        }
    }
    
    /**
    Updates the sequence of waypoints in the waypointsForMission array and posts the "refresh" notification
    */
    func updateNumeration() {
        let count = waypointsForMission.count
        waypointCounter = count
        if (count > 0) {
            for (var index = 0; index < count; index++) {
                var annotation = waypointsForMission[index] as Waypoint
                annotation.title = "Waypoint " + String(index+1)
                annotation.waypointNumber = index+1
            }
        }
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
    
    // MARK: - Implement WaypointTableDelegate
    
    /**
    Delete waypoint.
    
    :param: waypointNumber  Number of waypoint to delete.
    */
    func deleteWaypoint(waypointNumber: Int) {
        self.mapView.removeAnnotation(waypointsForMission[waypointNumber])
        self.waypointCounter--
        waypointsForMission.removeAtIndex(waypointNumber)
        self.updateNumeration()
    }
    
    /**
    Select waypoint.
    
    :param: wayointNumber   Number of waypoint to select.
    */
    func waypointWasSelected(waypointNumber: Int) {
        mapView.selectAnnotation(waypointsForMission[waypointNumber], animated: true)
    }
    
    /**
    Reorder waypoints.
    
    :param: waypointNumber  Number of reordered waypoint.
    :param: toPosition  New position of reordered waypoint.
    */
    func waypointsWereReordered(waypointNumber: Int, toPosition: Int) {
        var reorderedWaypoint = waypointsForMission[waypointNumber]
        waypointsForMission.removeAtIndex(waypointNumber)
        waypointsForMission.insert(reorderedWaypoint, atIndex: toPosition)
        self.updateNumeration()
    }
}
