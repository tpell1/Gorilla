//
//  PhysicsObject.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsBody {
    var min : CGPoint
    var max : CGPoint
    var velocity : CGVector
    var restitution : CGFloat
    var mass : CGFloat
    var force : CGVector = CGVector(dx: 0, dy: 0)
    
    init(min : CGPoint, max : CGPoint, mass : CGFloat) {
        self.min = min
        self.max = max
        self.mass = mass
        velocity = CGVector(dx: 0, dy: 0)
        restitution = 0.4
    }
}

class PhysicsObject {
    var index : Int
    private var node : SKNode?
    var physicsBody : PhysicsBody
    
    init(withNode node: SKNode) {
        index = 0
        self.node = node
        let boundingBox = node.calculateAccumulatedFrame()
        let min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        let max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        
        physicsBody = PhysicsBody(min: min, max: max, mass: 1)
    }
    
    func setIndex(index i : Int) {
        index = i
    }
    
    func getPosition() -> CGPoint {
        return node?.position ?? CGPoint(x: 0, y: 0)
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        node?.position = CGPoint(x: x, y: y)
    }
    
    func applyImpulse(dx: CGFloat, dy : CGFloat) {
        physicsBody.velocity.dx += dx/physicsBody.mass
        physicsBody.velocity.dy += dy/physicsBody.mass
    }
    
    func applyForce(dx: CGFloat, dy: CGFloat) {
        physicsBody.force.dx += dx
        physicsBody.force.dy += dy
    }
}
