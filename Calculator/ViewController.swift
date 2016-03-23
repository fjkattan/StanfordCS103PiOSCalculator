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
    
    var brain = CalculatorBrain () // this is the "green arrow" that goes from the controller to the model in the lecture slides.
    
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
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0  // lame, but Ok for now.  later in HW 2 make this nil or error message.  (Make diplayValue an optional
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
        displayValue = result
        } else {
            displayValue = 0    // for homework two, better to display "nil"or error message here.  For now, set display to 0 which is lame.  That will require making displayValue an optinal Double rather than just Double
        }
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