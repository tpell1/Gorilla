//
//  PhysicsObject.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Adds a PhysicsObject property to all SKNode instances
 */
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
 Class representing an object in the physics world
 */
public class PhysicsObject {
    public var index : Int /// The index of the object in the collection of `PhysicsObjects` in `PhysicsWorld`
    public var node : SKNode
    private var previousPos : CGPoint
    public var solveCollisions : Bool = true
    internal var min : CGPoint
    internal var max : CGPoint
    /**
     The speed that the object changes position
     */
    public var velocity : CGVector
    /**
     The coefficient of restitution. This determines how much an object will bounce
     
     Maximum value = 1, minimum value = 0
     */
    public var restitution : CGFloat
    internal var mass : CGFloat
    internal var force : CGVector = CGVector(dx: 0, dy: 0)
    
    
    // --------------- Constructors ----------------------------------------
    
    /**
     Constructor which initialises a PhysicsObject with a mass of 1.
     
     - parameters:
        - node: The node that the PhysicsObject should manipulate/use for calculations
     */
    public convenience init(withNode node: SKNode) {
        self.init(withNode: node, mass: 1)
    }
    
    /**
     Construct which initialises a PhysicsObject and calculates in bounding box.
     
     The bounding box is the way that the physics engine will determing whether two objects are colliding.
     
     - parameters:
        - node: The node that the PhysicsObject should manipulate/use for calculations
        - mass: The mass of the object
     */
    public init(withNode node: SKNode, mass: CGFloat) {
        index = 0
        self.node = node
        let boundingBox = node.calculateAccumulatedFrame()
        let min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        let max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        previousPos = node.position
        self.min = min
        self.max = max
        self.mass = mass
        velocity = CGVector(dx: 0, dy: 0)
        restitution = 1
    }
    
    // ----------------- Property Methods -----------------------------
    
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
        min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
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
        min = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        max = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
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
    
    // ------------------- Apply forces/change velocity -----------------
    
    /**
     Apply an impulse to the PhysicsObject
     - parameters:
        - dx: the horizontal component of the impulse
        - dy: the vertical component of the impulse
     */
    public func applyImpulse(dx: CGFloat, dy : CGFloat) {
        velocity.dx += dx/mass
        velocity.dy += dy/mass
    }
    
    /**
     Apply a force to the PhysicsObject
     - parameters:
        - dx: The horizontal component of the force applied
        - dy: The vertical componenent of the force applied
     */
    public func applyForce(dx: CGFloat, dy: CGFloat) {
        force.dx += dx
        force.dy += dy
    }
    
    // ----------------- Integration --------------------------------
    
    /**
     Integrate the forces applied to the object, with respect to time, in this current simulation round.
     
     This converts forces into velocities, it also adds gravity
     - parameters:
        - t: The interval of time between the last round of simulation.
     */
    func integrateForces(timeInterval t : TimeInterval) {
        if (mass == -1) {
            return
        }

        velocity.dx += (force.dx/mass)*CGFloat(t) // Apply forces from the x dimension

        velocity.dy += ((force.dy/mass) - PhysicsWorld.GRAVITY)*CGFloat(t) // Apply forces in the y direction + gravity
    }
    
    /**
     Integrate the objects current velocities with respect to time, to calculate where the objects next position should be.
     - parameters:
        - t: The interval of time between now and the last round of simulation.
     */
    func integrateVelocity(timeInterval t : TimeInterval) {
        if (mass == -1) {
            return
        }
        setPosition(x: getPosition().x + velocity.dx*CGFloat(t), y: getPosition().y+velocity.dy*CGFloat(t))
        integrateForces(timeInterval: t)
    }
}
