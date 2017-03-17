//
//  TheQuestion.swift
//  FightersTrivia
//
//  Created by Artem on 2/24/17.
//  Copyright © 2017 apiqa. All rights reserved.
//

import Foundation

class TheQuestion: NSObject {
    
    var answers = [String]()
    var rightAnswerIndex: UInt
    
    init(_ answers: [String], _ rightAnswerIndex: UInt) {
        self.answers = answers
        self.rightAnswerIndex = rightAnswerIndex
    }
}
