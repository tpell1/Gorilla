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
    var sceneNode: LevelSelectScene?
    
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

    func playGame() {
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // First do hardcoded levels
                let level1 = LevelScene(title: "Level 1", name: "level")
                let level2 = LevelTwo(title: "Level 2", name: "level")
                var levelArray = [level1, level2]
                
                // Then load in levels from property list
                let loadedLevels = LevelUtils.getLevelArray(fileName: "Levels")
                levelArray.append(contentsOf: loadedLevels)
                
                // Then send the levels to the scene
                sceneNode.setLevelArray(collection: levelArray)
                
                var config = ConfigStruct(currentLevel: 0, currentScore: 0, currentLives: 0)
                if (PropertyListReader.configExistsInDocs()) {
                    config = PropertyListReader.readConfigFromDocs(fileName: "Config")!
                } else {
                    config = PropertyListReader.readConfigFromBundle(fileName: "Config")!
                    PropertyListWriter.writeConfig(fileName: "Config", configData: config)
                }
                sceneNode.setConfigStruct(data: config)
                
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
        if (sceneNode?.playGame ?? false && sceneNode?.gameLevel == 0) {
            playGame()
            timer?.invalidate() // Remove timer once user has pressed play
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
