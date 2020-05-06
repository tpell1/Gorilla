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
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "flag.jpg")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: 30, height: 150))
        self.position = CGPoint(x: x, y: y)
        self.physicsObj = PhysicsObject(withNode: self, mass: -1)
        self.physicsObj?.solveCollisions = false
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
        let lbl = SKLabelNode(attributedText: NSAttributedString(string: "Level Complete!"))
        lbl.position = CGPoint(x: frame.midX, y: frame.midY)
        let sceneGame = gameScene!
        sceneGame.addChild(lbl)
        sceneGame.getLevel()?.completeLevel()
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
    }
}
