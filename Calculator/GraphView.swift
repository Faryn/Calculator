//
//  GraphView.swift
//  Calculator
//
//  Created by Paul Pfeiffer on 22/02/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit


protocol GraphViewDataSource : class {
    func getYForX (x: Double) -> Double?
}

@IBDesignable
class GraphView: UIView {
    
    var function = ""
    var axes: AxesDrawer = AxesDrawer()
    
    weak var dataSource: GraphViewDataSource?
    
    var origin: CGPoint? = nil {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale : CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }

    }

    func changeScale(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let newScale = gesture.scale
            scale *= newScale
            gesture.scale = 1
        default: break
        }
    }
    
    func reset(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            origin = nil
            scale = 1
        default:break
        }
    }
    
    func moveGraph(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            origin?.x += gesture.translationInView(self).x
            origin?.y += gesture.translationInView(self).y
            gesture.setTranslation(CGPointZero, inView: self)
        default:break
        }
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        //UIColor.blueColor().setFill()
        UIColor.blueColor().setStroke()
        path.lineWidth = 1
        origin = origin ?? convertPoint(center, fromView: superview)
        axes.drawAxesInRect(bounds.integerRect, origin: origin!, pointsPerUnit: scale)
        path.moveToPoint(CGPoint(x: bounds.minX, y: origin!.y))
        for pixel in Int(bounds.minX)...Int(bounds.maxX) {
            var actX = Double(pixel-Int(origin!.x))
            actX = actX /  Double(self.scale)
            if let absY = dataSource!.getYForX(actX) {
                var actY = origin!.y - (CGFloat(absY) * scale)
                path.addLineToPoint(CGPoint(x: CGFloat(pixel), y: actY))
            }
            else {
                path.moveToPoint(CGPoint(x: CGFloat(pixel), y: origin!.y))
            }
        }
        path.stroke()
    }
}
