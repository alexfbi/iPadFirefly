//
//  ControlDBModal.swift
//  FireflyApp
//
//  Created by ak on 01.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ControlDBModel {
    
    var imageList = [UIImage]()
    var pictures  = [Picture]()
    var gpsList = [GPS]()
    var batterieList = [Battery]()
    var speedList = [Speed]()

    var log : Log?
    

   

    var pictureCountOld:Int

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


    init(){
      
        self.pictureCountOld = 0
        
        let fetchRequest = NSFetchRequest(entityName: "Log")
        var logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
        log = logs.last
        
        if log != nil{
            loadDataFromDB(log!)
            loadImagesFromFolder()
        }
        
    }
    
    func loadDataFromDB() {
        if log != nil{
        NSLog("%@", "loadDataFromDB")
        
        let fetchRequestPicture = NSFetchRequest(entityName: "Picture")
        fetchRequestPicture.predicate = NSPredicate(format: "log = %@", log!)
        
        pictures = context?.executeFetchRequest(fetchRequestPicture, error: nil) as! [Picture]
        
        
        let fetchRequestGPS = NSFetchRequest(entityName: "GPS")
        fetchRequestGPS.predicate = NSPredicate(format: "log = %@", log!)
        
        gpsList  = context?.executeFetchRequest(fetchRequestGPS, error: nil) as! [GPS]
        
        
        let fetchRequestBatterie = NSFetchRequest(entityName: "Battery")
        fetchRequestBatterie.predicate = NSPredicate(format: "log = %@", log!)
        
        batterieList = context?.executeFetchRequest(fetchRequestBatterie, error: nil) as! [Battery]
        
        
        let fetchRequestSpeed = NSFetchRequest(entityName: "Speed")
        fetchRequestSpeed.predicate = NSPredicate(format: "log = %@", log!)
        
        speedList = context?.executeFetchRequest(fetchRequestSpeed, error: nil) as! [Speed]
        }}

    func loadDataFromDB(log: Log) -> Bool{
    
    self.log = log
        
    if (self.log == nil){
        
    return false
        
        
    }
 
    loadDataFromDB()
    
    return true
}
    
    func batterieToString() -> String{
       
        var batterie: Battery?
        NSLog("%@", "Count Batterie:  \(batterieList.count)")
        
        batterie = batterieList.last
        
        if (batterie != nil){
            var number = batterie!.value
            
            var str  = String( stringInterpolationSegment: number)
            
          return    str
        }
        
        return String("")
    }
    

    func speedToString() -> String{
        NSLog("%@", "Count Speed: \(speedList.count)")
         var speed: Speed?
        speed = speedList.last
        
        if (speed != nil){
            var number = speed!.value
            
            var str  = String( stringInterpolationSegment: number)
            
           return  str
        }
        
        return ""

    }
    
    
    func gpsToString() ->  String {
    
        NSLog("%@", "Count GPS: \(gpsList.count)")
        
        var gps = gpsList.last
        
        if (gps != nil){
            var height = gps!.valueZ
            var gpsX = gps!.valueX
            var gpsY = gps!.valueY
            
           
             var str = ""
            
            var str1  = String( stringInterpolationSegment: gpsX)
            str += " "
            str += str1
            
            str1  = String( stringInterpolationSegment: gpsY)
             str += " "
            str += str1
             str1 = String( stringInterpolationSegment: height)
            str += " "
            str += str1
            
        return str
        }
        
        return String( "")
    }
    
    
    
    func getImageList() -> [UIImage]{
    
    
    return imageList
    }
    
    func getGPSList() -> [GPS]{
        
        
        return gpsList
    }
    
    func getBatterieList() -> [Battery]{
        
        
        return batterieList
    }



func loadImagesFromFolder(){
    NSLog("%@", "Load image from Folder")
    
    if ( pictures.count > pictureCountOld){
        
        imageList.removeAll(keepCapacity: false)
        
        for i in pictureCountOld...pictures.count - 1
        {
            
            NSLog("%@", "Picture: \(i )")
            let path = pictures[i].path
            //    NSLog("%@", "Picture path: \(path) ")
            
            var image = loadImageFromDocumentsFolder(path)
            if ( image != nil){
                imageList.append( image!)
                
            }
            
            
        }
        NSLog("%@", "Picture count: \(pictures.count)")
        pictureCountOld = pictures.count
    }
    else
    {
        
        NSLog("%@", "Picture Count  \(pictures.count) < PictureCountOld")
    }
    
}


func loadImageFromDocumentsFolder(pathToFile: String) -> UIImage? {
    
    let fileManager = NSFileManager.defaultManager()
    

    
    if (fileManager.fileExistsAtPath(pathToFile))
    {
        
        let image = UIImage(contentsOfFile: pathToFile)!
        
        
        NSLog("%@", "load file true: \(pathToFile)")
        return image
    }
    else{
        
        NSLog("%@", "load file false: \(pathToFile)")
        
    }
    
    return nil
    
}
    
    func deleteAllGpsFromDB(log:Log)
    {
        NSLog("%@", " deleteAllGpsFromDB")
        loadDataFromDB(log)
        if( gpsList.count >  0 ){
            
            for i in 0...gpsList.count - 1{
                context?.deleteObject(gpsList[i])
                context?.save(nil)
            }
        }
        gpsList.removeAll(keepCapacity: false)
        
    }
    
    func deleteAllBilderFromDB(log:Log)
    {
        loadDataFromDB(log)
        if (pictures.count > 0 ){
            for i in 0...pictures.count - 1{
                context?.deleteObject(pictures[i])
                context?.save(nil)
            }
        }
        
        
    }

    
    
}