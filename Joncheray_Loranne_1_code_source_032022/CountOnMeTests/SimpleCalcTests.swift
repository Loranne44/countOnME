//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var calculator: Calculator!

    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }

    // Test plus
    func testGivenTextCalculatorIsVoid_WhenAddingOneFromThree_ThenResultIsFour() throws {
        _ = calculator.addNewNumber(numberTapped: "1")
        _ = try calculator.addOperator(operand: .plus)
        let text = calculator.addNewNumber(numberTapped: "3")
        XCTAssertEqual(text, "1 + 3")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "4.0")
    }

    // Test minus
    func testGivenTextCalculatorIsVoid_WhenSubtractFifteenFromThree_ThenResultIsTwelve() throws {
        _ = calculator.addNewNumber(numberTapped: "15")
        _ = try calculator.addOperator(operand: .minus)
        let text = calculator.addNewNumber(numberTapped: "3")
        XCTAssertEqual(text, "15 - 3")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "12.0")
    }

    // Test divide
    func testGivenTextCalculatorIsVoid_WhenDivideThirtyFromThree_ThenResultIsTen() throws {
        _ = calculator.addNewNumber(numberTapped: "30")
        _ = try calculator.addOperator(operand: .divide)
        let text = calculator.addNewNumber(numberTapped: "3")
        XCTAssertEqual(text, "30 / 3")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "10.0")
    }

    // Test multiply
    func testGivenTextCalculatorIsVoid_WhenMultiplyFortyFromTwo_ThenResultIsEighty() throws {
        _ = calculator.addNewNumber(numberTapped: "40")
        _ = try calculator.addOperator(operand: .multiply)
        let text = calculator.addNewNumber(numberTapped: "2")
        XCTAssertEqual(text, "40 x 2")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "80.0")
    }

    // Test priority calcul with multiply
    func testGivenMultiplyAndPlus_WhenCalculateOperation_ThenMultiplyCalculatedFirst() throws {
        _ = calculator.addNewNumber(numberTapped: "3")
        _ = try calculator.addOperator(operand: .plus)
        _ = calculator.addNewNumber(numberTapped: "5")
        _ = try calculator.addOperator(operand: .multiply)
        let text = calculator.addNewNumber(numberTapped: "2")
        XCTAssertEqual(text, "3 + 5 x 2")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "13.0")
    }

    // Test priority calcul with divided
    func testGivenDividedAndPlus_WhenCalculateOperation_ThenDividedCalculatedFirst() throws {
        _ = calculator.addNewNumber(numberTapped: "4")
        _ = try calculator.addOperator(operand: .plus)
        _ = calculator.addNewNumber(numberTapped: "6")
        _ = try calculator.addOperator(operand: .divide)
        let text = calculator.addNewNumber(numberTapped: "2")
        XCTAssertEqual(text, "4 + 6 / 2")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "7.0")
    }

    // Test start with a negative numbers then multiply
    func testGivenCalculationStartNegativeNumberAndMultiply_WhenCalculateOperation_ThenNegativeNbrCalculated() throws {
        _ = try calculator.addOperator(operand: .minus)
        _ = calculator.addNewNumber(numberTapped: "3")
        _ = try calculator.addOperator(operand: .multiply)
        let text = calculator.addNewNumber(numberTapped: "5")
        XCTAssertEqual(text, " - 3 x 5")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "-15.0")
    }

    // Test start with a negative numbers then add
    func testGivenCalculationStartNegativeNumberAndPlus_WhenCalculateOperation_ThenNegativeNumberCalculated() throws {
        _ = try calculator.addOperator(operand: .minus)
        _ = calculator.addNewNumber(numberTapped: "3")
        _ = try calculator.addOperator(operand: .plus)
        let text = calculator.addNewNumber(numberTapped: "5")
        XCTAssertEqual(text, " - 3 + 5")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "2.0")
    }

    // Test start with a negative numbers then divide
    func testGivenCalculationStartNegativeNumberAndDivide_WhenCalculateOperation_ThenNegativeNumberCalculated() throws {
        _ = try calculator.addOperator(operand: .minus)
        _ = calculator.addNewNumber(numberTapped: "6")
        _ = try calculator.addOperator(operand: .divide)
        let text = calculator.addNewNumber(numberTapped: "2")
        XCTAssertEqual(text, " - 6 / 2")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "-3.0")
    }

    // test display negative numbers
    func testShouldResultNegative_WhenDisplayNegativeNumber() throws {
        _ = calculator.addNewNumber(numberTapped: "3")
        _ = try calculator.addOperator(operand: .minus)
        let text = calculator.addNewNumber(numberTapped: "9")
        XCTAssertEqual(text, "3 - 9")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "-6.0")
    }

    // Test priority calcul with divided and multiply
    func testShouldDividedAndMultiplyPrioritary_WhenDifferentOperator() throws {
        _ = calculator.addNewNumber(numberTapped: "4")
        _ = try calculator.addOperator(operand: .plus)
        _ = calculator.addNewNumber(numberTapped: "6")
        _ = try calculator.addOperator(operand: .multiply)
        _ = calculator.addNewNumber(numberTapped: "2")
        _ = try calculator.addOperator(operand: .divide)
        let text = calculator.addNewNumber(numberTapped: "2")
        XCTAssertEqual(text, "4 + 6 x 2 / 2")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "10.0")
    }

    // Division with a float result
    func testShouldResultAFloat_WhenDividedByGreaterNumbers() throws {
        _ = calculator.addNewNumber(numberTapped: "4")
        _ = try calculator.addOperator(operand: .divide)
        let text = calculator.addNewNumber(numberTapped: "6")
        XCTAssertEqual(text, "4 / 6")
        let result = try calculator.calculateResult()
        XCTAssertEqual(result, "0.6666666666666666")
    }

    // Test have enough element
    func testGivenTextCalculatorIsVoid_WhenTappedFortyFourMinusTen_ThenHaveEnoughtElement() throws {
        _ = calculator.addNewNumber(numberTapped: "44")
        _ = try calculator.addOperator(operand: .minus)
        let text = calculator.addNewNumber(numberTapped: "10")
        XCTAssertEqual(text, "44 - 10")
        XCTAssertTrue(calculator.expressionHaveEnoughElement)
    }

    // Test reset button
    func testGivenTextCalculatorIsVoid_WhenClearTextCalculator_WhenTextCalculatorIsVoid() throws {
        _ = calculator.addNewNumber(numberTapped: "40")
        _ = try calculator.addOperator(operand: .multiply)
        let text = calculator.addNewNumber(numberTapped: "2")
        XCTAssertEqual(text, "40 x 2")
        _ = try calculator.calculateResult()
        calculator.reset()
        XCTAssertEqual(calculator.numbers, "")
    }

    // ---- Test Message Error ---

     // Test divided by 0
     func testShouldErrorWhenDividedByZero() throws {
         _ = calculator.addNewNumber(numberTapped: "1")
         _ = try calculator.addOperator(operand: .divide)
         let text = calculator.addNewNumber(numberTapped: "0")
         XCTAssertEqual(text, "1 / 0")
         XCTAssertThrowsError(try calculator.calculateResult()) { error in
             XCTAssertEqual(error as? CountOnMe.CalculatorError, CountOnMe.CalculatorError.divided0)
         }
     }

    // Test messageErrorOperand
    func testGivenTextCalculatorIsVoid_WhenTappedOnePlusMinus_ThenReturnMessageErrorOperand() throws {
        _ = calculator.addNewNumber(numberTapped: "1")
        _ = try calculator.addOperator(operand: .plus)
        XCTAssertThrowsError(try calculator.addOperator(operand: .minus)) { error in
            XCTAssertEqual(error as? CountOnMe.CalculatorError, CountOnMe.CalculatorError.messageErrorOperand)
        }
    }

    // Test expressionNotCorrect
    func testGivenTextCalculatorIsVoid_WhenTappedOnPlusThreeMinus_ThenReturnExpressionNotCorrect() throws {
        _ = calculator.addNewNumber(numberTapped: "1")
        _ = try calculator.addOperator(operand: .plus)
        _ = calculator.addNewNumber(numberTapped: "3")
        let text = try calculator.addOperator(operand: .minus)
        XCTAssertEqual(text, "1 + 3 - ")
        XCTAssertThrowsError(try calculator.calculateResult()) { error in
            XCTAssertEqual(error as? CountOnMe.CalculatorError, CountOnMe.CalculatorError.expressionNotCorrect)
        }
    }

    // Test enterCorrectOperation
    func testGivenTextCalculatorIsVoid_WhenTappedFortyFourMinus_ThenHaventEnoughtElement() throws {
        let text = calculator.addNewNumber(numberTapped: "44")
        XCTAssertEqual(text, "44")
        XCTAssertThrowsError(try calculator.calculateResult()) { error in
            XCTAssertEqual(error as? CountOnMe.CalculatorError, CountOnMe.CalculatorError.enterCorrectOperation)
        }
    }
}
