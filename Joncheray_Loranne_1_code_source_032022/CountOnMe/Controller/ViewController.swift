//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let calculator = Calculator()

    // Type of message alert
    func messageAlert(alert: CalculatorError) {
        var message: String
        switch alert {
        case .messageErrorOperand:
            message = "An operator is already set !"
        case .divided0:
            message = "We can't divide by 0"
        case .enterCorrectOperation:
            message = "Start a new calculation !"
        case .expressionNotCorrect:
            message = "Enter a correct expression !"
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
}

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberAndOperatorButtons: [UIButton]!

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Reset button for clean text
    @IBAction func tappedResetButton(_ sender: UIButton) {
        textView.text = calculator.reset()
    }

    // Add Number when tapped button
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberTapped = sender.title(for: .normal) else {
            return
        }
        textView.text = calculator.addNewNumber(numberTapped: numberTapped)
    }

    // Plus button, if it fail display message alert appropriate error
    @IBAction func tappedPlusButton(_ sender: UIButton) {
        do {
            let result = try calculator.addOperator(operand: .plus)
            textView.text = result
        } catch CalculatorError.messageErrorOperand {
            messageAlert(alert: .messageErrorOperand)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    // Minus button, if it fail display message alert appropriate error
    @IBAction func tappedMinusButton(_ sender: UIButton) {
        do {
            let result = try calculator.addOperator(operand: .minus)
            textView.text = result
        } catch CalculatorError.messageErrorOperand {
            messageAlert(alert: .messageErrorOperand)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    // Divide button, if it fail display message alert appropriate error
    @IBAction func tappedDivideButton(_ sender: UIButton) {
        do {
            let result = try calculator.addOperator(operand: .divide)
            textView.text = result
        } catch CalculatorError.messageErrorOperand {
            messageAlert(alert: .messageErrorOperand)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    //  Multiply button, if it fail display message alert appropriate error
    @IBAction func tappedMultiplyButton(_ sender: UIButton) {
        do {
            let result = try calculator.addOperator(operand: .multiply)
            textView.text = result
        } catch CalculatorError.messageErrorOperand {
            messageAlert(alert: .messageErrorOperand)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    // Equal button, if it fail display messages alert appropriate error and reset text
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        do {
            let result = try calculator.calculateResult()
            textView.text = result
        } catch CalculatorError.divided0 {
            messageAlert(alert: .divided0)
        } catch CalculatorError.expressionNotCorrect {
            messageAlert(alert: .expressionNotCorrect)
        } catch CalculatorError.enterCorrectOperation {
            messageAlert(alert: .enterCorrectOperation)
        } catch {
            print("Unexpected error: \(error).")
        }
        calculator.reset()
    }
}
