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
    
    override func collision(mario: MarioSprite) {
        if(!itemUsed) {
            itemUsed = true
            mario.grow()
            mario.texture = SKTexture(imageNamed: "marioFire.png")
            mario.scale(to: CGSize(width: mario.getWidth(), height: mario.getHeight()))
        }
        self.removeFromParent()
    }
}
