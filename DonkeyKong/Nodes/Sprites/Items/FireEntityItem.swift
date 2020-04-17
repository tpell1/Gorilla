//
//  FireEntityItem.swift
//  DonkeyKong
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
    }
    
    func shoot(inDirection dir: CGVector, toNode node: SKNode) {
        self.move(toParent: node)
        self.physicsBody?.applyForce(CGVector(dx: dir.dx*FireEntityItem.FIRE_SPEED, dy: dir.dy*FireEntityItem.FIRE_SPEED))
    }
}
