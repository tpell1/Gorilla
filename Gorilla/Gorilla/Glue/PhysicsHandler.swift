//
//  PhysicsHandler.swift
//  Gorilla
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

class PhysicsHandler: PhysicsCollisionHandler {
    func handleCollision(collision: PhysicsCollision) {
        let node1 = collision.b.node // Prevents an error from being called with sprites that remove themselves from parent
        if node1 is ItemSprite {
            let node2 = collision.a.node
            let item = node1 as! ItemSprite
            item.collision(node: node2)
        } else if node1 is BreakableBlockSprite {
            let node2 = collision.a.node
            if node2 is MartinioSprite {
                let martinio = node2 as! MartinioSprite
                if((martinio.physicsObj!.velocity.dy) < CGFloat(-23)) { // Postive velocities are negative?
                    let block = node1 as! BreakableBlockSprite
                    block.breakBlock()
                }
            }
        } else if node1 is ItemBlockSprite {
            let node2 = collision.a.node
            if node2 is MartinioSprite {
                let martinio = node2 as! MartinioSprite
                if((martinio.physicsObj!.velocity.dy) < CGFloat(-23)) { // Postive velocities are negative?
                    let block = node1 as! ItemBlockSprite
                    block.spawnItem()
                }
            }
        } else if node1 is TurtleSprite{
            let turtle = node1 as! TurtleSprite
            turtle.collision(contact: collision)
        } else if node1 is MartinioSprite {
            let martinio = node1 as! MartinioSprite
            martinio.collision(contact: collision) // Martinio can handle collisions himself
        } else if node1 is EndLevelNode {
            let end = node1 as! EndLevelNode
            let node2 = collision.a.node
            if node2 is MartinioSprite {
                end.endLevel()
            }
        }
    }
}
