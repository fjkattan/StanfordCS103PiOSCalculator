//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by FranciscoKattan2 on 3/13/16.
//  Copyright © 2016 FranciscoKattan2. All rights reserved.
//

// This is the implementation of the "Model" in the MVC pattern

import Foundation

class CalculatorBrain
{
    private enum Op : CustomStringConvertible {      // enum is like a class, but without inheritance. Can have functions and properties, but only computed properties, not stored properties.  use "enum" instead of "class".  Enums are great for things are are sometimes one thing (like an operand in our case) and sometimes soemthing else (like an operator)
        
        // : CustomStringConvertible is a "protocol" and requires the computed property called "description" -- used to be called "Printable" in earlier versions of Swift
        
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {  // teaching the enum Op how to convert itself into a string with a computed instance variable called "description" -- which is readonly because it does not have a set, only a get
            
            get {
                switch self {
                case .Operand (let operand): return "\(operand)"
                case .UnaryOperation (let symbol, _): return symbol
                case .BinaryOperation (let symbol, _): return symbol
                }
            }
        }
        
    }

    
    private var opStack = [Op]()  // this syntax is alternative to (and idetical to): var opStack = Array <op>() (array of Type Op).
    
    private var knownOps = [String:Op]() // This is a "Dictionary" a special type in Swift that holds key value pairs, in this case [String,Op] where a string is the type operation (for example "+") and the Op is the actual operation logic (or function) to execute that operation.  Alternative syntax for this is:  var knownOps = Dictionary<string, Op>()
    
    // the "()" at the end of [Op]() or "[String:Op]()" is there to call an initializer for that array or Disctionary.   The following init() {} is an example of an initializer.   Whenever someone (outside of the class) writes "let brain = CalculatorBrain()" this will call the initialized inside of the CalculatorBrain class.  If there are mulitple initializers, it will match the one with the same number of arguments (no arguments in this case)
    
    init() {
        
        func learnOp (op: Op) {
            knownOps[op.description] = op
            }
        
        learnOp(Op.BinaryOperation("x", *))
        learnOp(Op.BinaryOperation("÷", {$1 / $0}))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-", {$1 - $0}))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("CHS", {-1 * $0}))
        learnOp(Op.UnaryOperation("SIN", sin))
        learnOp(Op.UnaryOperation("COS", cos))
        
        
    }
        
 
// the following is how we had done it first.
//        knownOps ["×"] = Op.BinaryOperation("×", *) // in swift "*" is just a function that takes 2 Doubles and returns a Double. Except it's specified to be "in fixed" - between the two arguments -- rather than with the arguments in parenthesis
//        knownOps ["÷"] = Op.BinaryOperation("÷") {$1 / $0} // can't do the same for - and / because we have the arguments in the wrong order in the stack
//        knownOps ["+"] = Op.BinaryOperation("+", +)
//        knownOps ["−"] = Op.BinaryOperation("−") {$1 - $0}
//        knownOps ["√"] = Op.UnaryOperation("√", sqrt)
//        knownOps ["chs"] = Op.UnaryOperation("chs") {-1 * $0}
        
   
    
    private func clear() {
        opStack = [Op]()
        return
    }
    
    func pushOperand (operand: Double) -> Double? {
        opStack.append (Op.Operand (operand))
        return evaluate()
        
    }
    
    private func evaluate (ops: [Op]) -> (result: Double?, remainingOps:[Op]) // this is a "Tuple" type. simply put the elements of the Tuple in parenthesis like so:  (x, y, z, etc)
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {     // switch is how you pull things out of enums.  op is an enum
            case .Operand(let operand):  // this lets the operand value be assigned to a new constant called operand
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):  // in Swift "_" means I don't care about that elemen. In this case, don't care about the symbol in this case.. i just need the actual operation I need to execute
                let operandEvaluation = evaluate (remainingOps)
                if let operand = operandEvaluation.result {   // if let is required because operand is an optional Double, so must check it is not nil
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return(operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {   // this function must return an optional for error cases.  Say someone calls evaluate() and the stack does not have operands only an operator ...  in that case, it would return nil rather than a Double
        
        let (result, remainder) = evaluate (opStack)  // note that we can use a different name here "remanider" does not have to be "remainingOps"
        
        print ("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func performOperation(symbol: String) -> Double? {
        if symbol == "CLR" { clear() } else {
            if let operation = knownOps [symbol] {
                opStack.append(operation)
            }
        }
        // here we're looking up the correct operation in the knownOps Dictionary. operation is not an "op" type.  It is an optional Op.  Because I may be looking something up that is not in the dictionary, in that case it must return "nil".  ==> Dictionaries always return optionals!
        
        // "if let" is optional binding. the code inside the if brackets is executed only if operation is not nil -- meaning that the symbol sent to performOperation was a valid operation symbol such as + - / * etc.
        
        return evaluate()
    
    }

}

// in Swift, arguments of a function as passed by value if they are not classes.  Classes are always passed by reference.
// arrays and disctionaries are not classes in swift, they are structs
// in swift, structs are almost identical to classes -- with two expections:  1) structs don't have inheritance and structs are passed by value and classes are passed by reference
// Doubles and Ints are also structs, not classes.
// Structs have propertie and methods also

// all things you pass have an implicit "let" -- meaning they are read only (constants) unless you write "var" in the argument.  could have used, for example, "func evlaute (var ops: [Op]) -> (result: Double?, remainingOps: [Op])" above - but instead created a local variable that was not read only "remainingOps".




