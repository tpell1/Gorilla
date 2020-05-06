//
//  PhysicsCollision.swift
//  DonkeyKong
//
//  Created by Travis Pell on 03/05/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Protocol making sure that the class designated to handle collisions can do so.
 */
public protocol PhysicsCollisionHandler {
    func handleCollision(collision : PhysicsCollision)
}

/**
 Represents a collision between two objects.
 */
public class PhysicsCollision {
    /** The first object involved in the collision */
    public var a : PhysicsObject
    /** The second object involved in the collision */
    public var b : PhysicsObject
    /**The depth that the two objects have penetrated each other */
    public var penetration : CGFloat
    /** The normal vector of the collision*/
    public var normal : CGVector
    /**
     initialises the object with the properties required
     - parameters:
        - obj1: The first object in the collision
        - obj2 : The second object involved in the collision
     */
    init(withObject obj1: PhysicsObject, andObj obj2: PhysicsObject) {
        a = obj1
        b = obj2
        penetration = 0
        normal = CGVector(dx: 0, dy: 0)
    }
    
    /**
     Applies the normal force to the object and prevents it from vibrating.
     */
    func positionalCorrection() {
        let percent = CGFloat(0.8)
        let slop = CGFloat(0.01)
        var aInvertedMass = CGFloat(1)
        var bInvertedMass = CGFloat(1)
        if (a.mass == -1) {
            aInvertedMass = 0
        } else {
            aInvertedMass = 1/a.mass
        }
        if (b.mass == -1) {
            bInvertedMass = 0
        } else {
            bInvertedMass = 1/b.mass
        }
        
        if (aInvertedMass == 0 && bInvertedMass == 0) {
            return
        }
        let correction = (max(penetration-slop, 0.0) / (aInvertedMass+bInvertedMass)) * percent
        a.setPosition(x: a.getPosition().x/*-(aInvertedMass*correction*normal.dx)*/, y: a.getPosition().y-(aInvertedMass*correction*normal.dy))
        b.setPosition(x: b.getPosition().x/*-(bInvertedMass*correction*normal.dx)*/, y: b.getPosition().y+(bInvertedMass*correction*normal.dy))
    }
    
    /**
     Resolve the collision.
     
     Calculates the impulse required to prevent the objects from sinking into each other. Adapted from Chris Hecker's collision response equations found [here](http://www.chrishecker.com/Rigid_Body_Dynamics)
     */
    func resolve() {
        
        // Check if object's collision should be solved, if not return as to not waste calculation
        if (!(a.solveCollisions && b.solveCollisions)) {
            return
        }
        
        let rVelocity = CGVector(dx: b.velocity.dx-a.velocity.dx, dy: b.velocity.dy-a.velocity.dy) // The relative velocity of the two objects
        
        let normalVelocity = rVelocity.dx*normal.dx + rVelocity.dy*normal.dy // The velocity along the normal
        // will be used to calculate the normal force.
        
        if (normalVelocity > 0) {
            return;
        }
        
        let e = min(a.restitution, b.restitution)
        
        // Set the inverted mass of objects, objects with infinite mass (mass=-1) will have an inverse mass of 0
        var aInvertedMass = CGFloat(1)
        var bInvertedMass = CGFloat(1)
        if (a.mass == -1) {
            aInvertedMass = 0
        } else {
            aInvertedMass = 1/a.mass
        }
        if (b.mass == -1) {
            bInvertedMass = 0
        } else {
            bInvertedMass = 1/b.mass
        }
        
        if(aInvertedMass == 0 && bInvertedMass == 0) {
            return
        }
        

        
        let jx = (-(1 + e) * normalVelocity) / (aInvertedMass + bInvertedMass) // Calculate normal force + coefficient of restitution
        let jy = (-normalVelocity) / (aInvertedMass + bInvertedMass) //jy is calculated differently because we do not want restitution to exist in the y plane, we would like all vertical collisions to not have any springiness
        
        let impulse = CGVector(dx: jx*normal.dx, dy: jy*normal.dy)
        a.velocity = CGVector(dx: a.velocity.dx-((aInvertedMass)*impulse.dx), dy: a.velocity.dy-((aInvertedMass)*impulse.dy))
        b.velocity = CGVector(dx: b.velocity.dx+((bInvertedMass)*impulse.dx), dy: b.velocity.dy+((bInvertedMass)*impulse.dy))
    }
}
