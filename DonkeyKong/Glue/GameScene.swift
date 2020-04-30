//
//  GameScene.swift
//  DonkeyKong
//
//  Created by Travis Pell on 17/10/2019.
//  Copyright © 2019 Travis Pell. All rights reserved.
//

import SpriteKit
import GameplayKit

public enum GameStatus {
     case PLAYING, PAUSED, QUIT, FINISHED
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    internal var marioSprite : MarioSprite?
    private var levelArray: [LevelScene]?
    private var level : LevelScene?
    private var save : SaveData?
    private var config : ConfigStruct?
    
    internal var leftArrow : SKShapeNode?
    internal var rightArrow : SKShapeNode?
    internal var livesLbl : SKLabelNode?
    private var levelLbl : SKLabelNode?
    private var pauseBtn : SKShapeNode?
    internal var nameNode : SKNode?
    private var relativeNode : SKNode?
    private var pauseNode : PauseMenu?
    internal var ground : SKShapeNode?

    internal var lastUpdateTime : TimeInterval = 0
    private var timer : Timer?
    private var safetyBool : Bool = true
    private var gameStatus : GameStatus = GameStatus.PLAYING
    private var levelIndex : Int = 0
    
    
    // Initial loading of scene, sets up HUD and loads in mario Sprite
    override func sceneDidLoad() {
        self.lastUpdateTime = 0

        let physics = PhysicsHandler()
        gameStatus = GameStatus.PLAYING
        self.addChild(physics)
        physicsWorld.contactDelegate = physics
    }

    // Called after sceneDidLoad(), allows config to be read and the levels list
    override func didMove(to view: SKView) {
        config = save?.read()
        setupLevel(lives: config!.currentLives)
        setLevel(index: (config?.currentLevel)! - 1)
    }
    
    // Sets up UI stuff required for all levels (Mario, HUD, etc)
    func setupLevel(lives: Int) {
        //Initial HUD, load from sks file
        leftArrow = self.childNode(withName: "//leftArrow") as? SKShapeNode
        rightArrow = self.childNode(withName: "//rightArrow") as? SKShapeNode
        livesLbl = self.childNode(withName: "//livesLbl") as? SKLabelNode
        nameNode = self.childNode(withName: "//node")
        pauseBtn = self.childNode(withName: "//pauseBtn") as? SKShapeNode
        
        print("Frame x: " + String(describing: frame.minX))
        
        // Remove all parts of previous level (no error if level one)
        self.childNode(withName: "ground")?.removeFromParent()
        level?.removeFromParent()
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5) // Making the coordinates consistant accross all levels
        relativeNode = SKNode() // Used for centering on Mario
        relativeNode?.position = anchorPoint
        
        pauseNode = PauseMenu(phoneFrame: frame) // Used for pause menu (contains all required buttons etc.)
        pauseNode?.zPosition = 10
        
        // Create the floor
        // TODO: Move into LevelScene class
        ground = SKShapeNode()
        ground?.path = UIBezierPath(roundedRect: CGRect(x: frame.minX - frame.maxX, y: 0, width: frame.maxX * 5, height: 20), cornerRadius: 1).cgPath
        ground?.position = CGPoint(x: frame.midX, y: frame.minY)
        ground?.fillColor = UIColor.green
        ground?.lineWidth = 5
        ground?.physicsBody = SKPhysicsBody(edgeChainFrom: (ground?.path!)!)
        ground?.physicsBody?.restitution = 0.2
        ground?.physicsBody?.isDynamic = false
        ground?.name = "ground"
        self.addChild(ground!)
        
        // Spawn in mario
        marioSprite = MarioSprite(x: frame.midX - frame.maxX, y: frame.midY, lives: lives)
        self.addChild((marioSprite)!)
        
        // Display to user what level they are on
        levelLbl = SKLabelNode(text: "Level: ")
        levelLbl?.name = "levelLbl"
        levelLbl?.position.y = frame.maxY - 80
        self.addChild(levelLbl!)
        
        self.setHUD()
    }
    
    // Loads a level into the scene
    func setLevel(index: Int) {
        levelIndex = index
        self.level = levelArray?[index]
        level?.setFrame(frameRect: frame)
        level?.addChildren()
        self.addChild(level!)
        levelLbl?.text = "Level: " + (level?.getTitle())!
        
        if (level?.name == "boss_level") {
            timer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    @objc func timerUpdate() {
        if let donkeyKong = level?.childNode(withName: "donkeyKong") as? DonkeyKongSprite {
            donkeyKong.fightMario(marioPos: marioSprite!.position)
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
        self.save = data
    }
    
    // Restarts the scene and loads in the next level
    func nextLevel(index: Int) {
        levelLbl?.removeFromParent()
        self.childNode(withName: "Mario")?.removeFromParent()
        setupLevel(lives: (marioSprite?.getLives())!)
        setLevel(index: index)
        safetyBool = true
        
        // Update config and then write to file
        config!.currentLevel += 1
        config!.currentLives = (marioSprite?.getLives())!
        save?.writeConfig(configData: config!)
    }
    
    // Calculates the next level from a list of levels
    // if no list then return to main menu
    func loadNextLevel() {
        if ((levelArray!.count-1) > levelIndex) {
            nextLevel(index: levelIndex + 1)
        } else {
            gameStatus = GameStatus.FINISHED
            // TODO: Main menu
        }
    }
    
    // ======== Touchscreen event handling ================================
    
    // Called when the user presses down on screen
    func touchDown(atPoint pos : CGPoint) {
        if (gameStatus == GameStatus.PLAYING) {
            if (marioSprite?.contains(pos))! {
                marioSprite?.jump()
            } else if (leftArrow?.contains(pos))! {
                //marioSprite?.physicsBody?.applyImpulse(CGVector(dx: -1, dy: 0))
                marioSprite?.physicsBody?.velocity.dx = -(marioSprite?.getSpeed())!
            } else if (rightArrow?.contains(pos))! {
                //marioSprite?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
                marioSprite?.physicsBody?.velocity.dx = (marioSprite?.getSpeed())!
            } else if (pauseBtn?.contains(pos))! {
                pauseGame()
            } else {
                if (marioSprite?.isShootable() ?? false) {
                    marioSprite?.shoot(direction: CGVector(dx: pos.x/abs(pos.x), dy: pos.y/abs(pos.x)))
                
                }
            }
        } else {
            if (pauseBtn?.contains(pos))! {
                resumeGame()
            } else if let mainBtn = pauseNode?.childNode(withName: "MainMenu") as! MenuButton? {
                if (mainBtn.contains(pos)) {
                    gameStatus = GameStatus.QUIT
                }
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if (gameStatus == GameStatus.PLAYING) {
            if (leftArrow?.contains(pos))! {
                marioSprite?.physicsBody?.velocity.dx = -(marioSprite?.getSpeed())!
            } else if (rightArrow?.contains(pos))! {
                marioSprite?.physicsBody?.velocity.dx = (marioSprite?.getSpeed())!
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
            marioSprite?.physicsBody?.velocity.dx = 0
        } else if (rightArrow?.contains(pos))! {
            marioSprite?.physicsBody?.velocity.dx = 0
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
        let dt = currentTime - self.lastUpdateTime
        if ((level?.isCompleted())! && safetyBool) {
            safetyBool = false
            loadNextLevel()
        }
        
        // Check if Mario is below ground level
        if ((marioSprite?.position.y)! < frame.minY) {
            marioSprite?.die()
        }
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        // Forces camera to move with Mario (Allows scrolling)
        self.anchorPoint.x = -(2*(self.convert((marioSprite?.position)!, to: relativeNode!).x) - self.convert(CGPoint(x: frame.maxX, y: 0), to: relativeNode!).x)/900
        self.setHUD()
        self.lastUpdateTime = currentTime
        livesLbl?.text = String(describing: marioSprite?.getLives())
    }
    
    // Restart level when mario is killed
    func restartLevel(lives: Int) {
        let groundRectPointer = UnsafeMutablePointer<CGRect>.allocate(capacity: 1) // Get a pointer to the rectangle that represents the ground
        if (ground?.path?.isRect(groundRectPointer))! { // Makes sure it is a rectangle
            marioSprite = MarioSprite(x: groundRectPointer.pointee.minX + 400, y: frame.midY, lives: lives) // Reinstantiate mario but with one less life, back at the start of the level
        } else {
            marioSprite = MarioSprite(x: frame.midX - frame.maxX, y: frame.midY, lives: lives)
        }
        self.addChild((marioSprite)!) // Spawn mario
        
        // Update config and then write to file
        config!.currentLives = lives
        save?.writeConfig(configData: config!)
    }
    
    func getStatus() -> GameStatus {
        return gameStatus
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
        //if (gameStatus == GameStatus.PAUSED) {
            pauseNode?.update(phoneFrame: frame)
        //}
    }
}
