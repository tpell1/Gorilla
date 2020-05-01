//
//  PhysicsWorld.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

struct ManifoldStruct {
    var a : PhysicsObject
    var b : PhysicsObject
    var penetration : CGFloat
    var normal : CGVector
}

class PhysicsWorld {
    private var physicsObjects : [PhysicsObject]
    var gravity : CGFloat = 9.8
    //private var timer : Timer?
    
    init() {
        /*timer = Timer(timeInterval: 0.03, target: self, selector: #selector(self.updatePhysics), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)*/
        physicsObjects = []
    }
    
    func simulate(TimeSinceLastUpdate dt : TimeInterval) {
        for obj in physicsObjects {
            integrateForces(forBody: obj.physicsBody, timeInterval: dt)
        }
        for i in 0...(physicsObjects.count-2) {
            for j in i+1...(physicsObjects.count-1) {
                if (i != j) {
                    if (collision(withObject1: i, object2: j)) {
                        let m = overlapAABB(withObject1: i, object2: j)
                        resolveCollision(withObject1: i, object2: j, usingManifold: m)
                    }
                }
            }
        }
        for obj in physicsObjects {
            integrateVelocity(forObj: obj, timeInterval: dt)
            obj.physicsBody.force = CGVector(dx: 0, dy: 0)
        }
    }
    
    func addObject(object obj : PhysicsObject) -> Int {
        physicsObjects.append(obj)
        let i = physicsObjects.count-1
        physicsObjects[i].setIndex(index: i)
        return i
    }
    
    func addNodes(collection : [SKNode]) {
        for i in 0...collection.count-1 {
            physicsObjects.append(collection[i].physicsObj!)
        }
    }
    
    func removeObject(Object obj : PhysicsObject) {
        physicsObjects.remove(at: obj.index)
    }
    
    private func collision(withObject1 i : Int, object2 j : Int) -> Bool {
        let a = physicsObjects[i].physicsBody
        let b = physicsObjects[j].physicsBody

        if (a.max.x < b.min.x || a.min.x > b.max.x) {
            return false
        }
        else if (a.max.y < b.min.y || a.min.y > b.max.y) {
            return false
        } else {
            return true
        }
    }
    
    private func integrateForces(forBody b : PhysicsBody, timeInterval t : TimeInterval) {
        if (b.mass == 0) {
            return
        }
        b.velocity.dx = (b.force.dx/b.mass)*CGFloat(t/2.0)
        b.velocity.dy = ((b.force.dy/b.mass) + gravity)*CGFloat(t/2.0)
    }
    
    private func integrateVelocity(forObj obj : PhysicsObject, timeInterval t : TimeInterval) {
        let b = obj.physicsBody
        if (b.mass == 0) {
            return
        }
        obj.setPosition(x: obj.getPosition().x + b.velocity.dx*CGFloat(t), y: obj.getPosition().y + b.velocity.dy*CGFloat(t))
        integrateForces(forBody: b, timeInterval: t)
    }
    
    private func resolveCollision(withObject1 i : Int, object2 j : Int, usingManifold m : ManifoldStruct) {
        let a = physicsObjects[i].physicsBody
        let b = physicsObjects[j].physicsBody
        let normal = m.normal
        
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
        
        var j = -(1 + e) * vecAlongNormal
        j = j / (aInvertedMass + bInvertedMass)
        
        let impulse = CGVector(dx: j*normal.dx, dy: 0) //dy is 0 because we dont want any bounce vertically!
        a.velocity = CGVector(dx: a.velocity.dx-((aInvertedMass)*impulse.dx), dy: a.velocity.dy-((aInvertedMass)*impulse.dy))
        b.velocity = CGVector(dx: b.velocity.dx-((bInvertedMass)*impulse.dx), dy: b.velocity.dy-((bInvertedMass)*impulse.dy))
    }
    
    private func overlapAABB(withObject1 i : Int, object2 j : Int) -> ManifoldStruct{
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
                if (xOverlap>yOverlap) {
                    if(n.dx<0) {
                        m.normal = CGVector(dx: -1, dy: 0)
                    } else {
                        m.normal = CGVector(dx: 1, dy: 0)
                    }
                    m.penetration = xOverlap
                } else {
                    if(n.dy<0) {
                        m.normal = CGVector(dx: 0, dy: -1)
                    } else {
                        m.normal = CGVector(dx: 0, dy: 1)
                    }
                    m.penetration = yOverlap
                }
            }
        }
        return m
    }
}
