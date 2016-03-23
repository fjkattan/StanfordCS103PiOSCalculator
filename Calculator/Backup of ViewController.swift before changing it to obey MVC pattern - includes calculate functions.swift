//
//  ViewController.swift
//  Calculator
//
//  Created by FranciscoKattan2 on 3/8/16.
//  Copyright © 2016 FranciscoKattan2. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton)  {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
     }

   
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 } // the last argument to a function can be passed inside the brackets, not in the parens
        case "÷": performOperation { $1 / $0 } // we're passing the logic of the function rather than the function name
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation1  { sqrt ($0) }
        case "CHS": performOperation1 { -1 * $0 }
            
//            case "×": performOperation (multiply)  // tese case statments not needed as are able to pass the logic of the function rather than the function name, as above. Cool!
//            case "÷": performOperation(divide)
//            case "+": performOperation(add)
//            case "−": performOperation(subtract)

        default: break
        }
    }
    func performOperation (operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation1 (operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
    

// these function definitions (below) are not used because were able to pass the actual function logic to "performOperation" directly as an argument from the case statement.  Rather than pass the function name, we're passing the actual logic.  Types are infered because the Swift compiler knows that the function "performOpertion" takes two Doubles and returns a Double.
//    func multiply (op1: Double, op2: Double) -> Double {
//        return op1 * op2
//    }
//  
//    func divide (op1: Double, op2: Double) -> Double {
//        return op2 / op1
//    }
//    
//    func add (op1: Double, op2: Double) -> Double {
//        return op1 + op2
//    }
//    
//    func subtract (op1: Double, op2: Double) -> Double {
//        return op2 - op1
//    }
    

    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}