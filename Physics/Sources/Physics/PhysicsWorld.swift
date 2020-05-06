//
//  PhysicsWorld.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Represents the world which physics simulations will be run in.
 */
public class PhysicsWorld {
    private var physicsObjects : [PhysicsObject]
    private var handler : PhysicsCollisionHandler?
    /** The global constant for gravity.
     
Will vary for different requirements.
     
     */
    public static var GRAVITY : CGFloat = 2600
    public static var DELTA_T : Double = 0.01
    
    /**
    `PhysicsWorld` constructor
     
     initialises the `physicsObjects` array
     */
    public init() {
        physicsObjects = []
    }
    
    /**
     calculates one step of the physics engine
     - parameters:
       - dt: The length of time from last update, used to keep all simulations consistent
     */
    public func simulate(TimeSinceLastUpdate dt : TimeInterval) {
        var collisions : [PhysicsCollision] = [] // Reset list of collisions
        
        // Loop through array for the first time, deciding whether it should still be in array
        // and updating its positions
        var i=0
        for obj in physicsObjects {
            if (obj.index == -1) {
                removeObject(ObjectIndex: i)
            } else {
                obj.updatePosition()
            }
            i += 1
        }
        
        // Loop through objects and decided whether they are colliding with one another.
        // If collision detected generate collision object and add it to list of collisions.
        for i in 0...(physicsObjects.count-2) {
            for j in i+1...(physicsObjects.count-1) {
                if (i != j) {
                    if (collision(withObject1: i, object2: j)) {
                        let m = solveCollision(withObject1: i, object2: j)
                        collisions.append(m)
                    }
                }
            }
        }
        for obj in physicsObjects {
            obj.integrateForces(timeInterval: dt) // Integrate forces (calculate velocites)
        }
        for collision in collisions {
            collision.resolve() // Resolve collisions (add more velocites to object)
        }
        for obj in physicsObjects {
            obj.integrateVelocity(timeInterval: dt) // Integrate velocity (calculate position)
        }
        for collision in collisions {
            collision.positionalCorrection() // Correct position so that it does not vibrate or sink. (acts like normal force)
            handler?.handleCollision(collision: collision) // Send collision to collision handler for game logic to process
        }
        for obj in physicsObjects {
            obj.force = CGVector(dx: 0, dy: 0) // Set forces to zero so that they dont carry over to next step of calculations
        }
    }
    
    /**
     Add object to the ** PhysicsWorld**.
     
     - parameters:
        - obj: The object to add to PhysicsWorld
     - Returns: The index of the object in the `physicsObjects` array
     */
    public func addObject(object obj : PhysicsObject) -> Int {
        physicsObjects.append(obj)
        let i = physicsObjects.count-1
        physicsObjects[i].setIndex(index: i)
        return i
    }
    
    /**
    Set the class that should handle collisions processed by the physics engine
     - parameters:
        - obj: The class that will handler collisions
     - returns: `void`
     */
    public func setCollisionHandler(asObj obj : PhysicsCollisionHandler) {
        handler = obj
    }
    
    /**
     add a collection of SpriteKit nodes to **PhysicsWorld**
     - parameters:
        - collection: The collection of `SKNode`'s
     */
    public func addNodes(collection : [SKNode]) {
        for i in 0...collection.count-1 {
            physicsObjects.append(collection[i].physicsObj!)
        }
    }
    
    /**
     Remove an object from **PhysicsWorld**
     - parameters:
        - obj: Index of object to remove from world
     */
    public func removeObject(ObjectIndex obj : Int) {
        physicsObjects.remove(at: obj)
        updateIndexes()
    }
    
    // update indices of physicsObjects
    private func updateIndexes() {
        for i in 0...physicsObjects.count-1 {
            physicsObjects[i].index = i
        }
    }
    
    /**
     Determine whether there is a collision between two objects.
     - parameters:
        - i: Index of object one in `physicsObjects` array
        - j : index of object two
     - returns: `Bool`: collision = `true`
     */
    private func collision(withObject1 i : Int, object2 j : Int) -> Bool {
        let a = physicsObjects[i]
        let b = physicsObjects[j]

        // if bounds of object do not overlap there is no collision
        if (a.max.x < b.min.x || a.min.x > b.max.x) {
            return false
        }
        else if (a.max.y < b.min.y || a.min.y > b.max.y) {
            return false
        } else {
            return true
        }
    }
       
    /**
     Creates `PhysicsCollision` object from two object indices. Determines the collision normal and how far they penetrate each other.
     - parameters:
        - i : index of object one in collision
        - j : index of object two in collision
     - returns: `PhysicsCollision`: The collision object
     
     Solves collisions between to box-bounded objects.
     */
    private func solveCollision(withObject1 i : Int, object2 j : Int) -> PhysicsCollision{
        let a = physicsObjects[i]
        let b = physicsObjects[j]
        let aPos = a.getPosition()
        let bPos = b.getPosition()
        let collision = PhysicsCollision(withObject: a, andObj: b)
        
        let d = CGVector(dx: bPos.x-aPos.x, dy: bPos.y-aPos.y) // The distance between the two vectors
        var aSize = (a.max.x - a.min.x)/2 // The width of a
        var bSize = (b.max.x - b.min.x)/2 // The width of b
        let xOverlap = aSize+bSize - abs(d.dx) // How much the x axis of the two objects overlap
        
        if (xOverlap>0) { // if x axis overlap now repeat and check for y axis overlap
            aSize = (a.max.y - a.min.y)/2 // The height of a
            bSize = (b.max.y - b.min.y)/2 // The height of b
            let yOverlap = aSize+bSize - abs(d.dy) // How much the y axis of the two objects overlap
            
            if (yOverlap>0) { // if y overlap now calculate what objects have overlapped the most
                if (xOverlap<yOverlap) { // The collision was largely in the x direction
                    if(d.dx>0) { // collision normal is positive
                        collision.normal = CGVector(dx: 1, dy: 0)
                    } else { // collision normal is negative
                        collision.normal = CGVector(dx: -1, dy: 0)
                    }
                    collision.penetration = xOverlap // Set the penetration of the collision object
                } else { // The collision was largely in the y direction
                    if(d.dy>0) {
                        collision.normal = CGVector(dx: 0, dy: 1)
                    } else {
                        collision.normal = CGVector(dx: 0, dy: -1)
                    }
                    collision.penetration = yOverlap
                }
            }
        }
        return collision
    }
}
