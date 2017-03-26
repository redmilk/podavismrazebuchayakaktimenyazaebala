//
//  DataSource.swift
//  FightersTrivia
//
//  Created by Artem on 3/14/17.
//  Copyright © 2017 apiqa. All rights reserved.
//

import Foundation

class DataSource : NSObject {
    
    
    var questions: [TheQuestion] = {
        let questions: [TheQuestion] = [TheQuestion(UIImage(named: "cars")!, "Cars"), TheQuestion(UIImage(named: "findingnemo")!, "Finding Nemo"), TheQuestion(UIImage(named: "lionking")!, "Lion King"), TheQuestion(UIImage(named: "pinoccio")!, "Pinoccio"), TheQuestion(UIImage(named: "duckstory")!, "Duck Story"), TheQuestion(UIImage(named: "toystory")!, "Toystory"), TheQuestion(UIImage(named: "lightsindarkness")!, "Lights in Darkness"),]
        return questions
    }()
    
}
