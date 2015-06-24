//
//  PlotView.swift
//  AFC1
//
//  Created by ak on 10.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit

protocol PlotMultiViewDataSource: class{
    func setPoints( sender: PlotMultiView) -> ([CGPoint],[CGPoint], [CGPoint], Double, Double)
    
}

//Scale to MAX fullscreen
// MAX = 2


class PlotMultiView: UIView {
    
    
    
    weak var dataSource: PlotMultiViewDataSource?
    
    
    
    override func drawRect(rect: CGRect) {
        
        var pathList:[UIBezierPath] = [UIBezierPath()]
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
        
        let pointsData = dataSource?.setPoints(self) ?? ([CGPoint(x: 0, y:0)],[CGPoint(x: 0, y:0)],[CGPoint(x: 0, y:0)], 0.0, 0.0)
        
       
        
        var pointsDataMulti:[Int :[CGPoint]] = [0 : pointsData.0, 1 : pointsData.1, 2: pointsData.2]
        
        
      //  var points = pointsData.0
        
        var maxY:CGFloat = CGFloat(pointsData.4)
        var maxX:CGFloat = CGFloat(pointsData.3)
        
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
        
        
        
   //     let count =  points.count
        //  NSLog("%@", " Point count: \(points.count)")
        
        for j in 0...2
        {
            
        var points: [CGPoint] = pointsDataMulti[j]!

         
        // createlines
        for i in 0..<points.count
        {
            var point1 = points[i]
            
            var pointCount:Int = points.count
            
            if (maxY == 0)
            {
                maxY = 1
            }
            if (maxX == 0){
                maxX = 1
            }
            var point = CGPoint( x: xPosMin + ( point1.x * xDiff / maxX  )  , y: yPosMin - (point1.y * yDiff /  maxY    ))
            
            NSLog("%@", " Point: \(point)")
            
            
            if i == 0{
                path.moveToPoint(point)
            }
            else
            {
                path.addLineToPoint(point)
            }
            
            
        }
        pathList.append(path)
        
        
        // Draws line
            
            
                UIColor.redColor().setStroke()
                
       
        
        pathList[j].lineWidth = 1
        pathList[j].stroke()
        
        
        }
    }
    
    
}
