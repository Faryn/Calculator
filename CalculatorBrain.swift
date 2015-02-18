//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Paul Pfeiffer on 01/02/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {
        case Operand(Double)
        case Constant(String, Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let variable):
                    return "\(variable)"
                case .Constant(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private var variableValues = [String: Double]()
    
    func setVar(s: String, v: Double) -> Double? {
        variableValues[s] = v
        return evaluate()
    }

    
    
    init() {
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("ᴨ", M_PI))
    }
    
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let variable):
                return (variableValues[variable]?, remainingOps)
            case .Constant(_, let value):
                return (value, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let name, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        println("\(operand1) \(name) \(operand2)")
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    var description: String? {
        get {
            var result = String?()
            var remainder = [Op]()
            (result, remainder) = description(opStack)
            while !remainder.isEmpty
            {
                let expression = description(remainder)
                if let expDescription = expression.result
                {
                    result = "\(expDescription), \(result!)"
                    remainder = expression.remainingOps
                }
            }
            return result
        }
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Variable(let variable):
                return (variable, remainingOps)
            case .Constant(let constant, _):
                return (constant, remainingOps)
            case .UnaryOperation(let operation, _):
                let operandDescription = description(remainingOps)
                if let operand = operandDescription.result {
                    return (("\(operation)(\(operand))"), operandDescription.remainingOps)
                }
            case .BinaryOperation(let operation, _):
                let op1Description = description(remainingOps)
                if let operand1 = op1Description.result {
                    let op2Description = description (op1Description.remainingOps)
                    if let operand2 = op2Description.result {
                        return (("\(operand2)\(operation)\(operand1)"), op2Description.remainingOps)
                    }
                    else {
                        return (("?\(operation)\(operand1)"), op2Description.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }

    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func removeLastFromStack () -> Double? {
        if !opStack.isEmpty {
            opStack.removeLast()
            return evaluate()
        }
        return nil
    }
    
    func resetVars() {
        variableValues.removeAll(keepCapacity: false)
    }

    func reset() {
        opStack.removeAll(keepCapacity: false)
        resetVars()
    }
}