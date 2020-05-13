//
//  FireEntityItem.swift
//  Gorilla
//
//  Created by Travis Pell on 17/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class FireEntityItem : ShellItem {
    static var FIRE_SPEED : CGFloat = 10
    
     convenience init(x:CGFloat, y: CGFloat) {
        self.init(x: x, y: y, itemType: ItemType.FIRE)
        self.scale(to: CGSize(width: 20, height: 20))
        self.physicsObj?.solveCollisions = false
        itemType = ItemType.FIRE
    }
    
    func shoot(inDirection dir: CGVector) {
        let dx = (dir.dx-position.x)
        let dy = (dir.dy-position.y)
        let action = SKAction.move(to: CGPoint(x: dir.dx+dx*10, y: dir.dy+dy*10), duration: 6)
        self.run(action)
    }
}
