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
        var xAxis = UIBezierPath()
        var yAxis = UIBezierPath()
        
        let points = dataSource?.setPoints(self) ?? [CGPoint(x: 0, y: 0)]
        
        xAxis.moveToPoint(CGPoint(x: 100, y: 700))
        xAxis.addLineToPoint(CGPoint(x: 600, y: 700))
        
        yAxis.moveToPoint(CGPoint(x: 150, y: 150))
        yAxis.addLineToPoint(CGPoint(x: 150, y: 750))
        
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
        
        xAxis.lineWidth = 3
        yAxis.lineWidth = 3
        //  path.fill()
        path.stroke()
        xAxis.stroke()
        yAxis.stroke()
        
    }
    
    
}
