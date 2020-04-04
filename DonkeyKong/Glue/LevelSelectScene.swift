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
    var gameLevel: Int = -1
    private var lastUpdateTime: TimeInterval = 0
    private var menu : MainMenu?
    private var replace : ReplaceSaveMenu?
    internal var playLbl: SKLabelNode?
    internal var newGameLbl: SKLabelNode?

    // Initial loading of scene, sets up HUD and loads in mario Sprite
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        playLbl = self.childNode(withName: "//PlayLbl") as? SKLabelNode
        newGameLbl = self.childNode(withName: "//NewGameLbl") as? SKLabelNode
        
        mainMenu()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        if (playGame == -1) {
            playGame = menu?.playGame ?? self.playGame
            if (replace?.playGame ?? -1 > -1) {
                playGame = replace!.playGame
            }
        }
        if (gameLevel == -1) {
            gameLevel = menu?.gameLevel ?? self.gameLevel
            if (replace?.gameLevel ?? 0 > 10) {
                gameLevel = replace!.gameLevel
            }
        }
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
    }
    
    func replaceSave() {
        menu?.removeFromParent()
        newGameLbl?.isHidden = true
        playLbl?.text = "Back"
        playGame = -1
        replace = ReplaceSaveMenu()
        replace?.position.y += 0.8*frame.maxY
        self.addChild(replace!)
    }
    
    func mainMenu() {
        playLbl?.text = "Play Game"
        newGameLbl?.isHidden = false
        menu = MainMenu()
        menu?.position.y += 0.8*frame.maxY
        self.addChild(menu!)
    }
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        if (playLbl?.contains(pos) ?? false) {
            if (playLbl?.text == "Back") {
                mainMenu()
            } else {
                playGame = 0
                gameLevel = 0
            }
        } else if (newGameLbl?.contains(pos) ?? false) {
            playGame = 10
            gameLevel = 0
        } else {
            if menu?.parent is LevelSelectScene {
                menu?.touchDown(atPoint: pos)
            } else if replace?.parent is LevelSelectScene {
                replace?.touchDown(atPoint: pos)
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
