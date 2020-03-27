//
//  LevelReader.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class LevelReader: LevelScene {
    private var fileName: String = "Levels.plist"
    private var blockArray: [BlockSprite] = []
    private var enemyArray: [SKSpriteNode] = []
    private var presetArray: [SKNode] = []
    private var levelData: LevelStruct
    
    init(title: String, levelData: LevelStruct) {
        self.levelData = levelData
        super.init(title: title)
        
        if (levelData.levelType == "standard") {
            readInBlocks()
            readInPresets()
            readInEnemies()
        } else if (levelData.levelType == "boss") {
            readInEnemies()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addChildren() {
        for i in 0...(blockArray.count-1) {
            self.addChild(blockArray[i])
        }
        for i in 0...(enemyArray.count-1) {
            self.addChild(enemyArray[i])
        }
        for i in 0...(presetArray.count-1) {
            self.addChild(presetArray[i])
        }
    }
    
    // Iterate through all blocks in the level, and then convert a BlockStruct instance into a
    // BlockSprite instance, which is then appended to the class' BlockArray
    private func readInBlocks() {
        let blocks = levelData.blocks
        for i in 0...(blocks.count-1) {
            if blocks[i].blockType == "solid" {
                blockArray.append(BlockSprite(x: rect.midX+CGFloat(blocks[i].blockX), y: rect.midX+CGFloat(blocks[i].blockY), imageNamed: "brickBlock.png"))
            } else if blocks[i].blockType == "breakable" {
                blockArray.append(BreakableBlockSprite(x: rect.midX+CGFloat(blocks[i].blockX), y: rect.midX+CGFloat(blocks[i].blockY), texture1Named: "brickBlock.png", texture2Named: "brickBlock.png"))
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
                blockArray.append(ItemBlockSprite(x: rect.midX+CGFloat(blocks[i].blockX), y: rect.midX+CGFloat(blocks[i].blockY), imageNamed: "brickBlock.png", itemType: itemType))
            }
        }
    }
    
    private func readInEnemies() {
        let enemies = levelData.enemies
        for i in 0...(enemies.count-1) {
            if enemies[i].enemyType == "koopa" {
                enemyArray.append(KoopaSprite(x: rect.midX+CGFloat(enemies[i].enemyX), y: rect.midX+CGFloat(enemies[i].enemyY)))
            }
        }
    }
    
    func readInPresets() {
        let presets = levelData.presets
        for i in 0...(presets.count-1) {
            if presets[i].presetType == "koopa_platform" {
                presetArray.append(KoopaPlatformHelper(x: rect.midX+CGFloat(presets[i].presetX), y: rect.midX+CGFloat(presets[i].presetY), size: presets[i].presetSize))
            }
        }
    }
}
