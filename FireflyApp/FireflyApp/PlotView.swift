//
//  PlotView.swift
//  AFC1
//
//  Created by ak on 10.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit

protocol PlotViewDataSource: class{
    func setPoints( sender: PlotView) -> [CGPoint?]
    
}

class PlotView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    
    weak var dataSource: PlotViewDataSource?
    
    
    
    override func drawRect(rect: CGRect) {
        
        var path = UIBezierPath()
        var xAchse = UIBezierPath()
        var yAchse = UIBezierPath()
        
        let points = dataSource?.setPoints(self) ?? [CGPoint(x: 0, y: 0)]
        
        xAchse.moveToPoint(CGPoint(x: 100, y: 700))
        xAchse.addLineToPoint(CGPoint(x: 600, y: 700))
        
        yAchse.moveToPoint(CGPoint(x: 150, y: 150))
        yAchse.addLineToPoint(CGPoint(x: 150, y: 750))
        
        let count =  points.count
        
        if count > 0
            
        {
            path.moveToPoint(points[0]!)
            
        }
        
        if count > 1{
            for i in 1...count - 1
            {
                path.addLineToPoint(points[i]!)
                
            }
        }
        
        //UIColor.greenColor().setFill()
        //UIColor.greenColor().setStroke()
        
        path.lineWidth = 1
        
        xAchse.lineWidth = 3
        yAchse.lineWidth = 3
        //  path.fill()
        path.stroke()
        xAchse.stroke()
        yAchse.stroke()
        
    }
    
    
}
