//
//  ControlTestDaten.swift
//  FireflyApp
//
//  Created by ak on 02.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData
/**
This class create the test data for the output of the status information
*/
class ControlTestDatenModel {
     // MARK: - Variable
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  
    var countCreateData: Int
    
    var pictureCountOld:Int
    
    var log:Log?
   
   
     // MARK: - Init
    init(){
        self.countCreateData = 1
        self.pictureCountOld = 0
        
        
        let fetchRequest = NSFetchRequest(entityName: "Log")
        var logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
        
        log = logs.last

        if log != nil{
            writeImagesToFolder()
        }
        if log == nil{
         //    createTestDatenLog()
            
        }
      //  writeImagesToFolder()
    }
    
   
    // MARK: - Create test data
    
    /**
    Creates and save images in folder
    */
    
   private func writeImagesToFolder(){
        
        let fileManager = NSFileManager.defaultManager()
        
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log!.id)")
        
        var error: NSError?
        
        
        if !fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: &error) {
            
            println("Failed to create dir: \(error!.localizedDescription)")
        }
        
        
        for i in 1...20
        {
            let imageNameTmp = "\(i)"
            
            var image =  UIImage(named: imageNameTmp)
            
            
            let imageName = "/\(imageNameTmp).png"
            
            
            NSLog("%@", "Logname: \(imageName)")
            
            let pathToFile = newDir.stringByAppendingString( imageName)
            
            
            saveFileToDocumentsFolder( image!, pathToFile: pathToFile)
            
            
            
            
        }
        
        
        
    }
    
    /**
    Writes images to Folder
    */
    
    private   func saveFileToDocumentsFolder(image: UIImage, pathToFile: String){
        let fileManager = NSFileManager.defaultManager()
        
        
        if (!fileManager.fileExistsAtPath(pathToFile) ) {
            
            var file = UIImagePNGRepresentation(image)
            
            let fileToBeWritten = file.writeToFile(pathToFile, atomically: true)
            
            
            NSLog("%@", "file save true: \(fileToBeWritten)")
            
        }else
        {
            NSLog("%@", "file save false: \(pathToFile) ")
            
        }
        
        
    }
    
    
    /**
    Creates all test data
    */
    
    func createData(){
        
        
        var x:Double = 49.33
        x += Double(countCreateData) / 1000
        
        var y:Double = 8.33
        y += Double(countCreateData) / 1000
        
       var z = Double(countCreateData)
        
        createTestGPSDataToDB( x,y: y,z: z)
        createTestDatenBatterie()
        createTestDatenImage()
        createTestDatenSpeed()
       
         ++countCreateData
        
    }
    /**
    Creates log
    */
    private func createTestDatenLog(){
        
        var newLog = NSEntityDescription.insertNewObjectForEntityForName("Log", inManagedObjectContext: self.context!) as! Log
        
        
        newLog.name = "aktuelle Mission"
        
        newLog.id = 0
        log = newLog
        
        NSLog("%@", " new Log inserted: \(newLog.name)")
        
        self.context?.save(nil)
    }
    /**
    Creates speed test data
    */
  private  func createTestDatenSpeed(){
        var speed = NSEntityDescription.insertNewObjectForEntityForName("Speed", inManagedObjectContext: self.context!) as! Speed
        
        
        speed.value = countCreateData
        speed.id = countCreateData
        speed.date = NSDate()
        
        
        speed.log = log!
        
        
        self.context?.save(nil)

        
    }
    /**
     Creates image test data       
    */
  private  func createTestDatenImage(){
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log!.id)")
        
        
        let imageNameTmp = "\(countCreateData)"
        
        var image =  UIImage(named: imageNameTmp)
        
        
        let imageName = "/\(imageNameTmp).png"
        
        
        NSLog("%@", "ImageLogname: \(imageName)")
        
        let pathToFile = newDir.stringByAppendingString( imageName)
        
        var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: context!) as! Picture
        
        newPicture.name = imageName
        NSLog("%@", "Name: \(newPicture.name)")
        
        newPicture.path = pathToFile
        NSLog("%@", "Path: \(newPicture.path)")
        
        
        newPicture.log = log!
        
        
        self.context?.save(nil)
        
    }
    
    /**
    Creates battery test data
    */
 private   func createTestDatenBatterie(){
        
        var battery = NSEntityDescription.insertNewObjectForEntityForName("Battery", inManagedObjectContext: self.context!) as! Battery
        
        
        battery.value = countCreateData
        battery.id = countCreateData
        battery.date = NSDate()
        
       
        
        battery.log = log!
        
        
        self.context?.save(nil)
        

        
    }
    /**
     Creates gps test data
    :param: Double, Latitude
    :param: Double, Longitude
    :param: Double, Altitude
    */
 private func createTestGPSDataToDB(x: Double, y: Double, z: Double){
        NSLog("%@", " saveTestDataToDB")
        
                   var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
            
            newGPS.valueX = x
            newGPS.valueY = y
            newGPS.valueZ = z
            newGPS.log = log!
            
            NSLog("%@", " latitude: \(newGPS.valueX) : longitude  \(newGPS.valueY)")
            
            
            self.context?.save(nil)
            
        }
        
    
    //    @IBAction func buttonCreateDataPressed(sender: AnyObject) {
    //
    //
    //        //  controlTestDaten.createData()
    //
    //
    //
    //        missionModel.name = "MissionName"
    //
    //
    //
    //
    //        missionModel.gpsList.append(GPS_Struct(x: countNumber * 0.01, y: countNumber * 0.01, z:countNumber * 0.01))
    //
    //
    //        for i in 1...20{
    //            missionModel.batterieList.append(countNumber)
    //            missionModel.speedList.append(countNumber)
    //
    //
    //
    //            let imageNameTmp = "\(countNumber % 20)"
    //
    //            var image =  UIImage(named: imageNameTmp)
    //
    //            if ( nil != image){
    //                missionModel.imageList.append(image!)
    //            }
    //            ++countNumber
    //            
    //        }
    //        
    //     
    //        
    //        
    //       
    //    }


}