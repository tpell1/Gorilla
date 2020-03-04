//
//  ItemSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 04/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

enum ItemType: String {
	case STAR, FIRE, ONEUP, MUSHROOM
}

class ItemSprite: SKSpriteNode {
	private var texture : SKTexture

   init(x: CGFloat, y: CGFloat, itemType: ItemType) {
        texture = SKTexture(imageNamed: (itemType.rawValue + ".png"))
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
		
		self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(50.0), height: CGFloat(50.0)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
		self.physicsBody?.affectedByGravity = true
		self.physicsBody?.collisionBitMask = 0b0010
	}
	
	func move() {
		self.physicsBody?.velocity! = CGVector(x: 50, y: 0)
	}
}