//
//  BilderViewController.swift
//  AFC1
//
//  Created by ak on 02.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import Foundation
import CoreData



class BilderViewController: UIViewController {

    
    var log: Log?
    var imageList = [UIImage]()
    var bilder = [Bild]()
    
    let ANIMATIONDURATION: NSTimeInterval = 0.2
    let fileManager = NSFileManager.defaultManager()
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var animationButton: UIButton!
 
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bilder"
        // Do any additional setup after loading the view, typically from a nib.
    
        deleteAllBilderFromDB()
        writeImagesToDBAndFolder()
      
        loadDataFromDB()
        
        loadImagesFromFolder()
     
    }
    
    
    func loadDataFromDB(){
    let fetchRequest = NSFetchRequest(entityName: "Bild")
    fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
    
    bilder = context?.executeFetchRequest(fetchRequest, error: nil) as [Bild]
    
    NSLog("%@", "Bilder anzahl: \(bilder.count)")
   
    }
    
    
    func loadImagesFromFolder(){
        
        imageList.removeAll(keepCapacity: false)
        
        if ( bilder.count > 0){
        for i in 0...bilder.count - 1
        {
            
            NSLog("%@", "Bild: \(i + 1 )")
            let pfad = bilder[i].pfad
            NSLog("%@", "Bildpfad: \(pfad) ")
            
            var image = loadImageFromDocumentsFolder(pfad)
            if ( image != nil){
                imageList.append( image!)

            }
        
            }
        }
    
    }
    
    func deleteAllBilderFromDB()
    {
        loadDataFromDB()
        if (bilder.count > 0 ){
            for i in 0...bilder.count - 1{
                context?.deleteObject(bilder[i])
                context?.save(nil)
            }
        }
       
        
    }
    
    func writeDataToDB (imageName: String, pathToFile: String){
        var newBild = NSEntityDescription.insertNewObjectForEntityForName("Bild", inManagedObjectContext: self.context!) as Bild
        
        newBild.name = imageName
        NSLog("%@", "Name: \(newBild.name)")
        
        newBild.pfad = pathToFile
        NSLog("%@", "Pfad: \(newBild.pfad)")
        
        
        newBild.log = self.log!
        
        
        self.context?.save(nil)
        
    }
    
    func writeImagesToDBAndFolder(){
        
       
        let documentsFolder = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask , true) [0] as String
        
        for i in 1...6
        {
            let imageNameTmp = "\(i)"
            
            var image =  UIImage(named: imageNameTmp)
           
            
            let imageName = "/\(imageNameTmp).png"
            
            
            NSLog("%@", "Logname: \(imageName)")
            
            let pathToFile = documentsFolder.stringByAppendingString( imageName)
            
            
            saveFileToDocumentsFolder( image!, pathToFile: pathToFile)
            
            writeDataToDB(imageName, pathToFile: pathToFile)
           
           
        }
        
        
        
    }
    
    
    func loadImageFromDocumentsFolder(pathToFile: String) -> UIImage? {
        
        
        
        if (fileManager.fileExistsAtPath(pathToFile))
        {
            
           let image = UIImage(contentsOfFile: pathToFile)!
            
            
            NSLog("%@", "load file true:  \(pathToFile)")
         return image
        }
        else{
            
            NSLog("%@", "load file false: \(pathToFile)")
           
        }
        
    return nil
       
    }

    func saveFileToDocumentsFolder(image: UIImage, pathToFile: String){
        
        if (!fileManager.fileExistsAtPath(pathToFile) ) {
            
            var file = UIImagePNGRepresentation(image)
      
            let fileToBeWritten = file.writeToFile(pathToFile, atomically: true)
    
            
            NSLog("%@", "file save true: \(fileToBeWritten)")
            
        }else
        {
             NSLog("%@", "file save false: \(pathToFile) ")
         
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    
    
    @IBAction func animationButtonPressed(sender: AnyObject) {
        startAnimation()
    }

    func startAnimation() {
        if !myImageView.isAnimating(){
           
            NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
            NSLog("%@", "Animation started:  ")
            myImageView.animationImages = imageList
            myImageView.animationDuration = ANIMATIONDURATION
          
            myImageView.startAnimating()
        }
        else
        {
            
            myImageView.stopAnimating()
           
            NSLog("%@", "Animation stopped:  ")
         
        }
    }
}

