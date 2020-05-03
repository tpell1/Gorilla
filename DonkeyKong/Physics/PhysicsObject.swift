//
//  PhysicsObject.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    private static var physicsObjStat : [String:PhysicsObject?] = [:]
    var physicsObj : PhysicsObject? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return SKNode.physicsObjStat[tmpAddress] ?? nil
        }
        set(newObject) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            SKNode.physicsObjStat[tmpAddress] = newObject
        }
    }
}

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
    var node : SKNode
    var physicsBody : PhysicsBody
    private var previousPos : CGPoint
    
    convenience init(withNode node: SKNode) {
        self.init(withNode: node, mass: 1)
    }
    
    init(withNode node: SKNode, mass: CGFloat) {
        index = 0
        self.node = node
        let boundingBox = node.calculateAccumulatedFrame()
        let min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        let max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        previousPos = node.position
        physicsBody = PhysicsBody(min: min, max: max, mass: mass)
    }
    
    func setIndex(index i : Int) {
        index = i
    }
    
    func getPosition() -> CGPoint {
        return node.position
    }
    
    func updatePosition() {
        let boundingBox = node.calculateAccumulatedFrame()
        physicsBody.min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        physicsBody.max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        previousPos = node.position
        node.position = CGPoint(x: x, y: y)
        if (node is MarioSprite) {
            print(node.position)
        }
        let boundingBox = node.calculateAccumulatedFrame()
        physicsBody.min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        physicsBody.max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
    }
    
    func velocityIsZero() -> Bool {
        let dx = node.position.x - previousPos.x
        let dy = node.position.y - previousPos.y
        
        if (abs(dx) > 0.3 || abs(dy) > 0.3) {
            return true
        }
        return false
    }
    
    func applyImpulse(dx: CGFloat, dy : CGFloat) {
        physicsBody.velocity.dx += dx/physicsBody.mass
        physicsBody.velocity.dy += dy/physicsBody.mass
    }
    
    func applyForce(dx: CGFloat, dy: CGFloat) {
        physicsBody.force.dx += dx
        physicsBody.force.dy += dy
    }
    
    func integrateForces(timeInterval t : TimeInterval) {
        if (physicsBody.mass == -1) {
            return
        }
        if (node is MarioSprite) {
            print(physicsBody.force)
        }
        physicsBody.velocity.dx += (physicsBody.force.dx/physicsBody.mass)*CGFloat(t/2.0)
        physicsBody.velocity.dy += ((physicsBody.force.dy/physicsBody.mass) - PhysicsWorld.GRAVITY)*CGFloat(t/2.0)
    }
    
    func integrateVelocity(timeInterval t : TimeInterval) {
        let b = physicsBody
        if (b.mass == -1) {
            return
        }
        setPosition(x: getPosition().x + b.velocity.dx*CGFloat(t), y: getPosition().y + b.velocity.dy*CGFloat(t))
        integrateForces(timeInterval: t)
    }
}
