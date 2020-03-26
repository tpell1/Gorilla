//
//  EndOfLevelNode.swift
//  DonkeyKong
//
//  Preset with a pyramid of blocks and then
//  a flag pole (EndLevelNode)
//
//  Created by Travis Pell on 14/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class EndOfLevelNode: SKNode {
    private var endNode : EndLevelNode?
    private var brick1 : BlockSprite?
    private var brick2 : BlockSprite?
    private var brick3 : BlockSprite?
    
    // Initializer for basic n.n Pyramid followed by flagpole
    init(x: CGFloat, y: CGFloat, size: Int) {
        let endNode = EndLevelNode(x: x + 100, y: y)
        super.init()
        self.addChild(endNode)
        
        for i in 0...size-1 {
            self.addChild(BlockSprite(x: x+(CGFloat(i)*BlockSprite.BLOCK_SIZE), y: y, imageNamed: "brickBlock.png"))
            for j in 2...i {
                self.addChild(BlockSprite(x: x+(CGFloat(i)*BlockSprite.BLOCK_SIZE), y: y+(CGFloat(j)*BlockSprite.BLOCK_SIZE), imageNamed: "brickBlock.png"))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
