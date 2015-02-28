//
//  GraphViewController.swift
//  Calculator
//
//  Created by Paul Pfeiffer on 22/02/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource
{
    weak var cvc : CalculatorViewController? = nil
    
    @IBOutlet weak var graphView: GraphView! {
        didSet{
            graphView.dataSource = self
            graphView.axes.contentScaleFactor = graphView.contentScaleFactor
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "moveGraph:"))
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "changeScale:"))
            let doubleTap = UITapGestureRecognizer(target:graphView, action: "reset:")
            doubleTap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTap)
            }
    }
    
    func getYForX (x: Double) -> Double? {
        if let y = cvc?.getResultFromValue(x) {
            if y.isNaN { return nil }
            return y
        }
        return nil
    }


    
}
