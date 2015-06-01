//
//  PicturesLiveViewController.swift
//  FireflyApp
//
//  Created by ak on 29.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//


import UIKit
import Foundation
import CoreData



class PicturesLiveViewController: UIViewController {
    
    @IBOutlet weak var ImageView: UIImageView!
    
   
    @IBOutlet weak var labelGPSx: UILabel!
    @IBOutlet weak var labelGPSy: UILabel!
    
    @IBOutlet weak var labelBatterie: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var labelHeight: UILabel!
    
    
    var imageList = [UIImage]()
    var pictures  = [Picture]()
    var gpsDaten = [GPS]()
    var entries = [Entry]()
    
    var log : Log?
    var entry: Entry?
    
    var pictureCountOld:Int = 0
    
    let ANIMATIONDURATION: NSTimeInterval = 10
    let fileManager = NSFileManager.defaultManager()
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
        loadDataFromDB()
        loadImagesFromFolder()
        
        
        
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control"
        // Do any additional setup after loading the view, typically from a nib.
        
        loadDataFromDB()
        
        loadImagesFromFolder()
        
        
      
        //labelGPSx.text = ""

    }
    
    
    func loadDataFromDB(){
         NSLog("%@", "loadDataFromDB")
        if(log == nil)
        {
            let fetchRequest = NSFetchRequest(entityName: "Log")
            var logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
            log = logs.last
        }
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
        
        pictures = context?.executeFetchRequest(fetchRequest, error: nil) as! [Picture]
        
        
        let fetchRequestGPS = NSFetchRequest(entityName: "GPS")
        fetchRequestGPS.predicate = NSPredicate(format: "log = %@", log!)
        
        gpsDaten  = context?.executeFetchRequest(fetchRequestGPS, error: nil) as! [GPS]

        
        let fetchRequestEntry = NSFetchRequest(entityName: "Entry")
        fetchRequestEntry.predicate = NSPredicate(format: "log = %@", log!)
        
        entries = context?.executeFetchRequest(fetchRequestEntry, error: nil) as! [Entry]


        
        
        
        NSLog("%@", "Count Entry \(entries.count)")

        entry = entries.last!
        
        var number = entry!.valueX
        
        var str  = String( stringInterpolationSegment: number)
        
        labelHeight.text = str
    
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
            
             NSLog("%@", "Picture Count < PictureCountOld")
        }
        
    }
 
    func loadImageFromDocumentsFolder(pathToFile: String) -> UIImage? {
        
        
        
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
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    

    
    func startAnimation() {
        if !ImageView.isAnimating(){
            
            NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
            NSLog("%@", "Animation started:  ")
            ImageView.animationImages = imageList
            ImageView.animationDuration = ANIMATIONDURATION
            
            
            ImageView.animationRepeatCount = 1
            ImageView.startAnimating()
           
        }
        else
        {
            
            ImageView.stopAnimating()
            
            
            NSLog("%@", "Animation stopped:  ")
            
        }
    }
}
