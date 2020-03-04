//
//  Entity.swift
//  DonkeyKong
//
//  Created by Travis Pell on 05/12/2019.
//  Copyright © 2019 Travis Pell. All rights reserved.
//

import Foundation

class Entity {
    var name = "Entity"
    var positionX = 0.0
    var positionY = 0.0
    var weight = 50
    var height = 120
    var health = 100
    
    init(nameNew: String, x: Double, y: Double) {
        self.name = nameNew
        self.positionX = x
        self.positionY = y
    }
    
    func jump(force : Double) {
        positionY +=  force
    }
    
    // To be called every 0.01s
    func calculateHeight() -> Double {
        positionY -= 0.01*9.8
        return positionY
    }
    
}
