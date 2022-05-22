//
//  Alert.swift
//  CountOnMe
//
//  Created by Loranne Joncheray on 12/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

// Enum calculator error for display alert message 
enum CalculatorError: Error {
    case messageErrorOperand
    case divided0
    case enterCorrectOperation
    case expressionNotCorrect
}
