//
//  DonkeyKongSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class DonkeyKongSprite: SKSpriteNode {
    private var height = 100
    private var width = 80
    
    // Default constructor, creates a koopa character with one life
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "donkeyKong.png") // Use the mario texture
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(width+5), height: CGFloat(height)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.name = "DonkeyKong"
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fightMario(marioPos: CGPoint) {
        let marioX = marioPos.x
        let marioY = marioPos.y
        
        if (abs(marioX - self.position.x) < 30 && abs(marioY - self.position.y) < 30) {
            attack(position: marioPos)
        } else {
            walk(to: marioPos)
        }
    }
    
    private func attack(position: CGPoint) {
        //TODO
    }
    
    private func walk(to: CGPoint) {
        //TODO
    }
}
