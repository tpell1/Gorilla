//
//  GameScene.swift
//  Gorilla
//
//  Created by Travis Pell on 17/10/2019.
//  Copyright © 2019 Travis Pell. All rights reserved.
//

import SpriteKit
import GameplayKit
import Physics
import AVFoundation

public enum GameStatus {
     case PLAYING, PAUSED, QUIT, FINISHED, DEAD
}

class GameScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    internal var martinioSprite : MartinioSprite?
    private var levelArray: [LevelScene]?
    private var level : LevelScene?
    private var saveData : SaveData?
    private var save : SaveStruct?
    
    internal var leftArrow : SKShapeNode?
    internal var rightArrow : SKShapeNode?
    private var jumpBtn : SKShapeNode?
    internal var livesLbl : SKLabelNode?
    private var levelLbl : SKLabelNode?
    private var dkLbl : SKLabelNode?
    private var pauseBtn : SKShapeNode?
    internal var nameNode : SKNode?
    private var relativeNode : SKNode?
    private var pauseNode : PauseMenu?

    internal var lastUpdateTime : TimeInterval = 0
    private var timer : Timer?
    private var safetyBool : Bool = true
    private var music : Bool = true
    private var gameStatus : GameStatus = GameStatus.PLAYING
    private var levelIndex : Int = 0
    private var physics : PhysicsWorld?
    private var musicPlayer : AVAudioPlayer?
    
    
    // Initial loading of scene, sets up HUD and loads in martinio Sprite
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        music = ConfigData.read().musicOn
        if (music) {
            playMusic()
        }
        gameStatus = GameStatus.PLAYING
    }
    
    func playMusic() {
        let path = Bundle.main.path(forResource: "music.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.play()
        } catch {
            print("couldnt play music")
        }
    }
    
    // Called after sceneDidLoad(), allows config to be read and the levels list
    override func didMove(to view: SKView) {
        save = saveData?.read()
        setupLevel(lives: save!.currentLives)
        setLevel(index: (save?.currentLevel)! - 1)
    }
    
    // Sets up UI stuff required for all levels (Martinio, HUD, etc)
    func setupLevel(lives: Int, scale: Int = 1, shootable: Bool = false) {
        //Initial HUD, load from sks file
        leftArrow = self.childNode(withName: "//leftArrow") as? SKShapeNode
        rightArrow = self.childNode(withName: "//rightArrow") as? SKShapeNode
        livesLbl = self.childNode(withName: "//livesLbl") as? SKLabelNode
        nameNode = self.childNode(withName: "//node")
        pauseBtn = self.childNode(withName: "//pauseBtn") as? SKShapeNode
        jumpBtn = self.childNode(withName: "//jumpBtn") as? SKShapeNode
        dkLbl = self.childNode(withName: "//dkLbl") as? SKLabelNode
        dkLbl?.isHidden = true

        // Remove all parts of previous level (no error if level one)
        level?.removeFromParent()
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5) // Making the coordinates consistant accross all levels
        relativeNode = SKNode() // Used for centering on Martinio
        relativeNode?.position = anchorPoint
        
        pauseNode = PauseMenu(phoneFrame: frame) // Used for pause menu (contains all required buttons etc.)
        pauseNode?.zPosition = 10

        // Spawn in martinio
        martinioSprite = MartinioSprite(x: frame.midX - frame.maxX, y: frame.midY, lives: lives, scale: scale, shootable: shootable)
        self.addChild((martinioSprite)!)
        
        // Display to user what level they are on
        levelLbl = SKLabelNode(text: "Level: ")
        levelLbl?.name = "levelLbl"
        levelLbl?.position.y = frame.maxY - 80
        self.addChild(levelLbl!)
        
        self.setHUD()
    }
    
    // Loads a level into the scene
    func setLevel(index: Int) {
        let physicsHandler = PhysicsHandler()
        physics = PhysicsWorld()
        physics?.setCollisionHandler(asObj: physicsHandler)
        
        levelIndex = index
        self.level = levelArray?[index]
        level?.setFrame(frameRect: frame)
        level?.addChildren()
        martinioSprite?.move(toParent: level!)
    
        for child in level!.children {
            if child is EndLevelNode {
                let endLevel = child as! EndLevelNode
                endLevel.setScene(scene: self)
            }
            if child.physicsObj != nil {
                physics?.addObject(object: child.physicsObj!)
            }
        }
        //physics?.addNodes(collection: level!.children)
        self.addChild(level!)
        levelLbl?.text = (level?.getTitle())!
        
        if (level?.name == "boss_level") {
            timer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
            dkLbl?.isHidden = false
            level?.childNode(withName: "EndLevel")?.isHidden = true
        }
    }
    
    // Calculates the next level from a list of levels
    // if no list then return to main menu
    func loadNextLevel() {
        if ((levelArray!.count-1) > levelIndex) {
            nextLevel(index: levelIndex + 1)
        } else {
            gameStatus = GameStatus.FINISHED
            musicPlayer?.stop()
            self.removeAllActions()
            // TODO: Main menu
        }
    }
    
    // Restarts the scene and loads in the next level
    func nextLevel(index: Int) {
        levelLbl?.removeFromParent()
        self.childNode(withName: "Martinio")?.removeFromParent()
        setupLevel(lives: (martinioSprite?.getLives())!, scale: (martinioSprite?.getScale() ?? 0), shootable: martinioSprite?.isShootable() ?? false)
        setLevel(index: index)
        safetyBool = true
        
        // Update config and then write to file
        save!.currentLevel += 1
        save!.currentLives = (martinioSprite?.getLives())!
        saveData?.writeSave(saveData: save!)
    }
    
    
    func addNodeToPhysics(node : SKNode) {
        physics?.addObject(object: node.physicsObj!)
    }
    
    @objc func timerUpdate() {
        if let Gorilla = level?.childNode(withName: "Gorilla") as? GorillaSprite {
            Gorilla.fightMartinio(martinioPos: martinioSprite!.position)
            dkLbl?.text = "Gorilla's Health: " + String(Gorilla.getHealth())
        } else {
            dkLbl?.text = "Gorilla's Health: Dead"
            level?.childNode(withName: "EndLevel")?.isHidden = false
            timer?.invalidate()
        }
    }
    
    func getLevel() -> LevelScene? {
        return level
    }
    
    func getLevelIndex() -> Int {
        return levelIndex
    }
    
    func setLevelArray(collection: Array<LevelScene>) {
        self.levelArray = collection
    }
    
    func setSave(data: SaveData) {
        self.saveData = data
    }
    
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        if (gameStatus == GameStatus.PLAYING) {
            if (jumpBtn?.contains(pos))! {
                martinioSprite?.jump()
            } else if (leftArrow?.contains(pos))! {
                martinioSprite?.physicsObj?.applyImpulse(dx: -(martinioSprite?.getSpeed())!, dy: 0)
            } else if (rightArrow?.contains(pos))! {
                martinioSprite?.physicsObj?.applyImpulse(dx: (martinioSprite?.getSpeed())!, dy: 0)
            } else if (pauseBtn?.contains(pos))! {
                pauseGame()
            } else {
                if (martinioSprite?.isShootable() ?? false) {
                    martinioSprite?.shoot(towardsPoint: CGVector(dx: pos.x, dy: pos.y))
                }
            }
        } else {
            if (pauseBtn?.contains(pos))! {
                resumeGame()
            } else if let mainBtn = pauseNode?.childNode(withName: "MainMenu") as! MenuButton? {
                if (mainBtn.contains(pos)) {
                    gameStatus = GameStatus.QUIT
                    musicPlayer?.stop()
                    self.removeAllActions()
                }
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if (gameStatus == GameStatus.PLAYING) {
            if (leftArrow?.contains(pos))! {
                martinioSprite?.physicsObj?.applyImpulse(dx: -(martinioSprite?.getSpeed())!, dy: 0)
            } else if (rightArrow?.contains(pos))! {
                martinioSprite?.physicsObj?.applyImpulse(dx: (martinioSprite?.getSpeed())!, dy: 0)

            }
        } else {
            /*if (pauseBtn?.contains(pos))! {
                resumeGame()
            } else if let mainBtn = self.childNode(withName: "MainMenu") as! MenuButton? {
                if (mainBtn.contains(pos)) {
                    gameStatus = GameStatus.EXIT
                }
            }*/
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if (leftArrow?.contains(pos))! {
            martinioSprite?.physicsObj?.velocity.dx = 0
        } else if (rightArrow?.contains(pos))! {
            martinioSprite?.physicsObj?.velocity.dx = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        var dt = currentTime - self.lastUpdateTime
        if ((level?.isCompleted())! && safetyBool) {
            safetyBool = false
            loadNextLevel()
        }
        while(dt > Double(PhysicsWorld.DELTA_T) && !isPaused) {
            physics?.simulate(TimeSinceLastUpdate: PhysicsWorld.DELTA_T)
            dt -= Double(PhysicsWorld.DELTA_T)
        }
        
        // Check if Martinio is below ground level
        if ((martinioSprite?.position.y)! < frame.minY) {
            martinioSprite?.die()
        }
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        if (martinioSprite!.getLives() < 0) {
            gameStatus = GameStatus.DEAD
            musicPlayer?.stop()
            self.removeAllActions()
        }
        
        // Forces camera to move with Martinio (Allows scrolling)
        self.anchorPoint.x = -(2*(self.convert((martinioSprite?.position)!, to: relativeNode!).x) - self.convert(CGPoint(x: frame.maxX, y: 0), to: relativeNode!).x)/900
        self.setHUD()
        self.lastUpdateTime = currentTime
        livesLbl?.text = String(martinioSprite!.getLives()) + " Lives"
    }
    
    // Restart level when martinio is killed
    func restartLevel(lives: Int) {
        martinioSprite = MartinioSprite(x: frame.midX - frame.maxX, y: frame.midY, lives: lives)
        addNodeToPhysics(node: martinioSprite!)
        self.addChild((martinioSprite)!) // Spawn martinio
        
        // Update config and then write to file
        save!.currentLives = lives
        saveData?.writeSave(saveData: save!)
    }
    
    func getStatus() -> GameStatus {
        return gameStatus
    }
    
    func resetStatus() {
        gameStatus = GameStatus.PLAYING
    }
    
    // Show pause menu and stop all movement in level
    func pauseGame() {
        self.addChild(pauseNode!)
        self.isPaused = true
        level?.isPaused = true // Stops movement in level
        gameStatus = GameStatus.PAUSED
    }
    
    // Hide pause menu and resume all movement in level
    func resumeGame() {
        pauseNode?.removeFromParent()
        self.isPaused = false
        level?.isPaused = false // Restarts movement in level
        gameStatus = GameStatus.PLAYING
    }
    
    // Reset positions when frame moves
    // Ensures HUD is at some position of screen at all times
    func setHUD() {
        leftArrow?.position.x = frame.minX + 70
        rightArrow?.position.x = frame.maxX - 60
        livesLbl?.position.x = frame.minX + 80
        levelLbl?.position.x = frame.midX
        pauseBtn?.position.x = frame.minX + 30
        jumpBtn?.position.x = frame.midX
        dkLbl?.position.x = frame.midX
        //if (gameStatus == GameStatus.PAUSED) {
        pauseNode?.update(phoneFrame: frame)
        //}
    }
}
