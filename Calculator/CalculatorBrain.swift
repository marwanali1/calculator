//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Marwan Ali on 5/25/17.
//  Copyright © 2017 Marwan Ali. All rights reserved.
//

import Foundation

struct CalculatorBrain {
	
	/// Keeps tracks of number being displayed.
	private var accumulator: Double?
	private var pendingBinaryOperation: PendingBinaryOperation?
	
	var result: Double? {
		get {
			return accumulator
		}
	}
	
	/// Returns whether there is a pending binary operation.
	var resultIsPending: Bool {
		get {
			return pendingBinaryOperation == nil
		}
	}
	
	/// Maps each key in the calculator to the operation it performs.
	private var operations: Dictionary<String, Operation> = [
		"π" : Operation.constant(Double.pi),
		"e" : Operation.constant(M_E),
		"√" : Operation.unaryOperation(sqrt),
		"x^2" : Operation.unaryOperation({ pow($0, 2.0) }),
		"sin" : Operation.unaryOperation(sin),
		"cos" : Operation.unaryOperation(cos),
		"tan" : Operation.unaryOperation(tan),
		"±" : Operation.unaryOperation({ -$0 }),
		"×" : Operation.binaryOperation({ $0 * $1 }),
		"÷" : Operation.binaryOperation({ $0 / $1 }),
		"+" : Operation.binaryOperation({ $0 + $1 }),
		"−" : Operation.binaryOperation({ $0 - $1 }),
		"=" : Operation.equal
	]
	
	/// Four types of operations the calculator can do.
	private enum Operation {
		case constant(Double)
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double, Double) -> Double)
		case equal
	}
	
	private struct PendingBinaryOperation {
		let function: (Double, Double) -> Double
		let firstOperand: Double
		
		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
	
	private mutating func performPendingBinaryOperation() {
		if pendingBinaryOperation != nil && accumulator != nil {
			accumulator = pendingBinaryOperation!.perform(with: accumulator!)
			pendingBinaryOperation = nil
		}
		
		return
	}

	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
				case .constant(let value):
					accumulator = value
				case .unaryOperation(let function):
					if accumulator != nil {
						accumulator = function(accumulator!)
					}
				case .binaryOperation(let function):
					if accumulator != nil {
						pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
						accumulator = nil
					}
				case .equal:
					performPendingBinaryOperation()
			}
		}
		return
	}
	
	mutating func setOperand(_ operand: Double) {
		accumulator = operand
		return
	}
}
