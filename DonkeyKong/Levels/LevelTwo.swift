//
//  LevelTwo.swift
//  DonkeyKong
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
        
        let endNode = EndOfLevelNode(x: rect.maxX + 400, y: rect.minY + 40)
        self.addChild(endNode)
    }
}
