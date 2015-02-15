//
//  ViewController.swift
//  Calculator
//
//  Created by Paul Pfeiffer on 29/01/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var userIsInTheMiddleOfTypingANumber : Bool = false
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    @IBAction func reset() {
        brain.reset()
        history.text = "0"
        updateDescription()
    }
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." && display.text!.rangeOfString(digit) != nil { return }
        if userIsInTheMiddleOfTypingANumber {
        display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
            updateDescription()
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue =  brain.pushOperand(displayValue!)
        history.text = brain.description
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
                userIsInTheMiddleOfTypingANumber = false
            } else
            {
               display.text = " "
            }
        }
    }
    
    func updateDescription() {
        if let newValue = brain.description
        {
            history.text = "\(brain.description!)="
        }
        else {
            history.text = " "
        }
    }

}

