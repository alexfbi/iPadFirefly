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

/**
This Class is used to save and load the data in the database
*/

class ControlDBModel {
    
    var imageList = [UIImage]()
    var pictures  = [Picture]()
    var gpsList = [GPS]()
    var batterieList = [Battery]()
    var speedList = [Speed]()

    var log : Log?
    

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


    init(){
      
        self.batterieList = [Battery]()
        
    }
    
    func loadDataFromDB() {
        if log != nil{
        NSLog("%@", "loadDataFromDB log ID:\(log!.id)")
        
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
        }
        else
            {
                NSLog("%@", "loadDataFromDB fehler")
            }
    
    
    }

    func loadDataFromDB(log: Log) -> Bool{
    
    self.log = log
        
    if (self.log != nil){
        
        loadDataFromDB()
        
        return true
        
        
    }
 
  
         return false
}
  
    
    /**
    Load image from folder
    */


func loadImagesFromFolder(){
    NSLog("%@", "Load image from Folder")
    
    if ( pictures.count > 0){
        
        imageList.removeAll(keepCapacity: false)
        
        for i in 0...pictures.count - 1
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
    }
   
    
}
    
    /**
    Load image from folder
    @param: path to file
    @return: image
    */


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
    /**
    Delete all GPS from db
    @param: log
    */
    
    
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
    /**
    Delete all images from db
    
    */
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