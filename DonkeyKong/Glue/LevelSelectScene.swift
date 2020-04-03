//
//  LevelSelectScene.swift
//  DonkeyKong
//
//  Created by Travis Pell on 23/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class LevelSelectScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var playGame: Int = -1
    var gameLevel: Int = 0
    private var lastUpdateTime: TimeInterval = 0
    private var menu : MainMenu?

    // Initial loading of scene, sets up HUD and loads in mario Sprite
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        let play = self.childNode(withName: "//PlayLbl") as? SKLabelNode
        let new = self.childNode(withName: "//NewGameLbl") as? SKLabelNode

        menu = MainMenu(playGameLabel: play!, newGameLabel: new!)
        menu?.position.y += 0.5*frame.maxY
        self.addChild(menu!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        playGame = menu?.playGame ?? -1
        gameLevel = menu?.gameLevel ?? 0
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
    }
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        menu?.touchDown(atPoint: pos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
