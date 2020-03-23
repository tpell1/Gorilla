//
//  GameScene.swift
//  DonkeyKong
//
//  Created by Travis Pell on 17/10/2019.
//  Copyright © 2019 Travis Pell. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    internal var lastUpdateTime : TimeInterval = 0
    internal var marioSprite : MarioSprite?
    private var blockSprite : BlockSprite?
    private var breakableBlock : BreakableBlockSprite?
    private var itemBlock : ItemBlockSprite?
    private var levelArray: [LevelScene]?
    private var level : LevelScene?
    private var levelIndex : Int = 0
    internal var leftArrow : SKShapeNode?
    internal var rightArrow : SKShapeNode?
    internal var livesLbl : SKLabelNode?
    private var levelLbl : SKLabelNode?
    internal var nameNode : SKNode?
    private var relativeNode : SKNode?
    private var endNode : EndOfLevelNode?
    private var safetyBool : Bool = true
    internal var ground : SKShapeNode?
    
    // Initial loading of scene, sets up HUD and loads in mario Sprite
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        physicsWorld.contactDelegate = self
        
        setupLevel(lives: 1)
    }
    
    // Sets up UI stuff required for all levels (Mario, HUD, etc)
    func setupLevel(lives: Int) {
        //Initial HUD, load from sks file
        leftArrow = self.childNode(withName: "//leftArrow") as? SKShapeNode
        rightArrow = self.childNode(withName: "//rightArrow") as? SKShapeNode
        livesLbl = self.childNode(withName: "//livesLbl") as? SKLabelNode
        nameNode = self.childNode(withName: "//node")
        
        print("Frame x: " + String(describing: frame.minX))
        
        // Remove all parts of previous level (no error if level one)
        self.childNode(withName: "ground")?.removeFromParent()
        level?.removeFromParent()
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5) // Making the coordinates consistant accross all levels
        relativeNode = SKNode() // Used for centering on Mario
        relativeNode?.position = anchorPoint
        
        // Create the floor
        // TODO: Move into LevelScene class
        ground = SKShapeNode()
        ground?.path = UIBezierPath(roundedRect: CGRect(x: frame.minX - frame.maxX, y: 0, width: frame.maxX * 5, height: 20), cornerRadius: 1).cgPath
        ground?.position = CGPoint(x: frame.midX, y: frame.minY)
        ground?.fillColor = UIColor.green
        ground?.lineWidth = 5
        ground?.physicsBody = SKPhysicsBody(edgeChainFrom: (ground?.path!)!)
        ground?.physicsBody?.restitution = 0.2
        ground?.physicsBody?.isDynamic = false
        ground?.name = "ground"
        self.addChild(ground!)
        
        // Spawn in mario
        marioSprite = MarioSprite(x: frame.midX - frame.maxX, y: frame.midY, lives: lives)
        self.addChild((marioSprite)!)
        
        // Display to user what level they are on
        levelLbl = SKLabelNode(text: "Level: ")
        levelLbl?.name = "levelLbl"
        levelLbl?.position.y = frame.maxY - 80
        self.addChild(levelLbl!)
        
        self.setHUD()
    }
    
    // Loads a level into the scene
    func setLevel(level: LevelScene) {
        self.levelIndex = 0
        self.level = level
        level.setFrame(frameRect: frame)
        level.addChildren()
        self.addChild(level)
        levelLbl?.text = "Level: " + level.getTitle()
    }
    
    func setLevel(index: Int) {
        levelIndex = index
        self.level = levelArray?[index]
        level?.setFrame(frameRect: frame)
        level?.addChildren()
        self.addChild(level!)
        levelLbl?.text = "Level: " + (level?.getTitle())!
    }
    
    func getLevel() -> LevelScene? {
        return level
    }
    
    func getLevelIndex() -> Int {
        return levelIndex
    }
    
    func setLevelArray(collection: Array<LevelScene>) {
        self.levelArray = collection
        setLevel(index: 0)
    }
    
    // Restarts the scene and loads in the next level
    func nextLevel(level: LevelScene) {
        setupLevel(lives: (marioSprite?.getLives())!)
        setLevel(level: level)
    }
    
    func nextLevel(index: Int) {
        levelLbl?.removeFromParent()
        self.childNode(withName: "Mario")?.removeFromParent()
        setupLevel(lives: (marioSprite?.getLives())!)
        setLevel(index: index)
        safetyBool = true
    }
    
    // Calculates the next level from a list of levels
    // if no list then return to main menu
    func loadNextLevel() {
        if ((levelArray?.count)! > levelIndex) {
            nextLevel(index: levelIndex + 1)
        } else {
            // TODO: Main menu
        }
    }
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        if (marioSprite?.contains(pos))! {
            marioSprite?.jump()
        } else if (leftArrow?.contains(pos))! {
            //marioSprite?.physicsBody?.applyImpulse(CGVector(dx: -1, dy: 0))
            marioSprite?.physicsBody?.velocity.dx = -MarioSprite.MOVE_SPEED
        } else if (rightArrow?.contains(pos))! {
            //marioSprite?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
            marioSprite?.physicsBody?.velocity.dx = MarioSprite.MOVE_SPEED
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if (leftArrow?.contains(pos))! {
            //marioSprite?.physicsBody?.applyImpulse(CGVector(dx: -1, dy: 0))
            marioSprite?.physicsBody?.velocity.dx = -MarioSprite.MOVE_SPEED
        } else if (rightArrow?.contains(pos))! {
            //marioSprite?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
            marioSprite?.physicsBody?.velocity.dx = MarioSprite.MOVE_SPEED
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if (leftArrow?.contains(pos))! {
            marioSprite?.physicsBody?.velocity.dx = 0
        } else if (rightArrow?.contains(pos))! {
            marioSprite?.physicsBody?.velocity.dx = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // ======== Collision detection =======================
    
    // Contact handler
    func didBegin(_ contact: SKPhysicsContact) {
        var item : ItemSprite?
        if let node1 = contact.bodyA.node { // Prevents an error from being called with sprites that remove themselves from parent
            if node1 is ItemSprite {
                let node2 = contact.bodyB.node!
                if node2 is MarioSprite {
                    let mario = node2 as! MarioSprite
                    item = node1 as! ItemSprite
                    item?.collision(mario: mario)
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
            } else if node1 is MarioSprite {
                let mario = node1 as! MarioSprite
                mario.collision(contact: contact) // Mario can handle collisions himself
            }
            livesLbl?.text = String(describing: marioSprite?.getLives())
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        if ((level?.isCompleted())! && safetyBool) {
            safetyBool = false
            loadNextLevel()
        }
        
        if ((marioSprite?.position.y)! < frame.minY) {
            marioSprite?.die()
        }
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.anchorPoint.x = -(2*(self.convert((marioSprite?.position)!, to: relativeNode!).x) - self.convert(CGPoint(x: frame.maxX, y: 0), to: relativeNode!).x)/900
        self.setHUD()
        self.lastUpdateTime = currentTime
    }
    
    // Restart level when mario is killed
    func restartLevel(lives: Int) {
        let groundRectPointer = UnsafeMutablePointer<CGRect>.allocate(capacity: 1) // Get a pointer to the rectangle that represents the ground
        if (ground?.path?.isRect(groundRectPointer))! { // Makes sure it is a rectangle
            marioSprite = MarioSprite(x: groundRectPointer.pointee.minX + 400, y: frame.midY, lives: lives) // Reinstantiate mario but with one less life, back at the start of the level
        } else {
            marioSprite = MarioSprite(x: frame.midX - frame.maxX, y: frame.midY, lives: lives)
        }
        self.addChild((marioSprite)!) // Spawn mario
    }
    
    // Reset positions when frame moves
    // Ensures HUD is at some position of screen at all times
    func setHUD() {
        leftArrow?.position.x = frame.minX + 70
        rightArrow?.position.x = frame.maxX - 60
        livesLbl?.position.x = frame.minX + 80
        levelLbl?.position.x = frame.midX
    }
}
