//
//  Controller.swift
//  CountOnMe
//
//  Created by Loranne Joncheray on 05/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//
import Foundation
import UIKit

// Enum of different operands
enum Operand: String, CaseIterable {
    case plus = "+"
    case minus = "-"
    case divide = "/"
    case multiply = "x"

    var value: String {
        return " \(rawValue) "
    }
}

class Calculator {

    var numbers = ""

    private var elements: [String] {
        return numbers.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables
    private var expressionIsCorrect: Bool {
        return elements.last != Operand.plus.rawValue
        && elements.last != Operand.minus.rawValue
        && elements.last != Operand.divide.rawValue
        && elements.last != Operand.multiply.rawValue
    }

    // Checks if expression have enough elements
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    // Cheks can add operator
    private var canAddOperator: Bool {
        return elements.last != Operand.plus.rawValue
        && elements.last != Operand.minus.rawValue
        && elements.last != Operand.divide.rawValue
        && elements.last != Operand.multiply.rawValue
    }

    // Checks if expression have result
    var expressionHaveResult: Bool {
        return numbers.firstIndex(of: "=") != nil
    }

    // Add operator
    func addOperator(operand: Operand) throws -> String {
        if canAddOperator {
            numbers.append(operand.value)
        } else {
            throw CalculatorError.messageErrorOperand
        }
        return numbers
    }

    // Add new number
    func addNewNumber(numberTapped: String) -> String {
        if expressionHaveResult {
            numbers = numberTapped
        } else {
            numbers.append(numberTapped)
        }
        return numbers
    }

    // Reset action/calcul
    @discardableResult func reset() -> String {
        numbers = ""
        return numbers
    }

    // func for calcul if negative numbers in first index
    private func negativeNumbers(numbersSelected: [String]) throws -> [String] {
        var text = numbersSelected
        let index = 0

        // Condition for function "negativeNumbers" is minimum 4 elements and
        if text.count >= 4,
           let minusOperand = Operand(rawValue: text[index]),
           minusOperand == .minus,
           let operand = Operand(rawValue: text[index + 2]) {

            // Define the index for each element for the calculation
            guard let temporaryLeft = Double(text[index + 1]) else { return ["error"] }
            guard let right = Double(text[index + 3]) else { return ["error"] }

            let left = -temporaryLeft
            var result: Double = 0

            // Switch of differents operands and calcul
            switch operand {
            case .plus: result = Double(left + right)
            case .minus: result = Double(left - right)
            case .multiply:
                result = Double(left * right)
            case .divide:
                if right != 0 {
                    result = Double(left / right)
                } else {
                    throw CalculatorError.divided0
                }
            }
            // Remove necessary indexes to keep the one we will use in "calculateResult"
            text[index] = String(result)
            text.remove(at: index + 3)
            text.remove(at: index + 2)
            text.remove(at: index + 1 )
        }
        return text
    }

    // Check priority operand
    private func priorityCalcul(numbersSelected: [String]) throws -> [String] {
        var text = numbersSelected

        // Condition si calcul contain multiply or divide
        while text.contains(Operand.multiply.rawValue) || text.contains(Operand.divide.rawValue) {
            if let indx = text.firstIndex(where: { $0 == Operand.multiply.rawValue ||  $0 == Operand.divide.rawValue}) {

                let operand = Operand(rawValue: text[indx])

                // Define the index for each element for the calculation
                guard let left = Double(text[indx - 1]) else { return ["error"] }
                guard let right = Double(text[indx + 1]) else { return ["error"] }

                var result: Double = 0

                // Switch of differents operands and calcul
                switch operand {
                case .multiply: result = Double(left * right)
                case .divide:
                    if right != 0 {
                        result = Double(left / right)
                    } else {
                        throw CalculatorError.divided0
                    }
                default: break
                }
                // Remove necessary indexes to keep the one we will use in "calculateResult"
                text[indx-1] = String(result)
                text.remove(at: indx + 1)
                text.remove(at: indx)
            }
        }
        return text
    }

    // Calcul result
    func calculateResult() throws -> String {

        var operationsToReduce = try priorityCalcul(numbersSelected: elements)

        // 2 conditions for the calculation to continue else an error is displayed
        guard expressionIsCorrect else {
            operationsToReduce.removeAll()
            throw CalculatorError.expressionNotCorrect
        }

        guard expressionHaveEnoughElement else {
            operationsToReduce.removeAll()
            throw CalculatorError.enterCorrectOperation
        }

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {

            let index = 0
            var result: Double = 0

            // Define the index for each element for the calculation 
            if let operand = Operand(rawValue: operationsToReduce[index + 1]) {
                guard let left = Double(operationsToReduce[index]) else { return "error" }
                guard let right = Double(operationsToReduce[index + 2]) else { return "error" }

                // Switch of differents operands and calcul
                switch operand {
                case .plus: result = Double(left + right)
                case .minus: result = Double(left - right)

                default: break
                }
            } else { // If negative numbers in first index
                operationsToReduce =  try negativeNumbers(numbersSelected: elements)
                result = Double(operationsToReduce[index])!
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        // Convert array string result in string and return result
        let resultString = operationsToReduce.joined(separator: " ")
        return resultString
    }
}
