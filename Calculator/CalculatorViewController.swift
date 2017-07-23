//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Marwan Ali on 5/24/17.
//  Copyright © 2017 Marwan Ali. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
	
	@IBOutlet weak var display: UILabel!
	
	@IBAction func touchDigit(_ sender: UIButton) {
		let digit = sender.currentTitle!
		if userIsTyping {
			let currentTextInDisplay = display.text!
			display.text = currentTextInDisplay + digit
			
		}
		else {
			display.text = digit
			userIsTyping = true
		}
		
		return
	}

	@IBAction func performOperation(_ sender: UIButton) {
		if sender.currentTitle == "C" {
			display.text = "0"
			return
		}
		
		if userIsTyping {
			brain.setOperand(displayValue)
			userIsTyping = false
		}
		
		if let mathSymbol = sender.currentTitle {
			brain.performOperation(mathSymbol)
		}
		
		if let result = brain.result {
			displayValue = result
		}
		
		return
	}

	private var userIsTyping = false
	private var brain = CalculatorBrain()

	var displayValue: Double {
		get {
			return Double(display.text!)!
		}
		set {
			display.text = String(newValue)
		}
	}
}
