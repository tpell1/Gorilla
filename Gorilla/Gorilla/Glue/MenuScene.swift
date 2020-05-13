//
//  LevelSelectScene.swift
//  Gorilla
//
//  Created by Travis Pell on 23/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum MenuStatus {
    case NEW_SAVE, NEW_GAME_WAITING, CONTINUE_SAVE, REPLACE_SAVE, WAITING, OPTIONS
}

class MenuScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var menuStatus: MenuStatus = MenuStatus.WAITING
    private var previousState : MenuStatus = MenuStatus.WAITING

    var saveNumber: Int = -1
    private var lastUpdateTime: TimeInterval = 0
    
    private var menu : MainMenu?
    private var replace : ReplaceSaveMenu?
    private var options : OptionsMenu?
    internal var playLbl: SKLabelNode?
    internal var newGameLbl: SKLabelNode?

    // Initial loading of scene
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        playLbl = self.childNode(withName: "//PlayLbl") as? SKLabelNode
        newGameLbl = self.childNode(withName: "//NewGameLbl") as? SKLabelNode
        
        playLbl?.text = "Options"
        menu = MainMenu()
        menu?.position.y += 0.8*frame.maxY

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
        
        if (menuStatus != previousState) {
            previousState = menuStatus
            
            if (menuStatus == MenuStatus.WAITING) {
                mainMenu()
            } else if (menuStatus == MenuStatus.NEW_GAME_WAITING) {
                replaceSave()
            } else if (menuStatus == MenuStatus.OPTIONS) {
                optionsMenu()
            }
        } else {
            if (menuStatus == MenuStatus.WAITING) {
                menuStatus = menu?.status ?? MenuStatus.WAITING
                saveNumber = menu?.saveNumber ?? -1
            } else if (menuStatus == MenuStatus.NEW_GAME_WAITING) {
                menuStatus = replace?.status ?? MenuStatus.NEW_GAME_WAITING
                saveNumber = replace?.saveNumber ?? -1
            }
        }
    }
    
    // Show the replace save menu
    func replaceSave() {
        menu?.removeFromParent()
        newGameLbl?.isHidden = true
        playLbl?.text = "Back"
        menuStatus = MenuStatus.NEW_GAME_WAITING
        replace = ReplaceSaveMenu()
        replace?.position.y += 0.8*frame.maxY
        self.addChild(replace!)
    }
    
    // Show the main menu
    func mainMenu() {
        options?.removeFromParent()
        replace?.removeFromParent()
        menu?.removeFromParent()
        playLbl?.text = "Options"
        newGameLbl?.isHidden = false
        menuStatus = MenuStatus.WAITING
        self.addChild(menu!)
    }
    
    func optionsMenu() {
        menu?.removeFromParent()
        newGameLbl?.isHidden = true
        playLbl?.text = "Back"
        menuStatus = MenuStatus.OPTIONS
        options = OptionsMenu()
        //options?.position.y += 0.8*frame.maxY
        self.addChild(options!)
    }
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        if (playLbl?.contains(pos) ?? false) {
            if (playLbl?.text == "Back") {
                if (menuStatus == MenuStatus.OPTIONS) {
                    options?.writeConfig()
                }
                mainMenu()
            } else {
                menuStatus = MenuStatus.OPTIONS
            }
        } else if (newGameLbl?.contains(pos) ?? false) {
            if (SaveData.getNumberOfSaves() >= SaveData.MAX_AMOUNT_OF_SAVES) {
                menuStatus = MenuStatus.NEW_GAME_WAITING
            } else {
                menuStatus = MenuStatus.NEW_SAVE
            }
        } else { // Checks through currently used menu if user did not press on the button
            if menu?.parent is MenuScene {
                menu?.touchDown(atPoint: pos)
            } else if replace?.parent is MenuScene {
                replace?.touchDown(atPoint: pos)
            } else if options?.parent is MenuScene {
                options?.touchDown(atPoint: pos)
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
