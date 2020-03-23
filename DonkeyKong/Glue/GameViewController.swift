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
                    
                    timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
                let level1 = LevelScene(title: "Level 1")
                let level2 = LevelTwo(title: "Level 2")
                
                let levelArray = [level1, level2]
                sceneNode.setLevelArray(collection: levelArray)
                
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
    
    @objc func update() {
        if (sceneNode?.playGame ?? false && sceneNode?.gameLevel == 0) {
            playGame()
            timer?.invalidate()
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
