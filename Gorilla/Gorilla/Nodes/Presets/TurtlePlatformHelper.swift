//
//  TurtlePlatformHelper.swift
//  Gorilla
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class TurtlePlatformHelper: PresetNode {
    private var blockArray: [BlockSprite] 
    
    init(x: CGFloat, y: CGFloat, size: Int) {
        self.blockArray = []
        super.init()
        
        for i in 0...(size-1) {
            blockArray.append(BlockSprite(x: x+CGFloat(i)*BlockSprite.BLOCK_SIZE, y: y, imageNamed: "brickBlock.png"))
            self.addChild(blockArray[i])
        }
        
        let turtleSprite = TurtleSprite(x: x, y: y+180, sizeOfPlatform: size)
        self.addChild(turtleSprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
