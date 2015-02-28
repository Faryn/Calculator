//
//  ViewController.swift
//  Calculator
//
//  Created by Paul Pfeiffer on 29/01/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    var userIsInTheMiddleOfTypingANumber : Bool = false
    
    private var brain = CalculatorBrain()
    private var brain2 = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    func getResultFromValue(value: Double) -> Double? {
        if let opStack = brain.program as? Array<String> {
            if opStack != brain2.program as Array<String> {
                brain2.program = opStack
            }
        }
        brain2.setVar("M", v: value)
        return brain2.evaluate()
    }
    
    @IBAction func reset() {
        brain.reset()
        displayValue = nil
    }
    @IBAction private func setM() {
        if let value = displayValue? {
            userIsInTheMiddleOfTypingANumber = false
            displayValue = brain.setVar("M", v: value)
        }
    }
    
    @IBAction private func pushVar(sender: UIButton) {
        enter()
        displayValue = brain.pushOperand(sender.currentTitle!)
    }
    
    @IBAction private func undo() {
        if userIsInTheMiddleOfTypingANumber {
            if !display.text!.isEmpty {
                display.text = dropLast(display.text!)
            }
        }
        else {
            displayValue = brain.removeLastFromStack()
        }
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
    
    @IBAction private func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
    }
    
    @IBAction private func enter() {
        if let value = displayValue {
            userIsInTheMiddleOfTypingANumber = false
            displayValue =  brain.pushOperand(displayValue!)
            println(brain.program)
        }
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
            updateDescription()
        }
    }
    
    private func updateDescription() {
        if let newValue = brain.description
        {
            history.text = "\(brain.description!)="
        }
        else {
            history.text = " "
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                if identifier == "graph"
                {
                    gvc.cvc = self
                }
            }
        }
    }

}

