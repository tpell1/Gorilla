//
//  LevelTwo.swift
//  DonkeyKong
//
//  Class representing Level Two
//
//  Created by Travis Pell on 15/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class LevelTwo: LevelScene {
    
    override func addChildren() {
        let blockSprite = BlockSprite(x: rect.midX + 50, y: rect.minY + 130, imageNamed: "brickBlock.png")
        self.addChild(blockSprite)
        
        let breakableBlock = BreakableBlockSprite(x: rect.midX + 90, y: rect.minY + 130, texture1Named: "brickBlock.png", texture2Named: "brokenBlock.png")
        self.addChild(breakableBlock)
        
        let itemBlock = ItemBlockSprite(x: rect.midX + 130, y: rect.minY + 130, imageNamed: "brickBlock.png")
        self.addChild(itemBlock)
        
        let block1 = BlockSprite(x: rect.midX+240, y: rect.minY+LevelScene.GROUND_HEIGHT, imageNamed: "brickBlock.png")
        let block2 = BlockSprite(x: rect.midX+280, y: rect.minY+LevelScene.GROUND_HEIGHT, imageNamed: "brickBlock.png")
        let block3 = BlockSprite(x: rect.midX+400, y: rect.minY+LevelScene.GROUND_HEIGHT, imageNamed: "brickBlock.png")
        let block4 = BlockSprite(x: rect.midX+320, y: rect.minY+LevelScene.GROUND_HEIGHT, imageNamed: "brickBlock.png")
        let block5 = BlockSprite(x: rect.midX+360, y: rect.minY+LevelScene.GROUND_HEIGHT, imageNamed: "brickBlock.png")
        self.addChild(block1)
        self.addChild(block2)
        self.addChild(block3)
        self.addChild(block4)
        self.addChild(block5)

        let endNode = EndOfLevelNode(x: rect.maxX + 400, y: rect.minY + 40, size: 4)
        self.addChild(endNode)
    }
}
