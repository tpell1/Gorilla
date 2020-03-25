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
    private var enemyArray: [KoopaSprite] = []
    private var levelData: LevelStruct
    
    init(title: String, fileName: String, levelData: LevelStruct) {
        self.levelData = levelData
        super.init(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Iterate through all blocks in the level, and then convert a BlockStruct instance into a
    // BlockSprite instance, which is then appended to the class' BlockArray
    func readInBlocks() {
        let blocks = levelData.blocks
        for i in 0...(blocks.count-1) {
            if blocks[i].blockType == "solid" {
                blockArray.append(BlockSprite(x: CGFloat(blocks[i].blockX), y: CGFloat(blocks[i].blockY), imageNamed: "brickBlock.png"))
            } else if blocks[i].blockType == "breakable" {
                blockArray.append(BreakableBlockSprite(x: CGFloat(blocks[i].blockX), y: CGFloat(blocks[i].blockY), texture1Named: "brickBlock.png", texture2Named: "brickBlock.png"))
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
                blockArray.append(ItemBlockSprite(x: CGFloat(blocks[i].blockX), y: CGFloat(blocks[i].blockY), imageNamed: "brickBlock.png", itemType: itemType))
            }
        }
    }
    
    func readInEnemies() {
        let enemies = levelData.enemies
        for i in 0...(enemies.count-1) {
            if enemies[i].enemyType == "koopa" {
                enemyArray.append(KoopaSprite(x: CGFloat(enemies[i].enemyX), y: CGFloat(enemies[i].enemyY)))
            }
        }
    }
}
