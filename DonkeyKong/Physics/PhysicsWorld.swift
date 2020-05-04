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
    static var GRAVITY : CGFloat = 400
    static var DELTA_T : Double = 0.01
    //private var timer : Timer?
    
    init() {
        /*timer = Timer(timeInterval: 0.03, target: self, selector: #selector(self.updatePhysics), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)*/
        physicsObjects = []
    }
    
    func simulate(TimeSinceLastUpdate dt : TimeInterval) {
        var collisions : [PhysicsCollision] = []
        for obj in physicsObjects {
            obj.updatePosition()
        }
        for i in 0...(physicsObjects.count-2) {
            for j in i+1...(physicsObjects.count-1) {
                if (i != j) {
                    if (collision(withObject1: i, object2: j)) {
                        let m = overlapAABB(withObject1: i, object2: j)
                        collisions.append(m)
                    }
                }
            }
        }
        for obj in physicsObjects {
            obj.integrateForces(timeInterval: dt)
        }
        for collision in collisions {
            collision.resolve()
        }
        for obj in physicsObjects {
            obj.integrateVelocity(timeInterval: dt)
        }
        for collision in collisions {
            collision.positionalCorrection()
        }
        for obj in physicsObjects {
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
        
    private func overlapAABB(withObject1 i : Int, object2 j : Int) -> PhysicsCollision{
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
