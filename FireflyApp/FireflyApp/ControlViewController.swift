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



class ControlViewController: UIViewController,MissionModelDelegate {
    
    
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
    
    var buttonPressed = false
    var controlDBModell:ControlDBModel =  ControlDBModel()
    var controlTestDaten:ControlTestDatenModel = ControlTestDatenModel()
    
    
    var imageList = [UIImage]()
    
    var countNumber = 1.0
    
    let ANIMATIONDURATION: NSTimeInterval = 5
    
   
    @IBAction func buttonCreateDataPressed(sender: AnyObject) {
     
        
      //  controlTestDaten.createData()
        
      
  //  }
  //  @IBAction func buttonPressed(sender: AnyObject) {
        
        
        
        missionModel.name = "Mission"
        
        
        
        missionModel.gpsList.append(countNumber)
        
        //  var battery:Battery = Battery()
        //   battery.value = countNumber
      
        
        for i in 1...20{
            missionModel.batterieList.append(countNumber)
            missionModel.speedList.append(countNumber)
            
            
            
            let imageNameTmp = "\(countNumber % 10)"
            
            var image =  UIImage(named: imageNameTmp)
            
            if ( nil != image){
                missionModel.imageList.append(image!)
            }
            ++countNumber
  
        }
        
        
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
   /*
        controlDBModell.loadDataFromDB()
        controlDBModell.loadImagesFromFolder()
        imageList =  controlDBModell.imageList
        
        labelBatterie.text = controlDBModell.batterieToString()
        labelGPSx.text = controlDBModell.gpsToString()
        labelSpeed.text = controlDBModell.speedToString()
        
     */
        
        
       
     //   startAnimation()
    }
    
    
    
    var missionModel:MissionModel = MissionModel()
        {//1 -- instantiate a model object, for didSet need to define
        didSet{ //any change to the class, but not the properties
            displayData()
        }
    }
    
    
    func displayData() {
       
        imageList = missionModel.imageList
      
        if( imageList.count == 100 )
        {
            startAnimation()
        }
        
        
        
        let displayString = missionModel.batterieList.last
        
        labelBatterie.text = String(stringInterpolationSegment: displayString)
        
        
        let displayGpsX = missionModel.gpsList.last
        
        labelGPSx.text = String(stringInterpolationSegment: displayGpsX)
        
        
        let displaySpeed = missionModel.speedList.last
        
        labelSpeed.text = String(stringInterpolationSegment: displaySpeed)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control"
   
        
        self.startSwitch.on = false
        missionModel.delegate = self
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
