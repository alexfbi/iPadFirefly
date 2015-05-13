//
//  FirstViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 06.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var waypointTable: UITableView!
    
    var locationManager = CLLocationManager()
    var waypointCounter = 0
    var waypoints = [Waypoint]()
    var locationWasSet = false
    
    @IBAction func startStopButtonPressed(sender: AnyObject) {
        var network = Network(waypoints: self.waypoints)
        network.sendWaypoints()
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
            var pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pin.animatesDrop = true
            pin.draggable = true
            pin.canShowCallout = true
            
            // Delete Button
            let deleteButton:UIButton = UIButton.buttonWithType(.Custom) as! UIButton
            deleteButton.frame.size.width = 60
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = UIColor.redColor()
            deleteButton.setTitle("Delete", forState: .Normal)
            deleteButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
            pin.leftCalloutAccessoryView = deleteButton
            
            let optionsButton:UIButton = UIButton.buttonWithType(.Custom) as! UIButton
            optionsButton.frame.size.width = 80
            optionsButton.frame.size.height = 44
            optionsButton.backgroundColor = UIColor.blueColor()
            optionsButton.setTitle("Options", forState: .Normal)
            optionsButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
            pin.rightCalloutAccessoryView = optionsButton
            
            return pin
        }
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
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
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if (control == view.leftCalloutAccessoryView) {
            var waypoint:Waypoint = view.annotation as! Waypoint
            waypoints.removeAtIndex(waypoint.waypointNumber - 1)
            self.mapView.removeAnnotation(view.annotation)
            waypointCounter--
            updateNumeration()
        }
        
        else if (control == view.rightCalloutAccessoryView) {
            
        }
    }
    
    func longPressAction(gestureRecognizer:UIGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            
            var touchPoint = gestureRecognizer.locationInView(self.mapView)
            var newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            var newAnnotation = Waypoint(coordinate: newCoord, waypointNumber: ++waypointCounter)
            newAnnotation.title = "Waypoint " + String(newAnnotation.waypointNumber)
            //newAnnotation.subtitle = "Latitude: " + String(stringInterpolationSegment: newCoord.latitude) + ", Longitude: " + String(stringInterpolationSegment: newCoord.longitude)
            waypoints.insert(newAnnotation, atIndex: waypointCounter-1)
            self.mapView.addAnnotation(newAnnotation)
        }
    }
    
    func updateNumeration() {
        let count = waypoints.count
        waypointCounter = count
        if (count > 0) {
            for (var index = 0; index < count; index++) {
                var annotation = waypoints[index] as Waypoint
                annotation.title = "Waypoint " + String(index+1)
                annotation.waypointNumber = index+1
            }
        }
    }
    
    func doubleTapAction(gestureRecognizer:UIGestureRecognizer) {
        //self.mapView.removeAnnotations(mapView.selectedAnnotations)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

