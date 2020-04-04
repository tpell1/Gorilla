//
//  GameViewController.swift
//  DonkeyKong
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
    var sceneNode: LevelSelectScene?
    var gameNode: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GKScene(fileNamed: "LevelSelectScene") {
            
            if scene.rootNode is LevelSelectScene? {
                sceneNode = scene.rootNode as! LevelSelectScene?
                sceneNode?.entities = scene.entities
                sceneNode?.graphs = scene.graphs
                
                sceneNode?.scaleMode = .aspectFill
                
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode!)
                    view.ignoresSiblingOrder = true
                    
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

    func playGame(newGame: Bool = false, saveGame: Int = 0) {
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
                let level1 = LevelScene(title: "Level 1", name: "level")
                let level2 = LevelTwo(title: "Level 2", name: "level")
                var levelArray = [level1, level2]
                
                // Then load in levels from property list
                let loadedLevels = LevelUtils.getLevelArray()
                levelArray.append(contentsOf: loadedLevels)
                
                // Then send the levels to the scene
                gameNode?.setLevelArray(collection: levelArray)
                
                timer1 = Timer(timeInterval: 0.1, target: self, selector: #selector(self.updateGame), userInfo: nil, repeats: true)
                RunLoop.current.add(timer1!, forMode: .commonModes)
                
                if (newGame) {
                    let saveData = SaveData(saveName: "Config" + String(SaveData.getNumberOfSaves()))
                    saveData.writeConfig(level: 1, lives: 3, score: 0)
                    gameNode?.setSave(data: saveData)
                } else {
                    if (saveGame == 0) {
                        let saveData = SaveData()
                        gameNode?.setSave(data: saveData)
                    } else {
                        let saveData = SaveData(saveName: "Config" + String(saveGame))
                        gameNode?.setSave(data: saveData)
                    }
                    
                }
                
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    // Function called by timer ever 0.1s, checks if user has pressed play
    @objc func update() {
        if (sceneNode?.playGame != -1 && sceneNode?.gameLevel == 0) {
            if (sceneNode!.playGame == 10) {
                if (SaveData.getNumberOfSaves()<5) {
                    playGame(newGame: true)
                    timer?.invalidate() // Remove timer once user has pressed play
                } else {
                    //TODO: Replace_save menu
                    sceneNode?.replaceSave()
                }
            } else if (sceneNode!.playGame == 20) {
                let i = sceneNode!.gameLevel - 20
                playGame(newGame: true, saveGame: i)
                timer?.invalidate() // Remove timer once user has pressed play
            } else {
                playGame(newGame: false, saveGame: sceneNode?.playGame ?? 0)
                timer?.invalidate() // Remove timer once user has pressed play
            }
        }
    }
    
    @objc func updateGame() {
        if (gameNode?.getStatus() == GameStatus.QUIT) {
            viewDidLoad()
            timer1?.invalidate()
        } else if (gameNode?.getStatus() == GameStatus.FINISHED) {
            viewDidLoad()
            timer1?.invalidate()
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
