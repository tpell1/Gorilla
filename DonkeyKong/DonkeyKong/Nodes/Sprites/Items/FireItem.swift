//
//  FireItem.swift
//  DonkeyKong
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class FireItem: ItemSprite {
    
    convenience init(x:CGFloat, y: CGFloat) {
        self.init(x: x, y: y, itemType: ItemType.FIRE)
    }
    
    // Collision handler (if the item is node1)
    override func collision(node: SKNode) {
        if node is MarioSprite {
            let mario = node as! MarioSprite
            if(!itemUsed) {
                itemUsed = true
                mario.fireItem()
            }
            self.removeFromParent()
        } else {
            move()
        }
    }
}
