//
//  BlockSprite.swift
//  DonkeyKong
//
//  Represents a solid block
//  Also acts as a super class for all
//  block classes
//
//  Created by Travis Pell on 03/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class BlockSprite : SKSpriteNode {
    static var BLOCK_SIZE: CGFloat = 40
    
    init(x: CGFloat, y: CGFloat, imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
		
        self.scale(to: CGSize(width: BlockSprite.BLOCK_SIZE, height: BlockSprite.BLOCK_SIZE))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: BlockSprite.BLOCK_SIZE, height: BlockSprite.BLOCK_SIZE))
        self.physicsBody?.restitution = 0.4 // Make Mario bounce when he lands
        self.physicsBody?.isDynamic = false // Stop block from moving
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
