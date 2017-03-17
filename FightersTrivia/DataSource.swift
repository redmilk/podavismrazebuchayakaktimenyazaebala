//
//  DataSource.swift
//  FightersTrivia
//
//  Created by Artem on 3/14/17.
//  Copyright © 2017 apiqa. All rights reserved.
//

import Foundation

class DataSource : NSObject {
    var images: [UIImage] = {
        let images: [UIImage] = [UIImage(named: "cars")!, UIImage(named: "findingnemo")!, UIImage(named: "duckstory")!, UIImage(named: "iceage")!, UIImage(named: "pinoccio")!, UIImage(named: "toystory")!, UIImage(named: "lionking")!]
        return images
    }()
}
