//
//  MarioSprite.swift
//  Represents the Mario character
//
//  DonkeyKong
//  Class representing Mario,
//  Contains collision logic, and also defines how
//  Mario jumps and dies
//
//  Created by Travis Pell on 19/02/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class MarioSprite : SKSpriteNode {
    private var jumpCount = 0
    private var lives = 1
    private var moveSpeedMultiplier: CGFloat = 1
    private var health = 1
    private var width = 50
    private var height = 60
    private var scale = 1
    private var shootable = true
    private var jumpSound = true
    static var DEFAULT_MOVE_SPEED: CGFloat = 100
    
    // Default constructor, creates a main character with one life
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "mario.png") // Use the mario texture
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        
        //////// SpriteKit Physics //////////
        /*
        self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(55.0), height: CGFloat(60.0)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.name = "Mario"
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        */
        ////////// My Physics /////////////
        physicsObj = PhysicsObject(withNode: self)
        
        jumpSound = ConfigData.read().SoundOn
    }
    
    // Constructor which gives choice of lives for Mario to be instantiated with
    convenience init(x: CGFloat, y: CGFloat, lives: Int) {
        self.init(x: x, y: y)

        self.lives = lives
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called by game scene when Mario is node1
    func collision(contact: SKPhysicsContact) {
        if (contact.bodyB.node != nil) {
            let node2 = contact.bodyB.node!
            if node2 is BreakableBlockSprite { // Break block
                if(((self.physicsObj?.physicsBody.velocity.dy)!) < CGFloat(-20)) {
                    let block = node2 as! BreakableBlockSprite
                }
                /*if((self.physicsBody?.velocity.dy)! < CGFloat(-20)) { // Postive velocities are negative?
                    let block = node2 as! BreakableBlockSprite
                    block.breakBlock()
                }*/
            } else if node2 is ItemSprite { // Use item and then remove item
                let item = node2 as! ItemSprite
                item.collision(node: self)
            } else if node2 is ItemBlockSprite { // Spawn an item
                if((self.physicsBody?.velocity.dy)! < CGFloat(-20)) {
                    let block = node2 as! ItemBlockSprite
                    block.spawnItem()
                }
            } else if node2 is EndLevelNode { // End the level
                let node = node2 as! EndLevelNode
                node.endLevel()
            } else if node2 is KoopaSprite {
                self.shrink()
            }
        }
    }
    
    // Allows single and double jumps
    func jump() {
        let playJumpSound = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: true)
        //print(String(describing: self.physicsBody?.velocity.dy))
        let physics = self.physicsObj
        if((((physics?.physicsBody.velocity.dy.isLessThanOrEqualTo(CGFloat(0.1)))!))) {
            jumpCount = 0
        }
        if (jumpCount == 0 && (physicsObj?.verticalVelocityIsZero())!) {
            if (jumpSound) {
                self.run(playJumpSound)
            }
            jumpCount += 1
            self.physicsObj?.applyForce(dx: 0, dy: 30000)
        } else if (jumpCount == 1 && (physicsObj?.verticalVelocityIsZero())!) {
            if (jumpSound) {
                self.run(playJumpSound)
            }
            self.physicsObj?.applyImpulse(dx: 0, dy: 300)
            jumpCount += 1
        }
        
        /* SpriteKit code
        if ((self.physicsBody?.velocity.dy.isLessThanOrEqualTo(CGFloat(0.1)))!) {
            jumpCount = 0
        }
        if (jumpCount == 0 && (self.physicsBody?.velocity.dy)! >= CGFloat(0)) {
            if (jumpSound) {
                self.run(playJumpSound)
            }
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
            jumpCount += 1
        } else if (jumpCount == 1 && (self.physicsBody?.velocity.dy)! >= CGFloat(0)) {
            if (jumpSound) {
                self.run(playJumpSound)
            }
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            jumpCount += 1
        }
         */
    }
    
    func shoot(direction dir: CGVector) {
        
        let fire = FireEntityItem(x: getPositionInScene().x, y: getPositionInScene().y)
        self.addChild(fire)
        fire.shoot(inDirection: dir, toNode: (self.parent)!)
    }
    
    // Kill Mario and restart level
    func die() {
        lives -= 1
        if self.scene is GameScene {
            let game = self.scene as! GameScene
            game.restartLevel(lives: lives)
        }
        self.removeFromParent()
    }
    
    func getPositionInScene() -> CGPoint {
        return self.convert(self.position, to: scene!)
    }
    
    func fireItem() {
        grow()
        self.texture = SKTexture(imageNamed: "marioFire.png")
        self.scale(to: CGSize(width: width, height: height))
        shootable = true
    }
    
    func grow() {
        scale = 2
        reDo()
    }
    
    func shrink() {
        scale -= 1
        if (scale < 1) {
            die()
        }
        reDo()
    }
    
    func incLives(amountToInc: Int) {
        lives += amountToInc
    }
    
    func getLives() -> Int {
        return lives
    }
    
    func getSpeed() -> CGFloat {
        return MarioSprite.DEFAULT_MOVE_SPEED * moveSpeedMultiplier
    }
    
    func getWidth() -> Int {
        return width
    }
    
    func getHeight() -> Int {
        return height
    }
    
    private func reDo() {
        self.scale(to: CGSize(width: width, height: height))
        //self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(55.0), height: CGFloat(60.0)))
    }
    
    func isShootable() -> Bool {
        return shootable
    }
}
