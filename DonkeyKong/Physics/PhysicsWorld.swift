//
//  PhysicsWorld.swift
//  DonkeyKong
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsWorld {
    private var physicsObjects : [PhysicsObject]
    //private var timer : Timer?
    
    init() {
        /*timer = Timer(timeInterval: 0.03, target: self, selector: #selector(self.updatePhysics), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)*/
        physicsObjects = []
    }
    
    // simulate will be called by GameScene Object
    @objc func updatePhysics() {
        simulate()
    }
    
    func simulate() {
        for i in 0...(physicsObjects.count-1) {
            for j in i+1...(physicsObjects.count-1) {
                if (i != j) {
                    if (collision(i: i, j: j)) {
                        
                    }
                }
            }
        }
    }
    
    func addObject(object obj : PhysicsObject) -> Int {
        physicsObjects.append(obj)
        let i = physicsObjects.count-1
        physicsObjects[i].setIndex(index: i)
        return i
    }
    
    func removeObject(Object obj : PhysicsObject) {
        physicsObjects.remove(at: obj.index)
    }
    
    private func collision(i : Int, j : Int) -> Bool {
        
    }
}
