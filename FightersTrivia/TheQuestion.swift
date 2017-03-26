//
//  TheQuestion.swift
//  FightersTrivia
//
//  Created by Artem on 2/24/17.
//  Copyright © 2017 apiqa. All rights reserved.
//

import Foundation

class TheQuestion: NSObject {
    
    var image: UIImage!
    var rightAnswerAndTitle: String!
    
    init(_ image: UIImage, _ rightAnswerAndTitle: String) {
        self.image = image
        self.rightAnswerAndTitle = rightAnswerAndTitle
    }
}
