//
//  MenuButton.swift
//  DonkeyKong
//
//  Created by Travis Pell on 03/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class MenuButton: SKNode {
    private var buttonSprite: SKSpriteNode
    private var buttonLbl: SKLabelNode
    
    init(textForButton text: String) {
        self.buttonSprite = SKSpriteNode(imageNamed: "buttonImage.png")
        self.buttonLbl = SKLabelNode(text: text)
        super.init()
        
        self.buttonSprite.zPosition = 1
        self.buttonSprite.scale(to: CGSize(width: 300, height: 50))
        self.buttonLbl.zPosition = 2
        self.buttonLbl.position.y -= 15
        
        self.addChild(buttonSprite)
        self.addChild(buttonLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
