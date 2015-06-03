//
//  MissionModel.swift
//  FireflyApp
//
//  Created by ak on 03.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation


import UIKit

protocol MissionModelDelegate{
    func displayData()
}



class MissionModel:NSObject{
    
    
    
    
    var delegate:MissionModelDelegate? = nil
    
    
    var imageList:[UIImage] = [UIImage](){
     //   didSet{
    //        delegate?.displayData()
   //     }

        
        didSet
        {
            if imageList.count == 100
            {
                 delegate?.displayData()
                imageList.removeAll(keepCapacity: true)
            }
        }
    }
    var gpsList:[Double] = [Double](){
        didSet{
            delegate?.displayData()
        }

    }
    var batterieList:[Double] = [Double](){
        didSet{
            delegate?.displayData()
        }

    }
   
    
    var speedList:[Double] = [Double]() {
        didSet{
            delegate?.displayData()
        }
        
    }
    
    
    
    var value:Double = 0.0{
        didSet{
            delegate?.displayData()
        }
    }
    
    var name:String = "Mission"{
        didSet{
            delegate?.displayData()
        }
    }
    
}