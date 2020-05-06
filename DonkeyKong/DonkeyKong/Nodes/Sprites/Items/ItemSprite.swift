//
//  ItemSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 04/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

/**
 The type of the item
 */
enum ItemType: String {
	case STAR, FIRE, ONEUP, MUSHROOM, SHELL
}

/**
 Super class for all Items, also is by default `ItemType.ONEUP`
 */
class ItemSprite: SKSpriteNode {
    internal var texture1 : SKTexture?
    internal var itemUsed : Bool = false
    static var ITEM_SPEED = 50
    internal var direction : CGFloat = 1
    
    /**
     Constructor for `ItemSprite`
     - parameters:
        - x: The x coordinate of the instance
        - y: The y coordinate of the instance
        - itemType: the type of item
     */
    init(x: CGFloat, y: CGFloat, itemType: ItemType) {
        texture1 = SKTexture(imageNamed: (itemType.rawValue + ".png"))
        super.init(texture: texture1, color: UIColor.clear, size: (texture1?.size())!)
        super.scale(to: CGSize(width: 20, height: 20))
        self.position = CGPoint(x: x, y: y)
        
        physicsObj = PhysicsObject(withNode: self)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
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
    }
    
    
    func move() {
        physicsObj?.applyForce(dx: 7000, dy: 0)
    }
    
	func startMove(direction dir : CGFloat) {
        direction = dir
        self.physicsObj?.velocity.dx = CGFloat(ItemSprite.ITEM_SPEED*10)*direction
    }
}
