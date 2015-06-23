//
//  NetworkRecPicture.swift
//  FireflyApp
//
//  Created by Christian Adam on 27.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NetworkRecPicture {
    
    
    var imageList:[UIImage] = [UIImage]()
    var client:TCPClient?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var counter = 0
    
    func start(ip: String){
        var server:TCPServer = TCPServer(addr: ip, port: 51000)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            client = server.accept()
            if client != nil {
                println("connection etablished")
            }else{
                println("accept error")
            }
        }else{
            println(msg)
        }
    }
    
    var size:[UInt8] = [UInt8]()
    func receiveAndSavePicture(){
       
     //   var size = client!.read(5)
        var recPicture:[UInt8] = [UInt8]()
        
//  var int = (NSString(bytes: size, length: size.count, encoding: NSUTF8StringEncoding) as! String).toInt()!
         var cleanedSize = 342892
 //       if size != nil {
//            cleanedSize = (NSString(bytes: size!, length: size!.count, encoding: NSUTF8StringEncoding) as! String).toInt()!
//            if(cleanedSize > 0){
//                var packets: Int = cleanedSize/1024
//                for(var i:Int = 0; i<packets; i++){
//                    recPicture += client!.read(1024)!
//                }
//                recPicture += client!.read(cleanedSize%1024)!
//            }//
      //  }
        
        if client != nil {
        recPicture = client!.read(cleanedSize)!
        }
        
        if recPicture.count == cleanedSize{
            
            let fetchRequest = NSFetchRequest(entityName: "Log")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.fetchLimit = 1
            var log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            let docsDir = dirPaths[0] as! String
            let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
            let imageName = "/\(counter).png"
            let pathToFile = newDir.stringByAppendingString(imageName)
            
            
            let fileManager = NSFileManager.defaultManager()
            fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            
            var image = UIImage( data: NSData(bytes: recPicture, length: recPicture.count))
            var file = UIImagePNGRepresentation(image)
            file.writeToFile(pathToFile, atomically: true)
            
            
            
            
            var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: self.context!) as! Picture
            newPicture.id = counter
            newPicture.name = log.name
            newPicture.path = pathToFile
            newPicture.log = log
            self.context?.save(nil)
            
            counter++
            
            imageList.append(image!)
            recPicture.removeAll(keepCapacity: false)
            notify()
        }
    }
    
    func resetCounter(){
        counter = 0
    }
    
    func notify(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("MissionUpdate", object: self )
    }
    
}