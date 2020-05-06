//
//  EndLevelNode.swift
//  DonkeyKong
//
//  End of the level, ends the level when Mario touches it
//  Represented by a flag and flag pole
//
//  Created by Travis Pell on 14/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

class EndLevelNode : SKSpriteNode {
    private var levelComplete = false;
    private var gameScene : GameScene?
    private var flagSprite : SKSpriteNode
    
    init(x: CGFloat, y: CGFloat) {
        flagSprite = SKSpriteNode(imageNamed: "flag.png")
        let texture = SKTexture(imageNamed: "flagpole.png")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: 40, height: 150))
        self.position = CGPoint(x: x, y: y)
        self.physicsObj = PhysicsObject(withNode: self, mass: -1)
        self.physicsObj?.solveCollisions = false
        flagSprite.scale(to: CGSize(width: 30, height: 30))
        flagSprite.position.y += 60
        flagSprite.position.x += 17
        flagSprite.zPosition = 15
        self.addChild(flagSprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScene(scene : GameScene) {
        self.gameScene = scene
    }
    
    // Gets gamescene and then ends the level
    // TODO: Implement without getting GameScene
    func endLevel() {
        if (!levelComplete) {
            levelComplete = true
            let lbl = SKLabelNode(attributedText: NSAttributedString(string: "Level Complete!"))
            lbl.position = CGPoint(x: frame.midX, y: frame.midY)
            gameScene?.addChild(lbl)
            
            let action = SKAction.moveBy(x: 0, y: -70, duration: 3)
            flagSprite.run(action, completion: completeLevel)
        }
    }
    
    func completeLevel() {
        gameScene?.getLevel()?.completeLevel()
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
    }
}
