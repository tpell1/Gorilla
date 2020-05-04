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
 Contains details of a collision in the physics engine.
 
  `a` - Object a in the collision.
 
  `b` - Object B in the collision.
 
  `penetration` - How far the objects have penetrated one another.
 
  `normal` - The normal of the collision.
 */
struct ManifoldStruct {
    var a : PhysicsObject
    var b : PhysicsObject
    var penetration : CGFloat
    var normal : CGVector
}

/**
 Represents the world which physics simulations will be run in.
 */
class PhysicsWorld {
    private var physicsObjects : [PhysicsObject]
    private var handler : PhysicsCollisionHandler?
    static var GRAVITY : CGFloat = 2600
    static var DELTA_T : Double = 0.01
    //private var timer : Timer?
    
    /**
    `PhysicsWorld` constructor
     
     initialises the `physicsObjects` array
     */
    init() {
        physicsObjects = []
    }
    
    /**
     calculates one step of the physics engine
     - parameters:
       - dt: The length of time from last update, used to keep all simulations consistent
     */
    func simulate(TimeSinceLastUpdate dt : TimeInterval) {
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
            obj.physicsBody.force = CGVector(dx: 0, dy: 0) // Set forces to zero so that they dont carry over to next step of calculations
        }
    }
    
    /**
     Add object to the ** PhysicsWorld**.
     
     - parameters:
        - obj: The object to add to PhysicsWorld
     - Returns: The index of the object in the `physicsObjects` array
     */
    func addObject(object obj : PhysicsObject) -> Int {
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
    func setCollisionHandler(asObj obj : PhysicsCollisionHandler) {
        handler = obj
    }
    
    /**
     add a collection of SpriteKit nodes to **PhysicsWorld**
     - parameters:
        - collection: The collection of `SKNode`'s
     */
    func addNodes(collection : [SKNode]) {
        for i in 0...collection.count-1 {
            physicsObjects.append(collection[i].physicsObj!)
        }
    }
    
    /**
     Remove an object from **PhysicsWorld**
     - parameters:
        - obj: Index of object to remove from world
     */
    func removeObject(ObjectIndex obj : Int) {
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
        let a = physicsObjects[i].physicsBody
        let b = physicsObjects[j].physicsBody

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
     Creates `PhysicsCollision` object
     - parameters:
        - i : index of object one in collision
        - j : index of object two in collision
     - returns: `PhysicsCollision`: The collision object
     */
    private func solveCollision(withObject1 i : Int, object2 j : Int) -> PhysicsCollision{
        let a = physicsObjects[i].physicsBody
        let b = physicsObjects[j].physicsBody
        let aPos = physicsObjects[i].getPosition()
        let bPos = physicsObjects[j].getPosition()
        var m = ManifoldStruct(a: physicsObjects[i], b: physicsObjects[j], penetration: 0.0, normal: CGVector(dx: 0, dy: 0))
        
        let n = CGVector(dx: bPos.x-aPos.x, dy: bPos.y-aPos.y)
        var aExtent = (a.max.x - a.min.x)/2
        var bExtent = (b.max.x - b.min.x)/2
        let xOverlap = aExtent+bExtent - abs(n.dx)
        
        if (xOverlap>0) {
            aExtent = (a.max.y - a.min.y)/2
            bExtent = (b.max.y - b.min.y)/2
            let yOverlap = aExtent+bExtent - abs(n.dy)
            
            if (yOverlap>0) {
                if (xOverlap<yOverlap) {
                    if(n.dx>0) {
                        m.normal = CGVector(dx: 1, dy: 0)
                    } else {
                        m.normal = CGVector(dx: -1, dy: 0)
                    }
                    m.penetration = xOverlap
                } else {
                    if(n.dy>0) {
                        m.normal = CGVector(dx: 0, dy: 1)
                    } else {
                        m.normal = CGVector(dx: 0, dy: -1)
                    }
                    m.penetration = yOverlap
                }
            }
        }
        return PhysicsCollision(withManifold: m)
    }
}
