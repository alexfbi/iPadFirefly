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
    
    

    var gpsPositions = [GPS]()
    
     let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
   
    
    @IBOutlet weak var mapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GPS"
        self.mapKit.delegate = self
        
        deleteAllGpsFromDB()
        saveTestDataToDB()
        loadDataFromDB()
        createPolyline()
        
    }
    
    
    func loadDataFromDB(){
        NSLog("%@", " loadDataFromDB")
        
        let fetchRequest = NSFetchRequest(entityName: "GPS")
        fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
        
        gpsPositions = context?.executeFetchRequest(fetchRequest, error: nil) as! [GPS]
        
        NSLog("%@", "GPS count: \(gpsPositions.count)")
        
    }
    
    func deleteAllGpsFromDB()
    {
         NSLog("%@", " deleteAllGpsFromDB")
        loadDataFromDB()
        if( gpsPositions.count >  0 ){
           
            for i in 0...gpsPositions.count - 1{
                context?.deleteObject(gpsPositions[i])
                context?.save(nil)
            }
        }
       gpsPositions.removeAll(keepCapacity: false)
        
    }
    
    
    func saveTestDataToDB(){
          NSLog("%@", " saveTestDataToDB")
    
        var  valueX1 = 49.875545
        var  valueX2 = 49.876694
        var  valueX3 = 49.879938
        var  valueX4 = 49.879858
        var  valueX5 = 49.876145
        var  valueX6 = 49.875545
        var  valueX7 = 49.87673
        
        var  valueY1 = 8.652918
        var  valueY2 = 8.650968
        var  valueY3 = 8.650930
        var  valueY4 = 8.652952
        var  valueY5 = 8.654787
        var  valueY6 = 8.652918
        var  valueY7 = 8.652910
        
        var valueXY1 = [valueX1, valueY1]
        var valueXY2 = [valueX2, valueY2]
        var valueXY3 = [valueX3, valueY3]
        var valueXY4 = [valueX4, valueY4]
        var valueXY5 = [valueX5, valueY5]
        var valueXY6 = [valueX6, valueY6]
        var valueXY7 = [valueX7, valueY7]
        
        var  valueXY =  [valueXY1,valueXY2, valueXY3,valueXY4, valueXY5, valueXY6, valueXY7]
        
        
        for i in 0...valueXY.count - 1
        {
            var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
            
            newGPS.valueX = (valueXY[i])[0]
            newGPS.valueY = (valueXY[i])[1]
            newGPS.log = self.log!
            
            NSLog("%@", " latitude: \(i) : \(newGPS.valueX) : longitude  \(newGPS.valueY)")
         

            self.context?.save(nil)
            
        }
        
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
