//
//  LevelReader.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

class LevelReader: LevelScene {
    private var fileName: String = "Levels.plist"
    private var blockArray: [BlockSprite] = []
    private var enemyArray: [SKSpriteNode] = []
    private var presetArray: [PresetNode] = []
    private var levelData: LevelStruct
    private var zeroY: CGFloat = 0
    
    init(title: String, levelData: LevelStruct) {
        self.levelData = levelData
        
        if (levelData.levelType == "standard") {
            super.init(title: title, name: "level")
        } else if (levelData.levelType == "boss") {
            super.init(title: title, name: "boss_level")
        } else {
            super.init(title: title, name: "level")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addChildren() {
        readInBlocks()
        readInPresets()
        readInEnemies()
        if (blockArray.count > 0) {
            for i in 0...(blockArray.count-1) {
                self.addChild(blockArray[i])
            }
        }
        if (enemyArray.count > 0) {
            for i in 0...(enemyArray.count-1) {
                self.addChild(enemyArray[i])
            }
        }
        if (presetArray.count > 0) {
            for i in 0...(presetArray.count-1) {
                self.addChild(presetArray[i])
                
                /*for j in 0...(presetArray[i].children.count-1) {
                    presetArray[i].children[j].move(toParent: (self.parent)!)
                }*/
            }
        }
        let ground = SKSpriteNode(imageNamed: "ground.png")
        ground.scale(to: CGSize(width: rect.maxX*5, height: 20))
        ground.position = CGPoint(x: rect.midX, y: rect.minY)
        ground.physicsObj = PhysicsObject(withNode: ground, mass: -1)
        
        ground.name = "ground"
        self.addChild(ground)
    }
    
    override func addChild(_ node: SKNode) {
        if node is PresetNode {
            super.addChild(node)
            let preset = node as! PresetNode
            preset.moveAllChildren(toNode: self)
        } else if node is ItemSprite {
            if self.scene is GameScene {
                let gameScene = self.scene as! GameScene
                gameScene.addNodeToPhysics(node: node)
            }
            super.addChild(node)
        } else {
            super.addChild(node)
        }
    }
    
    override func setFrame(frameRect: CGRect) {
        super.setFrame(frameRect: frameRect)
        zeroY = frameRect.minY + 40//- frameRect.maxY
    }
    
    // Iterate through all blocks in the level, and then convert a BlockStruct instance into a
    // BlockSprite instance, which is then appended to the class' BlockArray
    private func readInBlocks() {
        let blocks = levelData.blocks
        if (blocks.count > 0) {
            for i in 0...(blocks.count-1) {
                if blocks[i].blockType == "solid" {
                    blockArray.append(BlockSprite(x: rect.midX+CGFloat(blocks[i].blockX), y: zeroY + CGFloat(blocks[i].blockY), imageNamed: "solidBlock.png"))
                } else if blocks[i].blockType == "breakable" {
                    blockArray.append(BreakableBlockSprite(x: rect.midX+CGFloat(blocks[i].blockX), y: zeroY + CGFloat(blocks[i].blockY), texture1Named: "brickBlock.png", texture2Named: "brickBlock.png"))
                } else if blocks[i].blockType == "item" {
                    var itemType = ItemType.ONEUP
                    if blocks[i].itemType == "oneup" {
                        // TODO Tidy up
                    } else if blocks[i].itemType == "mushroom" {
                        itemType = ItemType.MUSHROOM
                    } else if blocks[i].itemType == "star" {
                        itemType = ItemType.STAR
                    } else if blocks[i].itemType == "fire" {
                        itemType = ItemType.FIRE
                    }
                    blockArray.append(ItemBlockSprite(x: rect.midX+CGFloat(blocks[i].blockX), y: zeroY + CGFloat(blocks[i].blockY), imageNamed: "itemBlock.png", itemType: itemType))
                }
            }
        }
    }
    
    private func readInEnemies() {
        let enemies = levelData.enemies
        if (enemies.count > 0) {
            for i in 0...(enemies.count-1) {
                if enemies[i].enemyType == "koopa" {
                    enemyArray.append(KoopaSprite(x: rect.midX+CGFloat(enemies[i].enemyX), y: zeroY + CGFloat(enemies[i].enemyY)))
                } else if enemies[i].enemyType == "donkeykong" {
                    enemyArray.append(DonkeyKongSprite(x: rect.midX+CGFloat(enemies[i].enemyX), y: zeroY + CGFloat(enemies[i].enemyY)))
                }
            }
        }
    }
    
    func readInPresets() {
        let presets = levelData.presets
        if (presets.count > 0) {
            for i in 0...(presets.count-1) {
                if presets[i].presetType == "koopa_platform" {
                    presetArray.append(KoopaPlatformHelper(x: rect.midX+CGFloat(presets[i].presetX), y: rect.midX+CGFloat(presets[i].presetY), size: presets[i].presetSize))
                } else if presets[i].presetType == "endLevel" {
                    presetArray.append(EndOfLevelNode(x: CGFloat(presets[i].presetX), y: zeroY + CGFloat(presets[i].presetY), size: presets[i].presetSize))
                    
                }
            }
        }
    }
    
    func readLevelFile(fileName: String = "Levels") -> LevelsStruct? {
        if let file = Bundle.main.path(forResource: fileName, ofType: "plist") {
            if let plist = FileManager.default.contents(atPath: file), let levels = try? PropertyListDecoder().decode(LevelsStruct.self, from: plist) {
                return levels
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
