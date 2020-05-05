//
//  PhysicsHandler.swift
//  DonkeyKong
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

class PhysicsHandler: PhysicsCollisionHandler {
    func handleCollision(collision: PhysicsCollision) {
        let node1 = collision.manifold.b.node // Prevents an error from being called with sprites that remove themselves from parent
        if node1 is ItemSprite {
            let node2 = collision.manifold.a.node
            let item = node1 as! ItemSprite
            item.collision(node: node2)
        } else if node1 is BreakableBlockSprite {
            let node2 = collision.manifold.a.node
            if node2 is MarioSprite {
                let mario = node2 as! MarioSprite
                if((mario.physicsObj!.physicsBody.velocity.dy) < CGFloat(-23)) { // Postive velocities are negative?
                    let block = node1 as! BreakableBlockSprite
                    block.breakBlock()
                }
            }
        } else if node1 is ItemBlockSprite {
            let node2 = collision.manifold.a.node
            if node2 is MarioSprite {
                let mario = node2 as! MarioSprite
                if((mario.physicsObj!.physicsBody.velocity.dy) < CGFloat(-23)) { // Postive velocities are negative?
                    let block = node1 as! ItemBlockSprite
                    block.spawnItem()
                }
            }
        } else if node1 is KoopaSprite{
            let koopa = node1 as! KoopaSprite
            koopa.collision(contact: collision)
        } else if node1 is MarioSprite {
            let mario = node1 as! MarioSprite
            mario.collision(contact: collision) // Mario can handle collisions himself
        } else if node1 is EndLevelNode {
            let end = node1 as! EndLevelNode
            let node2 = collision.manifold.a.node
            if node2 is MarioSprite {
                end.endLevel()
            }
        }
    }
}
