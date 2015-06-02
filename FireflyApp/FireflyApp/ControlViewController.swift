//
//  ControlViewController.swift
//  FireflyApp
//
//  Created by ak on 29.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//


import UIKit
import Foundation
import CoreData



class ControlViewController: UIViewController {
    
    @IBOutlet weak var startSwitch: UISwitch!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var labelGPSx: UILabel!
    @IBOutlet weak var labelGPSy: UILabel!
    @IBOutlet weak var labelBatterie: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var buttonCreateData: UIButton!
  
    var log:Log?
    
    var controlDBModell:ControlDBModel =  ControlDBModel()
    var controlTestDaten:ControlTestDatenModel = ControlTestDatenModel()
    
    
    var imageList = [UIImage]()
    
    
    let ANIMATIONDURATION: NSTimeInterval = 2
    
   
    @IBAction func buttonCreateDataPressed(sender: AnyObject) {
     
        
        controlTestDaten.createData()
    }
    
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
        
        controlDBModell.loadDataFromDB()
        controlDBModell.loadImagesFromFolder()
        imageList =  controlDBModell.imageList
        
        labelBatterie.text = controlDBModell.batterieToString()
        labelGPSx.text = controlDBModell.gpsToString()
        labelSpeed.text = controlDBModell.speedToString()
        
        
        startAnimation()
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control"
   
        
        self.startSwitch.on = false
     
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startSwitchChanged(sender: AnyObject) {
        
        if (self.startSwitch.on) {
            if (self.startSwitch.on) {
                var networkSender = NetworkSender()
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    networkSender.start()
                }
            }

        }

    }

    
    func startAnimation() {
            
            NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
            NSLog("%@", "Animation started:  ")
            ImageView.animationImages = imageList
            ImageView.animationDuration = ANIMATIONDURATION
            
            
            ImageView.animationRepeatCount = 1
        
            ImageView.startAnimating()
            
    
    }
}
