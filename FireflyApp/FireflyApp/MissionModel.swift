//
//  MissionModel1.swift
//  FireflyApp
//
//  Created by ak on 14.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit


struct GPS_Struct{
    var x:Double
    var y:Double
    var z:Double
}

class MissionModel:NSObject{
    

    var imageList:[UIImage] = [UIImage](){
       
        didSet
        {
            notify()
            if imageList.count > 10
            {
               

                imageList.removeAll(keepCapacity: false)
            }
            
        }
    }
    
    
    var gpsList:[GPS_Struct] = [GPS_Struct](){
        didSet{
            notify()
            if gpsList.count > 10
            {
                
                
                gpsList.removeAll(keepCapacity: false)
            }
            
            
        }
        
    }
    
     var batterieList:[Double] = [Double](){
        didSet{
           
           notify()
            if batterieList.count > 10{
                batterieList.removeAll(keepCapacity: false)

            }

        }
        
    }
    
    
    var speedList:[Double] = [Double]() {
        didSet{
             notify()
            
            if speedList.count > 10{
                speedList.removeAll(keepCapacity: false)
                
            }
            
           
                    }
        
    }
    
    
    
    var value:Double = 0.0{
        didSet{
           notify()
        }
    }
    
    var name:String = "Mission"{
        didSet{
           notify()
        }
    }
    
    
    
    /**
        Broadcast about changes
        @brief  NSNotification: MissionUpdate
    */
    
  private func notify(){
        NSLog("%@", "Notify Observers")
    
        NSNotificationCenter.defaultCenter().postNotificationName("Mission", object: self, userInfo: ["mission": self])
    }
    
}