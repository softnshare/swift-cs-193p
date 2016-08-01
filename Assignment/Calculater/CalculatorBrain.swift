//
//  CalculatorBrain.swift
//  Calculater
//
//  Created by 陳瑀芋 on 2016/7/20.
//  Copyright © 2016年 eduStandford. All rights reserved.
//

import Foundation
//core
//building model

class CalculatorBrain {
    
 //func mutiply (op1: Double, op2: Double) -> Double {
 //return op1 * op2 }
    
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String,Operation> = [
    "π": Operation.Constant(M_PI),
    "e": Operation.Constant(M_E),
    "√": Operation.UnaryOperation(sqrt),
    "cos": Operation.UnaryOperation(cos),
    "±": Operation.UnaryOperation({ -$0 }),
    "x²":Operation.UnaryOperation({pow( $0 , 2 )}),
    "1/x":Operation.UnaryOperation({pow( $0 , -1 )}),
    "ln":Operation.UnaryOperation(log),
    "×": Operation.BinaryOperation({ $0 * $1 }),
    //closure: 只要把func的東西,add the curly base starts the argument, put "in" after the arguments/swift can infer binaryOperation 所以可省略
    "÷": Operation.BinaryOperation({ $0 / $1 }),
    "−": Operation.BinaryOperation({ $0 - $1 }),
    "+": Operation.BinaryOperation({ $0 + $1 }),
    "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        //a function that takes a double and returns a double
        case BinaryOperation((Double,Double) -> Double)
        case Equals
        
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associateValue):
                accumulator = associateValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    //why made optional? ->只有在輸入x等binary字元時才會呼叫,不然用不到
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction:(Double,Double) -> Double
        var firstOperand: Double
        //arguments are its vars
    }
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList {
        get{
            return internalProgram
            //return internal to public
            //array是value type 所以傳遞時是get copied
        }
        set{
            clean()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operations = op as? String {
                        performOperation(operations)
                    }
                }
            }
        }
    }
    
    //只打get可以讓檔案成為read-only的形式
    var result: Double {
        get {
            return accumulator
        }
    }
    
    //這裡要用public 在ViewController才叫得到
    func clean() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
}



