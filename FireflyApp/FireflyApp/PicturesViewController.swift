//
//  PicturesViewController.swift
//  AFC1
//
//  Created by ak on 02.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import Foundation
import CoreData



class PicturesViewController: ContentViewController {

    
    var imageList = [UIImage]()
    var pictures  = [Picture]()
    
    let ANIMATIONDURATION: NSTimeInterval = 20
    let fileManager = NSFileManager.defaultManager()
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBOutlet weak var myImageView: UIImageView!
   
    @IBOutlet weak var playButton: UIButton!
 
    
    
    @IBAction func playButtonPressed(sender: AnyObject) {
    
    startAnimation()
    }
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pictures"
        // Do any additional setup after loading the view, typically from a nib.
    
        deleteAllBilderFromDB()
        writeImagesToDBAndFolder()
      
        loadDataFromDB()
        
        loadImagesFromFolder()
     
    }
    
    
    func loadDataFromDB(){
    let fetchRequest = NSFetchRequest(entityName: "Picture")
    fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
    
    pictures = context?.executeFetchRequest(fetchRequest, error: nil) as! [Picture]
    
    NSLog("%@", "Picture count: \(pictures.count)")
   
    }
    
    
    func loadImagesFromFolder(){
        
        imageList.removeAll(keepCapacity: false)
        
        if ( pictures.count > 0){
        for i in 0...pictures.count - 1
        {
            
            NSLog("%@", "Picture: \(i + 1 )")
            let path = pictures[i].path
            NSLog("%@", "Picture path: \(path) ")
            
            var image = loadImageFromDocumentsFolder(path)
            if ( image != nil){
                imageList.append( image!)

            }
        
            }
        }
    
    }
    
    func deleteAllBilderFromDB()
    {
        loadDataFromDB()
        if (pictures.count > 0 ){
            for i in 0...pictures.count - 1{
                context?.deleteObject(pictures[i])
                context?.save(nil)
            }
        }
       
        
    }
    
    func writeDataToDB (imageName: String, pathToFile: String){
        var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: self.context!) as! Picture
        
        newPicture.name = imageName
        NSLog("%@", "Name: \(newPicture.name)")
        
        newPicture.path = pathToFile
        NSLog("%@", "Path: \(newPicture.path)")
        
        
        newPicture.log = self.log!
        
        
        self.context?.save(nil)
        
    }
    
    func writeImagesToDBAndFolder(){
        
       
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
        
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
      // startAnimation()
    }

    func startAnimation() {
        if !myImageView.isAnimating(){
           
            NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
            NSLog("%@", "Animation started:  ")
            myImageView.animationImages = imageList
            myImageView.animationDuration = ANIMATIONDURATION
            
            playButton.titleLabel?.text = "Stopp"
            myImageView.startAnimating()
        }
        else
        {
            
            myImageView.stopAnimating()
           
           playButton.titleLabel?.text = "Start"

            NSLog("%@", "Animation stopped:  ")
         
        }
    }
}

