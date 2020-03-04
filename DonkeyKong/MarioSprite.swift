//
//  MarioSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 19/02/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class MarioSprite : SKSpriteNode {
    private var jumpCount = 0
    
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "mario.png")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: 100, height: 100))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(100.0), height: CGFloat(100.0)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Allows single and double jumps
    func jump() {
        print(String(describing: self.physicsBody?.velocity.dy))
        if ((self.physicsBody?.velocity.dy.isLessThanOrEqualTo(CGFloat(0.1)))!) {
            jumpCount = 0
        }
        if (jumpCount == 0 && (self.physicsBody?.velocity.dy)! >= CGFloat(0)) {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
            jumpCount += 1
        } else if (jumpCount == 1 && (self.physicsBody?.velocity.dy)! >= CGFloat(0)) {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            jumpCount += 1
        }
    }
}
