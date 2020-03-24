//
//  KoopaSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class KoopaSprite: SKSpriteNode {
    private var height = 60
    private var width = 50
    private var sizeOfPlatform = 3
    
    // Default constructor, creates a koopa character with one life
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "koopa.png") // Use the mario texture
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(55.0), height: CGFloat(60.0)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.name = "Koopa"
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
    }
    
    convenience init(x: CGFloat, y: CGFloat, sizeOfPlatform: Int) {
        self.init(x: x, y: y)
        self.sizeOfPlatform = sizeOfPlatform
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk() {
    }
}
