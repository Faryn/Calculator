//
//  GraphView.swift
//  Calculator
//
//  Created by Paul Pfeiffer on 22/02/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    var function = ""
    var axes: AxesDrawer = AxesDrawer()
    
    
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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        axes.contentScaleFactor = self.contentScaleFactor
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "moveGraph:"))
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "changeScale:"))
        var doubleTap = UITapGestureRecognizer(target:self, action: "reset:")
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
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
        origin = origin ?? convertPoint(center, fromView: superview)
        axes.drawAxesInRect(bounds.integerRect, origin: origin!, pointsPerUnit: scale)
    }
}
