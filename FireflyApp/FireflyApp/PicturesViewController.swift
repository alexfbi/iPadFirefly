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

/**
The controller animates the images, the NSTimeInterval = 10.
*/

class PicturesViewController: ContentViewController {

   //  var log : Log!
    
    // MARK: - Variable
    var imageList = [UIImage]()
    var pictures  = [Picture]()
    
    let ANIMATIONDURATION: NSTimeInterval = 10
   
    var controlDBModell:ControlDBModel =  ControlDBModel()

    // MARK: - Outlets
    @IBOutlet weak var myImageView: UIImageView!
   
    @IBOutlet weak var playButton: UIButton!
 
    
    // MARK: - IBAction
    @IBAction func playButtonPressed(sender: AnyObject) {
        
        controlDBModell.loadDataFromDB(log)
        controlDBModell.loadImagesFromFolder()
        imageList =  controlDBModell.imageList
        startAnimation()
    }
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pictures"
        // Do any additional setup after loading the view, typically from a nib.
       
     
    }
    
    
    
       

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func startAnimation() {
        if !myImageView.isAnimating(){
           
            NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
            NSLog("%@", "Animation started:  ")
            myImageView.animationImages = imageList
            myImageView.animationDuration = ANIMATIONDURATION
               myImageView.animationRepeatCount = 1
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

