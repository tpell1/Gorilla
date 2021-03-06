//
//  GameViewController.swift
//  Gorilla
//
//  Created by Travis Pell on 17/10/2019.
//  Copyright © 2019 Travis Pell. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var timer: Timer?
    var timer1: Timer?
    var sceneNode: MenuScene?
    var gameNode: GameScene?
    var overNode: GameOverScene?
    var currentSave : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GKScene(fileNamed: "MenuScene") {
            
            if scene.rootNode is MenuScene? {
                sceneNode = scene.rootNode as! MenuScene?
                sceneNode?.entities = scene.entities
                sceneNode?.graphs = scene.graphs
                
                sceneNode?.scaleMode = .aspectFill
                
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode!)
                    view.ignoresSiblingOrder = true
                    
                    // Start timer which checks the main menus status
                    timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer!, forMode: .commonModes)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate() // Memory management
    }

    func playGame(newGame: Bool = false, saveGame: Int = -1) {
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                gameNode = sceneNode
                // Copy gameplay related content over to the scene
                gameNode?.entities = scene.entities
                gameNode?.graphs = scene.graphs
                
                // First do hardcoded levels
                //let level1 = LevelScene(title: "Level 1", name: "level")
                //let level2 = LevelTwo(title: "Level 2", name: "level")
                //var levelArray = [] // Not using hardcoded levels anymore
                
                // Then load in levels from property list
                let loadedLevels = LevelUtils.getLevelArray()
                //levelArray.append(contentsOf: loadedLevels)
                
                // Then send the levels to the scene
                gameNode?.setLevelArray(collection: loadedLevels)
                gameNode?.resetStatus()
                // Starts game update loop, called every 10th of a second, used to process and evaluate current game state
                self.timer1 = Timer(timeInterval: 0.1, repeats: true, block: updateGame)

                RunLoop.current.add(timer1!, forMode: .commonModes)
                
                // Loads or creates new game
                if (newGame) {
                    if (saveGame == -1) {
                        let saveData = SaveData(saveName: "Save" + String(SaveData.getNumberOfSaves()))
                        saveData.writeSave(level: 1, lives: 3, score: 0)
                        gameNode?.setSave(data: saveData)
                        currentSave = SaveData.getNumberOfSaves()
                    } else {
                        let saveData = SaveData(saveName: "Save" + String(saveGame))
                        saveData.writeSave(level: 1, lives: 3, score: 0)
                        gameNode?.setSave(data: saveData)
                        currentSave = saveGame
                    }
                } else {
                    let saveData = SaveData(saveName: "Save" + String(saveGame))
                    currentSave = saveGame
                    gameNode?.setSave(data: saveData)
                }
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }
    
    func showGameOverScene(dead: Bool = false) {
        if let scene = GKScene(fileNamed: "GameOverScene") {
            if let sceneNode = scene.rootNode as! GameOverScene? {
                
                overNode = sceneNode
                self.timer1 = Timer(timeInterval: 0.1, repeats: true, block: updateGameOverScreen)
                RunLoop.current.add(timer1!, forMode: .commonModes)
                if (dead) {
                    overNode?.isGameCompleted(true: false)
                } else {
                    overNode?.isGameCompleted(true: true)
                }
                
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }
    
    @objc func updateGameOverScreen(timer : Timer) {
        let status = overNode?.status
        if (status != MenuStatus.WAITING) {
            playGame(newGame: true, saveGame: currentSave)
            timer.invalidate()
        }
    }
    
    // Function called by timer ever 0.1s, checks if user has pressed play
    @objc func update() {
        let status = sceneNode?.menuStatus
        if (status != MenuStatus.WAITING && status != MenuStatus.NEW_GAME_WAITING && status != MenuStatus.OPTIONS) {
            if (status == MenuStatus.CONTINUE_SAVE) {
                playGame(newGame: false, saveGame: sceneNode?.saveNumber ?? 0)
                timer?.invalidate()
                timer = nil
            } else if (status == MenuStatus.NEW_SAVE) {
                playGame(newGame: true)
                timer?.invalidate()
                timer = nil
            } else if (status == MenuStatus.REPLACE_SAVE) {
                playGame(newGame: true, saveGame: sceneNode?.saveNumber ?? 0)
                timer?.invalidate()
                timer = nil
            } else {
                return
            }
            sceneNode?.menuStatus = MenuStatus.WAITING
        }
    }
    
    // Game update loop, checking status of current game
    @objc func updateGame(timer : Timer) {
        if (gameNode?.getStatus() == GameStatus.QUIT) {
            gameNode?.resetStatus()
            gameNode?.removeAllActions()
            gameNode = nil
            viewDidLoad()
            timer.invalidate()
        } else if (gameNode?.getStatus() == GameStatus.FINISHED) {
            gameNode?.resetStatus()
            gameNode?.removeAllActions()
            gameNode = nil
            showGameOverScene()
            timer.invalidate()
        } else if (gameNode?.getStatus() == GameStatus.DEAD) {
            gameNode?.resetStatus()
            gameNode?.removeAllActions()
            gameNode = nil
            showGameOverScene(dead: true)
            timer.invalidate()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
