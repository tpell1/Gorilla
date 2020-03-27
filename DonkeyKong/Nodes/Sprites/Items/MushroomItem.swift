//
//  MushroomItem.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class MushroomItem: ItemSprite {
    
    convenience init(x:CGFloat, y: CGFloat) {
        self.init(x: x, y: y, itemType: ItemType.MUSHROOM)
    }
    
    override func collision(mario: MarioSprite) {
        if(!itemUsed) {
            itemUsed = true
            mario.grow()
        }
        self.removeFromParent()
    }
}
