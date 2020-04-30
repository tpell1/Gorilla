//
//  ShellItem.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class ShellItem: ItemSprite {
    private var timer : Timer?
    
    convenience init(x:CGFloat, y: CGFloat) {
        self.init(x: x, y: y, itemType: ItemType.SHELL)
        self.scale(to: CGSize(width: 20, height: 20))
        
        timer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    // Collision handler (if the item is node1)
    override func collision(node: SKNode) {
        if node is MarioSprite {
            let mario = node as! MarioSprite
            if(!itemUsed) {
                itemUsed = true
                mario.shrink()
            }
            self.removeFromParent()
        } else {
            //reverseDirection()
        }
    }
    
    @objc func update() {
        if (abs(self.physicsBody?.velocity.dx ?? 0) < CGFloat(2)) {
            self.physicsBody?.velocity.dx = 0
            self.physicsBody?.applyImpulse(CGVector(dx: direction*10, dy: 0))
        }
        if (abs(self.physicsBody?.velocity.dy ?? 0) < CGFloat(1)) {
            self.physicsBody?.restitution = 1
        } else {
            self.physicsBody?.restitution = 0
        }
    }
}
