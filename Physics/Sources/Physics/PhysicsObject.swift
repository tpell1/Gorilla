//
//  PhysicsObject.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

public extension SKNode {
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

/**
 Class representing the mathematical properties of the physics object
 */
public class PhysicsBody {
    internal var min : CGPoint
    internal var max : CGPoint
    public var velocity : CGVector
    public var restitution : CGFloat
    internal var mass : CGFloat
    internal var force : CGVector = CGVector(dx: 0, dy: 0)
    
    init(min : CGPoint, max : CGPoint, mass : CGFloat) {
        self.min = min
        self.max = max
        self.mass = mass
        velocity = CGVector(dx: 0, dy: 0)
        restitution = 0.4
    }
}

/**
 Class representing an object in the physics world
 */
public class PhysicsObject {
    public var index : Int /// The index of the object in the collection of `PhysicsObjects` in `PhysicsWorld`
    public var node : SKNode
    public var physicsBody : PhysicsBody
    private var previousPos : CGPoint
    
    public convenience init(withNode node: SKNode) {
        self.init(withNode: node, mass: 1)
    }
    
    public init(withNode node: SKNode, mass: CGFloat) {
        index = 0
        self.node = node
        let boundingBox = node.calculateAccumulatedFrame()
        let min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        let max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        previousPos = node.position
        physicsBody = PhysicsBody(min: min, max: max, mass: mass)
    }
    
    /**
     Set the index of the object in the `PhysicsWorld` collection of objects
     - parameters:
        - i : The index to set
     */
    func setIndex(index i : Int) {
        index = i
    }
    
    /**
     Get the position of the node
     - returns: `CGPoint`: The current location
     */
    func getPosition() -> CGPoint {
        return node.position
    }
    
    /**
     Updates the bounds of the physics object using the nodes position
     */
    func updatePosition() {
        let boundingBox = node.calculateAccumulatedFrame()
        physicsBody.min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        physicsBody.max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
    }
    
    /**
     Sets the position of the node
     - parameters:
        - x: The x coordinate
        - y: The y coordinate
     */
    public func setPosition(x: CGFloat, y: CGFloat) {
        previousPos = node.position
        node.position = CGPoint(x: x, y: y)
        let boundingBox = node.calculateAccumulatedFrame()
        physicsBody.min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        physicsBody.max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
    }
    
    /**
     Determines if the objects functional velocity is zero
     - returns: `Bool`
     */
    public func velocityIsZero() -> Bool {
        let dx = node.position.x - previousPos.x
        let dy = node.position.y - previousPos.y
        
        if (abs(dx) > 0.01 || abs(dy) > 0.01) {
            return true
        }
        return false
    }
    
    ///  whether a physics object's vertical velocity is functionally zero
    /// - returns: `Bool`
    public func verticalVelocityIsZero() -> Bool {
        let dy = node.position.y - previousPos.y
        if (abs(dy) > 0.01) {
            return false
        }
        return true
    }
    
    /**
     Apply an impulse to the PhysicsObject
     - parameters:
        - dx: the horizontal component of the impulse
        - dy: the vertical component of the impulse
     */
    public func applyImpulse(dx: CGFloat, dy : CGFloat) {
        physicsBody.velocity.dx += dx/physicsBody.mass
        physicsBody.velocity.dy += dy/physicsBody.mass
    }
    
    /**
     Apply a force to the PhysicsObject
     - parameters:
        - dx: The horizontal component of the force applied
        - dy: The vertical componenent of the force applied
     */
    public func applyForce(dx: CGFloat, dy: CGFloat) {
        physicsBody.force.dx += dx
        physicsBody.force.dy += dy
    }
    
    /**
     Integrate the forces applied to the object in this current simulation round.
     
     This converts forces into velocities, it also adds gravity
     - parameters:
        - t: The interval of time between the last round of simulation.
     */
    func integrateForces(timeInterval t : TimeInterval) {
        if (physicsBody.mass == -1) {
            return
        }

        physicsBody.velocity.dx += (physicsBody.force.dx/physicsBody.mass)*CGFloat(t)

        physicsBody.velocity.dy += ((physicsBody.force.dy/physicsBody.mass) - PhysicsWorld.GRAVITY)*CGFloat(t)
    }
    
    /**
     Integrate the objects current velocities to calculate where the objects next position should be.
     - parameters:
        - t: The interval of time between now and the last round of simulation.
     */
    func integrateVelocity(timeInterval t : TimeInterval) {
        let b = physicsBody
        if (b.mass == -1) {
            return
        }
        setPosition(x: getPosition().x + b.velocity.dx*CGFloat(t), y: getPosition().y+b.velocity.dy*CGFloat(t))
        integrateForces(timeInterval: t)
    }
}
