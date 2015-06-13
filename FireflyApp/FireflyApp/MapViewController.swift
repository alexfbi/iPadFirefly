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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var picturesFromDrone: UIImageView!
    
    var locationManager = CLLocationManager()
    var waypointCounter = 0
    var locationWasSet = false
    var selectedAnnotationView:MKAnnotationView?
    var gpsPositions:[GPS_Struct] = [GPS_Struct](){
        didSet{
            createPolyline()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Hybrid
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.showsBuildings = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTapAction:")
        doubleTap.numberOfTapsRequired = 2
        
        // Long press to add a waypoint
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        longPress.minimumPressDuration = 0.5
        
        mapView.addGestureRecognizer(longPress)
        
        // add waypoints of existing mission or after reload
        for index in 0..<waypointsForMission.count {
            self.mapView.addAnnotation(waypointsForMission[index])
        }
    
        //Linien zeichnen
        createPolyline()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawLine(gpsList: [GPS_Struct]) {
        self.gpsPositions = gpsList
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }
    
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
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
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
    
    // From WaypointTableDelegate
    func deleteWaypoint(waypointNumber: Int) {
        self.mapView.removeAnnotation(waypointsForMission[waypointNumber])
        self.waypointCounter--
        waypointsForMission.removeAtIndex(waypointNumber)
        self.updateNumeration()
    }
    
    func waypointWasSelected(waypointNumber: Int) {
        mapView.selectAnnotation(waypointsForMission[waypointNumber], animated: true)
    }
    
    func waypointsWereReordered(waypointNumber: Int, toPosition: Int) {
        var reorderedWaypoint = waypointsForMission[waypointNumber]
        waypointsForMission.removeAtIndex(waypointNumber)
        waypointsForMission.insert(reorderedWaypoint, atIndex: toPosition)
        self.updateNumeration()
    }
}

