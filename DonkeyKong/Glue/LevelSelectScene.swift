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
    private var playLbl: SKLabelNode?
    private var newGameLbl: SKLabelNode?
    private var saveArray: [SKLabelNode] = []
    
    // Initial loading of scene, sets up HUD and loads in mario Sprite
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        playLbl = self.childNode(withName: "//PlayLbl") as? SKLabelNode
        playLbl?.text = "Play last save"
        
        newGameLbl = self.childNode(withName: "//NewGameLbl") as? SKLabelNode
        
        for i in 1...SaveData.getNumberOfSaves() {
            let saveLbl = SKLabelNode(text: "Save " + String(i))
            saveLbl.position = CGPoint(x: frame.midX, y: (frame.midY + 0.3*frame.height)-30*CGFloat(i))
            saveLbl.name = String(i)
            self.addChild(saveLbl)
            saveArray.append(saveLbl)
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
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
    }
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        if (playLbl?.contains(pos) ?? false) {
            playGame = 0
            gameLevel = 0
        } else if (newGameLbl?.contains(pos) ?? false) {
            playGame = 10
            gameLevel = 0
        }
        
        for i in 0...(saveArray.count-1) {
            if (saveArray[i].contains(pos)) {
                playGame = i
            }
        }
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
