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
    var axes = AxesDrawer()
    var scale : CGFloat = 2 {
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
    
   
    
    override func drawRect(rect: CGRect) {
        axes.drawAxesInRect(bounds.integerRect, origin: convertPoint(center, fromView: superview), pointsPerUnit: scale)
    }
    
    
    
}
