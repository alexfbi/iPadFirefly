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


var scale:CGFloat = 1.5

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
        
        
        let boundsize = self.bounds.size
        NSLog("%@", " Boundsize height: \(boundsize.height)")
        NSLog("%@", " Boundsize width: \(boundsize.width)")
        
        var centerGraph:CGPoint = convertPoint( center, fromView: superview)
      
        var centerX:CGFloat = centerGraph.x
        var centerY:CGFloat = centerGraph.y
        
        
        NSLog("%@", " Center graph: \(centerGraph)")
        
        
        var minimum:CGFloat { return min(boundsize.height, boundsize.width) / 2 * scale}
        NSLog("%@", " Boundsize min: \(minimum)")
        
      //  var maximum:CGFloat { return max(boundsize.height, boundsize.width) / 2 * scale}
      //  NSLog("%@", " Boundsize max: \(maximum)")
        
        let points = dataSource?.setPoints(self) ?? [CGPoint(x: 0, y: 0)]
        
      
        var xPosMin = centerX - (minimum / 2)
        var xPosMax = centerX + (minimum / 2)
        var yPosMin = centerY + (minimum / 2)
        var yPosMax = centerY - (minimum / 2)
        
    
        xAxis.moveToPoint(CGPoint(x: xPosMin , y: yPosMin))
        
        xAxis.addLineToPoint(CGPoint(x: xPosMax, y: yPosMin))
        
        yAxis.moveToPoint(CGPoint(x: xPosMin , y: yPosMin))
        
        yAxis.addLineToPoint(CGPoint(x: xPosMin , y: yPosMax))
        
        let count =  points.count
        
        if count > 0
            
        {
         
            NSLog("%@", " Point count: \(points.count)")
            
          
            
            var maxY:CGFloat = 0.0
            var maxX:CGFloat = 0.0
            
            for i in 0..<count
            {
               if ( maxY < points[i]!.y )
               {
                 maxY = points[i]!.y
                }
                
                if ( maxX < points[i]!.x )
                {
                    maxX = points[i]!.x
                }
                
            }
            
           var xDiff = xPosMax - xPosMin
           var yDiff = yPosMin - yPosMax
            
            var point1: CGPoint = points[0]!
            
           var point = CGPoint( x: xPosMin + ( point1.x * xDiff / maxX   )  , y: yPosMin - (point1.y * yDiff / maxY  ))
            
            path.moveToPoint(point)
            
            for i in 1..<count
            {
                
                
                var point1: CGPoint = points[i]!
                
                var point = CGPoint( x: xPosMin + ( point1.x * xDiff / maxX   )  , y: yPosMin - (point1.y * yDiff / maxY  ))
                
                NSLog("%@", " Point: \(point)")
                
                path.addLineToPoint(point)
                
            }

            
        }
        

        
        //UIColor.greenColor().setFill()
        //UIColor.greenColor().setStroke()
        
        path.lineWidth = 1
        
        xAxis.lineWidth = 3
        yAxis.lineWidth = 3
        // path.fill()
        path.stroke()
        xAxis.stroke()
        yAxis.stroke()
        
    }
    
    
}
