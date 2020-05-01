//
//  ItemSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 04/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

// List of all item types
enum ItemType: String {
	case STAR, FIRE, ONEUP, MUSHROOM, SHELL
}

class ItemSprite: SKSpriteNode {
    internal var texture1 : SKTexture?
    internal var itemUsed : Bool = false
    static var ITEM_SPEED = 50
    internal var direction : CGFloat = 1
    
    init(x: CGFloat, y: CGFloat, itemType: ItemType) {
        texture1 = SKTexture(imageNamed: (itemType.rawValue + ".png"))
        super.init(texture: texture1, color: UIColor.clear, size: (texture1?.size())!)
        super.scale(to: CGSize(width: 20, height: 20))
        self.position = CGPoint(x: x, y: y)
        
        ////////// SpriteKit Physics ////////////////
        /*
        self.physicsBody = SKPhysicsBody(texture: (self.texture1)!, size: CGSize(width: CGFloat(20.0), height: CGFloat(20.0)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
		self.physicsBody?.affectedByGravity = true
        self.physicsBody?.linearDamping = 0 // Item should not slow down
        self.physicsBody?.friction = 0 // Item should not slow down
		self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
        */
        //////// My Physics ////////////
        physicsObj = PhysicsObject(withNode: self)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Collision handler (if the item is node1)
    func collision(node: SKNode) {
        if node is MarioSprite {
            let mario = node as! MarioSprite
            if(!itemUsed) {
                itemUsed = true
                mario.incLives(amountToInc: 1)
            }
            self.removeFromParent()
        }
    }
    
    func reverseDirection() {
        direction = -direction
        self.physicsBody?.velocity.dx = direction*(self.physicsBody?.velocity.dx ?? CGFloat(ItemSprite.ITEM_SPEED))
    }
    
    
    func move() {
        self.physicsBody?.velocity = CGVector(dx: ItemSprite.ITEM_SPEED, dy: 0)
    }
    
	func startMove(direction dir : CGFloat) {
        direction = dir
        self.physicsBody?.velocity = CGVector(dx: CGFloat(ItemSprite.ITEM_SPEED)*direction, dy: 0)
    }
}
