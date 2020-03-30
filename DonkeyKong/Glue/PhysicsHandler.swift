//
//  PhysicsHandler.swift
//  DonkeyKong
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsHandler: SKNode, SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let node1 = contact.bodyA.node { // Prevents an error from being called with sprites that remove themselves from parent
            if node1 is ItemSprite {
                let node2 = contact.bodyB.node!
                if node2 is MarioSprite {
                    let mario = node2 as! MarioSprite
                    let item = node1 as! ItemSprite
                    item.collision(mario: mario)
                }
            } else if node1 is BreakableBlockSprite {
                let node2 = contact.bodyB.node!
                if node2 is MarioSprite {
                    let mario = node2 as! MarioSprite
                    if((mario.physicsBody?.velocity.dy)! < CGFloat(-20)) { // Postive velocities are negative?
                        let block = node1 as! BreakableBlockSprite
                        block.breakBlock()
                    }
                }
            } else if node1 is ItemBlockSprite {
                let node2 = contact.bodyB.node!
                if node2 is MarioSprite {
                    let block = node1 as! ItemBlockSprite
                    block.spawnItem()
                }
            } else if node1 is KoopaSprite{
                let koopa = node1 as! KoopaSprite
                koopa.collision(contact: contact)
            } else if node1 is MarioSprite {
                let mario = node1 as! MarioSprite
                mario.collision(contact: contact) // Mario can handle collisions himself
            }
        }
    }
}
