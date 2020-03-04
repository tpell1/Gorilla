//
//  GameScene.swift
//  DonkeyKong
//
//  Created by Travis Pell on 17/10/2019.
//  Copyright © 2019 Travis Pell. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var marioSprite : MarioSprite?
    private var blockSprite : BlockSprite?
    private var leftArrow : SKShapeNode?
    private var rightArrow : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        leftArrow = self.childNode(withName: "//leftArrow") as? SKShapeNode
        rightArrow = self.childNode(withName: "//rightArrow") as? SKShapeNode
        
        marioSprite = MarioSprite(x: frame.midX, y: frame.midY)
        self.addChild((marioSprite)!)
        
        let solidBlock = SKShapeNode()
        solidBlock.path = UIBezierPath(roundedRect: CGRect(x: frame.midX, y: frame.midY - 520, width: 50, height: 50), cornerRadius: 1).cgPath
        solidBlock.position = CGPoint(x: frame.midX, y: frame.midY)
        solidBlock.fillColor = UIColor.brown
        solidBlock.lineWidth = 7
        solidBlock.physicsBody = SKPhysicsBody(edgeChainFrom: solidBlock.path!)
        solidBlock.physicsBody?.restitution = 0.4
        solidBlock.physicsBody?.isDynamic = false
        self.addChild(solidBlock)
        
        blockSprite = BlockSprite(x: frame.midX + 50, y: frame.midY - 520, imageNamed: "brickBlock.png")
        self.addChild(blockSprite!)
		
        
        let ground = SKShapeNode()
        ground.path = UIBezierPath(roundedRect: CGRect(x: frame.minX, y: 0, width: frame.maxX * 2, height: 20), cornerRadius: 1).cgPath
        ground.position = CGPoint(x: frame.midX, y: frame.minY)
        ground.fillColor = UIColor.green
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.2
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if (marioSprite?.contains(pos))! {
            marioSprite?.jump()
        } else if (leftArrow?.contains(pos))! {
            marioSprite?.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 0))
        } else if (rightArrow?.contains(pos))! {
            marioSprite?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 0))
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
