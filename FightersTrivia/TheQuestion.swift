//
//  TheQuestion.swift
//  FightersTrivia
//
//  Created by Artem on 2/24/17.
//  Copyright © 2017 apiqa. All rights reserved.
//

import Foundation

class TheQuestion: NSObject {
    var questionLevel: Int
    var firstNumber: Int
    var secondNumber: Int
    var mathOperator: String
    var operationResult: Int
    var operationResultString: String
    
    override init() {
        questionLevel = 1
        firstNumber = 0
        secondNumber = 0
        mathOperator = "s"
        operationResult = 0
        operationResultString = "2"
    }
    
    
}
