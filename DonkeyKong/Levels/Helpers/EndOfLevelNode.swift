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
    
    // Initializer for basic 2x2 Pyramid followed by flagpole
    init(x: CGFloat, y: CGFloat) {
        let endNode = EndLevelNode(x: x + 100, y: y)
        let brick1 = BlockSprite(x: x, y: y, imageNamed: "brickBlock.png")
        let brick2 = BlockSprite(x: x+40, y: y, imageNamed: "brickBlock.png")
        let brick3 = BlockSprite(x: x+40, y: y+40, imageNamed: "brickBlock.png")
        
        super.init()
        self.addChild(endNode)
        self.addChild(brick1)
        self.addChild(brick2)
        self.addChild(brick3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
