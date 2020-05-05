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
import Physics

/**
 Represents the main character of the game.
 
 Contains parts of the collision logic, delegated to by `PhysicsHandler`. And also has the game logic which allows mario to move, jump, and die.
 */
class MarioSprite : SKSpriteNode {
    private var jumpCount = 0
    private var lives = 1
    private var moveSpeedMultiplier: CGFloat = 1
    private var health = 1
    private var width = 45
    private var height = 55
    private var scale = 1
    private var shootable = true
    private var jumpSound = true
    static var DEFAULT_MOVE_SPEED: CGFloat = 100
    
    /**
     Default constructor, creates a main character with one life
     - parameters:
        - x: The x coordinate to spawn Mario
        - y: The y coordinate to spawn Mario
     */
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "mario.png") // Use the mario texture
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        
        ////////// My Physics /////////////
        physicsObj = PhysicsObject(withNode: self)
        
        jumpSound = ConfigData.read().SoundOn
    }
    
    /**
     Constructor which gives choice of lives for Mario to be instantiated with
    - parameters:
        - x: The x coordinate to spawn Mario
        - y: The y coordinate to spawn Mario
        - lives: The number of lives that Mario has
     */
    convenience init(x: CGFloat, y: CGFloat, lives: Int) {
        self.init(x: x, y: y)

        self.lives = lives
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    Called by game scene when Mario is node1
     
     - parameters:
        - contact: The collision object
     */
    func collision(contact: PhysicsCollision) {
        if (contact.manifold.b.node != nil) {
            let node2 = contact.manifold.a.node
            if node2 is BreakableBlockSprite { // Break block
                if(((self.physicsObj?.physicsBody.velocity.dy)!) < CGFloat(-20)) {
                    let block = node2 as! BreakableBlockSprite
                    block.breakBlock()
                }
            } else if node2 is ItemSprite { // Use item and then remove item
                let item = node2 as! ItemSprite
                item.collision(node: self)
            } else if node2 is ItemBlockSprite { // Spawn an item
                if((self.physicsObj?.physicsBody.velocity.dy)! < CGFloat(-20)) {
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
    
    /**
     Allows Mario to jump.
     
     Can do single and double jumps
     */
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
            self.physicsObj?.applyForce(dx: 0, dy: 65000)
        } else if (jumpCount == 1 && ((physicsObj?.physicsBody.velocity.dy)! >= CGFloat(0))) {
            if (jumpSound) {
                self.run(playJumpSound)
            }
            self.physicsObj?.applyForce(dx: 0, dy: 40000)
            jumpCount += 1
        }
    }
    
    /**
     Contains the logic for mario to shoot fire balls
     - parameters:
        - dir: The direction to shoot the fireballs
     */
    func shoot(direction dir: CGVector) {
        
        let fire = FireEntityItem(x: getPositionInScene().x, y: getPositionInScene().y)
        self.addChild(fire)
        fire.shoot(inDirection: dir, toNode: (self.parent)!)
    }
    
    // Removes object from Physics World as well
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
    }
    
    /**
     Kills Mario and restarts level of game
     */
    func die() {
        lives -= 1
        if self.scene is GameScene {
            let game = self.scene as! GameScene
            game.restartLevel(lives: lives)
        }
        self.removeFromParent()
    }
    
    /**
     Get the position of Mario in the scene
     - returns: `CGPoint` - The position of Mario
     */
    func getPositionInScene() -> CGPoint {
        return self.convert(self.position, to: scene!)
    }
    
    /**
     Change Mario into fire costume
     */
    func fireItem() {
        grow()
        self.texture = SKTexture(imageNamed: "marioFire.png")
        self.scale(to: CGSize(width: width, height: height))
        shootable = true
    }
    
    /**
     Grow Mario
     */
    func grow() {
        scale = 2
        reDo()
    }
    
    /**
     Shrink Mario.
     
     Shrinks if Mario is scaled up, otherwise Mario dies.
     */
    func shrink() {
        scale -= 1
        if (scale < 1) {
            die()
        }
        reDo()
    }
    
    /**
     Increase the lives of Mario
     - parameters:
        - amountToInc: The amount to increase lives by
     */
    func incLives(amountToInc: Int) {
        lives += amountToInc
    }
    
    /**
     Get the number of lives that Mario has left.
      - returns: `Int` - The number of lives.
     */
    func getLives() -> Int {
        return lives
    }
    
    /**
     Get the speed of the Mario object
     - returns: `CGFloat` - The speed of Mario
     */
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
