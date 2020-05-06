//
//  ItemBlockSprite.swift
//  DonkeyKong
//
//  Class representing a block that spawns an item
//
//  Created by Travis Pell on 04/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class ItemBlockSprite: BlockSprite {
	private var itemType : ItemType
    private var itemUsed : Bool
	
	init(x: CGFloat, y: CGFloat, imageNamed: String, itemType: ItemType) {
        self.itemType = itemType
        self.itemUsed = false
        
        super.init(x: x, y: y, imageNamed: imageNamed)
	}

    // Constructor with a default item type of OneUp
    convenience override init(x: CGFloat, y: CGFloat, imageNamed: String) {
		//TODO: random item selection
        self.init(x: x, y: y, imageNamed: imageNamed, itemType: ItemType.ONEUP)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	// Spawn an item of the type defined by constructor
	func spawnItem() -> ItemSprite? {
        if (!itemUsed) {
            itemUsed = true
            var item = ItemSprite(x: self.position.x, y: self.position.y, itemType: itemType)
            if itemType == ItemType.MUSHROOM {
                item = MushroomItem(x: self.position.x, y: self.position.y+20)
            } else if itemType == ItemType.FIRE {
                item = FireItem(x: self.position.x, y: self.position.y+20)
            } else if itemType == ItemType.STAR {
                
            }
            self.parent?.addChild(item)
            let riseUpAction = SKAction.move(to: CGPoint(x: self.position.x, y: self.position.y+30), duration: 1.5)
            item.run(riseUpAction, completion: item.move)
            return item
        }
        return nil
	}
}
