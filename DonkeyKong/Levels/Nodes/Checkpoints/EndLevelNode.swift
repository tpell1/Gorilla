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

class EndLevelNode : SKSpriteNode {
    private var levelComplete = false;
    
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "flag.jpg")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: 30, height: 150))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: 10, height: 60))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Gets gamescene and then ends the level
    // TODO: Implement without getting GameScene
    func endLevel() {
        let lbl = SKLabelNode(attributedText: NSAttributedString(string: "Level Complete!"))
        lbl.position = CGPoint(x: frame.midX, y: frame.midY)
        if self.scene! is GameScene {
            let gameScene = scene as! GameScene
            gameScene.addChild(lbl)
            gameScene.getLevel()?.completeLevel()
        }
    }
}
