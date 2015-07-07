//
//  PlotView.swift
//  AFC1
//
//  Created by ak on 10.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit



protocol PlotViewDataSource: class{
    /**
    Set the points to be plottet
    @return: Array with status infomation, minimum and maximum value
    */
    func setPoints( sender: PlotView) -> ([CGPoint?], Double, Double)
    
}

/**
Plots one status information.

*/
var scale:CGFloat = 1.5

class PlotView: UIView {
    
    
    
    weak var dataSource: PlotViewDataSource?
    
    
    
    override func drawRect(rect: CGRect) {
        
        var path = UIBezierPath()
        var xAxis = UIBezierPath()
        var yAxis = UIBezierPath()
        
        
        let boundsize = self.bounds.size
        //    NSLog("%@", " Boundsize height: \(boundsize.height)")
        //    NSLog("%@", " Boundsize width: \(boundsize.width)")
        
        var centerGraph:CGPoint = convertPoint( center, fromView: superview)
        
        var centerX:CGFloat = centerGraph.x
        var centerY:CGFloat = centerGraph.y
        
        
        // NSLog("%@", " Center graph: \(centerGraph)")
        
        
        var minimum:CGFloat { return min(boundsize.height, boundsize.width) / 2 * scale}
        // NSLog("%@", " Boundsize min: \(minimum)")
        
        //  var maximum:CGFloat { return max(boundsize.height, boundsize.width) / 2 * scale}
        //  NSLog("%@", " Boundsize max: \(maximum)")
        
        let pointsData = dataSource?.setPoints(self) ?? ([CGPoint(x: 0, y:0)], 0.0, 0.0)
        
        var points = pointsData.0
        var maxY:CGFloat = CGFloat(pointsData.2)
        var maxX:CGFloat = CGFloat(pointsData.1)
        
        var xPosMin = centerX - (minimum / 2)
        var xPosMax = centerX + (minimum / 2)
        var yPosMin = centerY + (minimum / 2)
        var yPosMax = centerY - (minimum / 2)
        
        
        var xDiff = xPosMax - xPosMin
        var yDiff = yPosMin - yPosMax
        
     //   var maxY:CGFloat = 0.0
     //   var maxX:CGFloat = 0.0
        
        
        
        // create Axis
        xAxis.moveToPoint(CGPoint(x: xPosMin , y: yPosMin))
        
        xAxis.addLineToPoint(CGPoint(x: xPosMax, y: yPosMin))
        
        yAxis.moveToPoint(CGPoint(x: xPosMin , y: yPosMin))
        
        yAxis.addLineToPoint(CGPoint(x: xPosMin , y: yPosMax))
        
        xAxis.lineWidth = 3
        yAxis.lineWidth = 3
        xAxis.stroke()
        yAxis.stroke()
        
        
        
        let count =  points.count
        //  NSLog("%@", " Point count: \(points.count)")
        

        
        // createlines
        for i in 0..<count
        {
            
            var point1: CGPoint = points[i]!
            var pointCount:Int = points.count
            
            if (maxY == 0)
            {
                maxY = 1
            }
            var point = CGPoint( x: xPosMin + ( point1.x * xDiff / maxX  )  , y: yPosMin - (point1.y * yDiff / maxY  ))
            
            NSLog("%@", " Point: \(point)")
            
            
            if i == 0{
                path.moveToPoint(point)
            }
            else
            {
                path.addLineToPoint(point)
            }
            
            
        }
        
    
        
        // Draws line and set Color
        
        UIColor.greenColor().setFill()
        UIColor.greenColor().setStroke()
        
        path.lineWidth = 1
        path.stroke()
        
        
        
    }
    
    
}
