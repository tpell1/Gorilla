//
//  BreakableBlockSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 04/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class BreakableBlockSprite : BlockSprite {
	private var texture1 : String
	private var texture2 : String
	
    init(x: CGFloat, y: CGFloat, texture1Named: String, texture2Named: String) { // new constructor allows two textures
        texture1 = texture1Named
        texture2 = texture2Named
        
        super.init(x: x, y: y, imageNamed: texture1Named)
        
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	
	func breakBlock() {
		// TODO: ANIMATION
		self.removeFromParent() // delete block
	}

}
