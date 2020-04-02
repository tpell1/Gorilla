//
//  ShellItem.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class ShellItem: ItemSprite {
    convenience init(x:CGFloat, y: CGFloat) {
        self.init(x: x, y: y, itemType: ItemType.SHELL)
        self.scale(to: CGSize(width: 20, height: 20))
    }
    
    override func collision(mario: MarioSprite) {
        if(!itemUsed) {
            itemUsed = true
            mario.shrink()
        }
        self.removeFromParent()
    }
}
