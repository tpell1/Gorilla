//
//  PhysicsObject.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsObject {
    var index : Int
    private var node : SKNode?
    
    init(withNode node: SKNode) {
        index = 0
        self.node = node
    }
    
    func setIndex(index i : Int) {
        index = i
    }
    
    func getPosition() -> CGPoint {
        return node.position
    }
}
