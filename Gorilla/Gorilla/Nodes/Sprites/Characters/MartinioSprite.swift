//
//  MartinioSprite.swift
//  Represents the Martinio character
//
//  Gorilla
//  Class representing Martinio,
//  Contains collision logic, and also defines how
//  Martinio jumps and dies
//
//  Created by Travis Pell on 19/02/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

/**
 Represents the main character of the game.
 
 Contains parts of the collision logic, delegated to by `PhysicsHandler`. And also has the game logic which allows martinio to move, jump, and die.
 */
class MartinioSprite : SKSpriteNode {
    private var jumpCount = 0
    private var lives = 1
    private var moveSpeedMultiplier: CGFloat = 1
    private var health = 1
    private var width = 35
    private var height = 55
    private var scale = 1
    private var shootable = false
    private var sound = true
    static var DEFAULT_MOVE_SPEED: CGFloat = 100
    
    /**
     Default constructor, creates a main character with one life
     - parameters:
        - x: The x coordinate to spawn Martinio
        - y: The y coordinate to spawn Martinio
     */
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "martinio.png") // Use the martinio texture
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        self.name = "Martinio"
        self.zPosition=14
        ////////// My Physics /////////////
        physicsObj = PhysicsObject(withNode: self)
        physicsObj?.restitution = 0.4
        
        sound = ConfigData.read().soundOn
    }
    
    /**
     Constructor which gives choice of lives for Martinio to be instantiated with
    - parameters:
        - x: The x coordinate to spawn Martinio
        - y: The y coordinate to spawn Martinio
        - lives: The number of lives that Martinio has
     */
    convenience init(x: CGFloat, y: CGFloat, lives: Int) {
        self.init(x: x, y: y)

        self.lives = lives
    }
    
    convenience init(x: CGFloat, y: CGFloat, lives: Int, scale: Int, shootable: Bool) {
        self.init(x: x, y: y, lives: lives)
        if (scale > self.scale) {
            grow()
        }
        self.shootable = shootable
        if (shootable) {
            self.texture = SKTexture(imageNamed: "martinioFire.png")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    Called by game scene when Martinio is node1
     
     - parameters:
        - contact: The collision object
     */
    func collision(contact: PhysicsCollision) {
        let node2 = contact.a.node
        if node2 is BreakableBlockSprite { // Break block
            if(((self.physicsObj?.velocity.dy)!) < CGFloat(-30)) {
                let block = node2 as! BreakableBlockSprite
                block.breakBlock()
            }
        } else if node2 is ItemSprite { // Use item and then remove item
            let item = node2 as! ItemSprite
            item.collision(node: self)
            if (sound) {
                let playItemSound = SKAction.playSoundFileNamed("item_collect.wav", waitForCompletion: true)
                self.run(playItemSound)
            }
        } else if node2 is ItemBlockSprite { // Spawn an item
            if((self.physicsObj?.velocity.dy)! < CGFloat(-30)) {
                let block = node2 as! ItemBlockSprite
                block.spawnItem()
            }
        } else if node2 is EndLevelNode { // End the level
            let node = node2 as! EndLevelNode
            node.endLevel()
        } else if node2 is TurtleSprite {
            if ((self.physicsObj?.velocity.dy)!) < CGFloat(-30) { // Must have jumped and must be lower side of block
                let turtle = node2 as! TurtleSprite
                turtle.die()
            } else {
                self.shrink()
            }
        } else if node2 is GorillaSprite {
            let dk = node2 as! GorillaSprite
            if ((self.physicsObj?.velocity.dy)! < CGFloat(-30)) { // Must have jumped and must be lower side of block
                dk.hit()
            } else {
                dk.reset()
                self.shrink()
            }
        }
    }
    
    /**
     Allows Martinio to jump.
     
     Can do single and double jumps
     */
    func jump() {
        let playJumpSound = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: true)
        if((((physicsObj?.velocity.dy.isLessThanOrEqualTo(CGFloat(0.1)))!))) {
            jumpCount = 0
        }
        if (jumpCount == 0 && (physicsObj?.verticalVelocityIsZero())!) {
            if (sound) {
                self.run(playJumpSound)
            }
            jumpCount += 1
            self.physicsObj?.applyForce(dx: 0, dy: 65000)
        } else if (jumpCount == 1 && ((physicsObj?.velocity.dy)! >= CGFloat(0))) {
            if (sound) {
                self.run(playJumpSound)
            }
            self.physicsObj?.applyForce(dx: 0, dy: 40000)
            jumpCount += 1
        }
    }
    
    /**
     Contains the logic for martinio to shoot fire balls
     - parameters:
        - dir: The direction to shoot the fireballs
     */
    func shoot(towardsPoint dir: CGVector) {
        var dx = CGFloat(0)
        if (dir.dx - position.x > 0) {
            dx = 50
        } else {
            dx = -50
        }
        if (sound) {
            let playFireSound = SKAction.playSoundFileNamed("fireball.mp3", waitForCompletion: true)
            self.run(playFireSound)
        }
        let fire = FireEntityItem(x: position.x + dx, y: position.y+20)
        self.parent!.addChild(fire)
        fire.shoot(inDirection: dir)
    }
    
    // Removes object from Physics World as well
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
    }
    
    /**
     Kills Martinio and restarts level of game
     */
    func die() {
        lives -= 1
        if self.scene is GameScene {
            if (sound) {
                let playDeathSound = SKAction.playSoundFileNamed("die.wav", waitForCompletion: true)
                self.run(playDeathSound)
            }
            let game = self.scene as! GameScene
            game.restartLevel(lives: lives)
        }
        self.removeFromParent()
    }
    
    /**
     Get the position of Martinio in the scene
     - returns: `CGPoint` - The position of Martinio
     */
    func getPositionInScene() -> CGPoint {
        return self.convert(self.position, to: scene!)
    }
    
    /**
     Change Martinio into fire costume
     */
    func fireItem() {
        grow()
        if (sound) {
            let playFireSound = SKAction.playSoundFileNamed("fireball.mp3", waitForCompletion: true)
            self.run(playFireSound)
        }
        self.texture = SKTexture(imageNamed: "martinioFire.png")
        shootable = true
    }
    
    /**
     Grow Martinio
     */
    func grow() {
        if (scale==1) {
            let action = SKAction.scale(by: 1.5, duration: 1)
            self.run(action)
            scale += 1
        }
    }
    
    /**
     Shrink Martinio.
     
     Shrinks if Martinio is scaled up, otherwise Martinio dies.
     */
    func shrink() {
        scale -= 1
        shootable = false
        self.texture = SKTexture(imageNamed: "martinio.png")
        if (scale < 1) {
            die()
        } else {
            let action = SKAction.scale(by: 0.67, duration: 1)
            self.run(action)
        }
    }
    
    /**
     Increase the lives of Martinio
     - parameters:
        - amountToInc: The amount to increase lives by
     */
    func incLives(amountToInc: Int) {
        lives += amountToInc
        if (sound) {
            let playDeathSound = SKAction.playSoundFileNamed("item_collect.wav", waitForCompletion: true)
            self.run(playDeathSound)
        }
    }
    
    /**
     Get the number of lives that Martinio has left.
      - returns: `Int` - The number of lives.
     */
    func getLives() -> Int {
        return lives
    }
    
    /**
     Get the speed of the Martinio object
     - returns: `CGFloat` - The speed of Martinio
     */
    func getSpeed() -> CGFloat {
        return MartinioSprite.DEFAULT_MOVE_SPEED * moveSpeedMultiplier
    }
    
    func getWidth() -> Int {
        return width
    }
    
    func getHeight() -> Int {
        return height
    }
    
    func isShootable() -> Bool {
        return shootable
    }
    
    func getScale() -> Int {
        return scale
    }
}
