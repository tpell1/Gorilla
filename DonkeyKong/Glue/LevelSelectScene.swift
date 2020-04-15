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

enum LevelSelectStatus {
    case NEW_SAVE, NEW_GAME_WAITING, CONTINUE_SAVE, REPLACE_SAVE, WAITING
}

class LevelSelectScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var levelStatus: LevelSelectStatus = LevelSelectStatus.WAITING
    var gameLevel: Int = -1
    var saveNumber: Int = -1
    private var lastUpdateTime: TimeInterval = 0
    private var menu : MainMenu?
    private var replace : ReplaceSaveMenu?
    private var previousState : LevelSelectStatus = LevelSelectStatus.WAITING
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
        

        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        if (levelStatus != previousState) {
            previousState = levelStatus
            
            if (levelStatus == LevelSelectStatus.WAITING) {
                mainMenu()
            } else if (levelStatus == LevelSelectStatus.NEW_GAME_WAITING) {
                replaceSave()
            }
        } else {
            if (levelStatus == LevelSelectStatus.WAITING) {
                levelStatus = menu?.status ?? LevelSelectStatus.WAITING
                saveNumber = menu?.saveNumber ?? -1
            } else if (levelStatus == LevelSelectStatus.NEW_GAME_WAITING) {
                levelStatus = replace?.status ?? LevelSelectStatus.NEW_GAME_WAITING
                saveNumber = replace?.saveNumber ?? -1
            }
        }
    }
    
    // Show the replace save menu
    func replaceSave() {
        menu?.removeFromParent()
        newGameLbl?.isHidden = true
        playLbl?.text = "Back"
        levelStatus = LevelSelectStatus.NEW_GAME_WAITING
        replace = ReplaceSaveMenu()
        replace?.position.y += 0.8*frame.maxY
        self.addChild(replace!)
    }
    
    // Show the main menu
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
                levelStatus = LevelSelectStatus.CONTINUE_SAVE
                gameLevel = 0
            }
        } else if (newGameLbl?.contains(pos) ?? false) {
            if (SaveData.getNumberOfSaves() >= SaveData.MAX_AMOUNT_OF_SAVES) {
                levelStatus = LevelSelectStatus.NEW_GAME_WAITING
                gameLevel = 0
            } else {
                levelStatus = LevelSelectStatus.NEW_SAVE
            }
        } else { // Checks through currently used menu if user did not press on the button
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
