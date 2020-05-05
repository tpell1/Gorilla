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
 Contains details of a collision in the physics engine.
 
  `a` - Object a in the collision.
 
  `b` - Object B in the collision.
 
  `penetration` - How far the objects have penetrated one another.
 
  `normal` - The normal of the collision.
 */
public struct ManifoldStruct {
    public var a : PhysicsObject
    public var b : PhysicsObject
    public var penetration : CGFloat
    public var normal : CGVector
}

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
    public var manifold : ManifoldStruct
    
    /**
     initialises the object with the properties required
     - parameters:
        - m: The manifold that holds all the properties of the collision
     */
    init(withManifold m : ManifoldStruct) {
        manifold = m
    }
    
    /**
     Applies the normal force to the object and prevents it from vibrating.
     */
    func positionalCorrection() {
        let percent = CGFloat(0.8)
        let slop = CGFloat(0.01)
        var aInvertedMass = CGFloat(1)
        var bInvertedMass = CGFloat(1)
        if (manifold.a.physicsBody.mass == -1) {
            aInvertedMass = 0
        } else {
            aInvertedMass = 1/manifold.a.physicsBody.mass
        }
        if (manifold.b.physicsBody.mass == -1) {
            bInvertedMass = 0
        } else {
            bInvertedMass = 1/manifold.b.physicsBody.mass
        }
        
        if (aInvertedMass == 0 && bInvertedMass == 0) {
            return
        }
        let correction = (max(manifold.penetration-slop, 0.0) / (aInvertedMass+bInvertedMass)) * percent
        manifold.a.setPosition(x: manifold.a.getPosition().x/*-(aInvertedMass*correction*manifold.normal.dx)*/, y: manifold.a.getPosition().y-(aInvertedMass*correction*manifold.normal.dy))
        manifold.b.setPosition(x: manifold.b.getPosition().x/*-(bInvertedMass*correction*manifold.normal.dx)*/, y: manifold.b.getPosition().y+(bInvertedMass*correction*manifold.normal.dy))
    }
    
    /**
     Resolve the collision.
     
     Calculates the impulse required to prevent the objects from sinking into each other.
     */
    func resolve() {
        let a = manifold.a.physicsBody
        let b = manifold.b.physicsBody
        let normal = manifold.normal
        
        let rv = CGVector(dx: b.velocity.dx-a.velocity.dx, dy: b.velocity.dy-a.velocity.dy)
        
        let vecAlongNormal = rv.dx*normal.dx + rv.dy*normal.dy
        
        if (vecAlongNormal > 0) {
            return;
        }
        
        let e = min(a.restitution, b.restitution)
        
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
        

        
        let jx = (-(1 + e) * vecAlongNormal) / (aInvertedMass + bInvertedMass)
        let jy = (-vecAlongNormal) / (aInvertedMass + bInvertedMass)
        
        let impulse = CGVector(dx: jx*normal.dx, dy: jy*normal.dy) //dy is 0 because we dont want any bounce vertically!
        a.velocity = CGVector(dx: a.velocity.dx-((aInvertedMass)*impulse.dx), dy: a.velocity.dy-((aInvertedMass)*impulse.dy))
        b.velocity = CGVector(dx: b.velocity.dx+((bInvertedMass)*impulse.dx), dy: b.velocity.dy+((bInvertedMass)*impulse.dy))
        if (a.velocity.dx.isNaN) {
            print(a.velocity)
        }
    }
}
