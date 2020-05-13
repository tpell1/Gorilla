//
//  ShellItem.swift
//  Gorilla
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class ShellItem: ItemSprite {
    private var timer : Timer?
    internal var itemType : ItemType = ItemType.SHELL
    
    convenience init(x:CGFloat, y: CGFloat) {
        self.init(x: x, y: y, itemType: ItemType.SHELL)
        self.scale(to: CGSize(width: 20, height: 20))
    }
    
    // Collision handler (if the item is node1)
    override func collision(node: SKNode) {
        if node is MartinioSprite {
            let martinio = node as! MartinioSprite
            if(!itemUsed) {
                itemUsed = true
                martinio.shrink()
            }
            self.removeFromParent()
        } else if (node is TurtleSprite) && itemType != ItemType.SHELL {
            let turtle = node as! TurtleSprite
            turtle.removeFromParent()
        } else if node is GorillaSprite {
            let dk = node as! GorillaSprite
            dk.hit()
        }
    }
}
