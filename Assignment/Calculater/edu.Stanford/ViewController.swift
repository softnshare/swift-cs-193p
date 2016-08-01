//
//  ViewController.swift
//  edu.stanford
//
//  Created by yu on 2016/7/12.
//  Copyright © 2016年 eduStandford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userisInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userisInTheMiddleOfTyping {
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userisInTheMiddleOfTyping = true
    }
    
    private var dotTyped = false
    
    @IBAction func decimalEntered(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if dotTyped == false {
            if userisInTheMiddleOfTyping {
                if (display.text!.rangeOfString(".") == nil) {
                    display.text = display.text!.stringByAppendingString(digit)
                }
            } else {
                display.text! = "0" + digit
            }
        }
        dotTyped = true
    }
    
    private var displayValue : Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    //free initializer/infer the brain as CalculatorBrain
    
    //呼叫calculator model
    @IBAction private func performAction(sender: UIButton) {
        if userisInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            dotTyped = false
            userisInTheMiddleOfTyping = false
        }
        if let methematicalSymbol = sender.currentTitle {
            brain.performOperation(methematicalSymbol)
        }
        displayValue = brain.result
    }
    
    @IBAction private func pressC(sender: AnyObject) {
        //為何要用AnyObject ?
        userisInTheMiddleOfTyping = false
        dotTyped = false
        brain.clean()
        displayValue = brain.result
        display.text = "0"
    }
    
    var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restroe() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
}

