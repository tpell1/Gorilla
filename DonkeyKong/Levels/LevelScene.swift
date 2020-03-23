//
//  Level1Scene.swift
//  DonkeyKong
//
//  Super class for all Levels
//  All subclasses must override addChildren
//  Use this to add all nodes in each level
//  This class also represents level one
//
//  Created by Travis Pell on 14/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class LevelScene: SKNode {
    static var GROUND_HEIGHT: CGFloat = 40
    
    private var blockSprite : BlockSprite?
    private var breakableBlock : BreakableBlockSprite?
    private var itemBlock : ItemBlockSprite?
    private var endNode : EndOfLevelNode?
    internal var rect : CGRect // Good reference, use rect.midX to get central x pos of level
    private var title : String
    private var complete : Bool = false
    
    // Constructor (Frame is set later)
    init(title: String) {
        self.title = title
        self.rect = CGRect(x: 0, y: 0, width: 400, height: 200)
        super.init()
        self.name = "level"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add all nodes to the level (Blocks and enemies)
    func addChildren() {
        blockSprite = BlockSprite(x: rect.midX + 50, y: rect.minY + 130, imageNamed: "brickBlock.png")
        self.addChild(blockSprite!)
        
        breakableBlock = BreakableBlockSprite(x: rect.midX + 90, y: rect.minY + 130, texture1Named: "brickBlock.png", texture2Named: "brokenBlock.png")
        self.addChild(breakableBlock!)
        
        itemBlock = ItemBlockSprite(x: rect.midX + 130, y: rect.minY + 130, imageNamed: "brickBlock.png")
        self.addChild(itemBlock!)
        
        
        let endNode = EndOfLevelNode(x: rect.maxX + 400, y: rect.minY + 40)
        self.addChild(endNode)
    }
    
    // Set frame (required to addChildren)
    func setFrame(frameRect: CGRect) {
        rect = frameRect
    }
    
    func getTitle() -> String {
        return title
    }
    
    func completeLevel() {
        complete = true
    }
    
    func isCompleted() -> Bool {
        return complete
    }
}
