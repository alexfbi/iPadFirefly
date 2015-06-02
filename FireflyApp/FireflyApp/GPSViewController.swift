//
//  GPSViewController.swift
//  AFC1
//
//  Created by ak on 09.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData



class GPSViewController: ContentViewController, MKMapViewDelegate  {
    
  //  var log : Log!
    var controlDBModell:ControlDBModel =  ControlDBModel()
   
    var gpsPositions = [GPS]()
    
    
    
    @IBOutlet weak var mapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GPS"
        self.mapKit.delegate = self
        
     
        controlDBModell.loadDataFromDB(log)
      
        gpsPositions = controlDBModell.gpsList
       
        createPolyline()
        
    }
    
    
   
    
    func createPolyline() {
        NSLog("%@", " createPolyLine: ")

        if (gpsPositions.count > 0){
            
            let location = CLLocationCoordinate2D(
                latitude: gpsPositions[0].valueX,
                longitude: gpsPositions[0].valueY)
        
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
        
            mapKit.setRegion(region, animated: true)
        
            var locations = [CLLocation]()
        
            for i in 0...gpsPositions.count - 1 {
        
                locations += [CLLocation(latitude: gpsPositions[i].valueX, longitude:   gpsPositions[i].valueY)]
        
            
            }
            var coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
        
            var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        
        
        
            self.mapKit.addOverlay(polyline)
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
