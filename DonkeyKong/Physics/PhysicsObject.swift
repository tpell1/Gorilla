//
//  PhysicsObject.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

struct Entity {
    var min : CGPoint
    var max : CGPoint
}

class PhysicsObject {
    var index : Int
    private var node : SKNode?
    var physicsEntity : Entity
    
    init(withNode node: SKNode) {
        index = 0
        self.node = node
        let boundingBox = node.calculateAccumulatedFrame()
        let min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        let max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        
        physicsEntity = Entity(min: min, max: max)
    }
    
    func setIndex(index i : Int) {
        index = i
    }
    
    func getPosition() -> CGPoint {
        return node?.position ?? CGPoint(x: 0, y: 0)
    }
}
