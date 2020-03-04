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
	
	init(x: CGFloat, y: CGFloat, texture1Named: String, texture2Named) { // new constructor allows two textures
		super.init(x, y, texture1Named)
		
		texture1 = texture1Named
		texture2 = texture2Named
	}
	
	func breakBlock() {
		// TODO: ANIMATION
		self.removeFromParent() // delete block
	}

}