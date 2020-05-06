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
    static var HEIGHT : CGFloat = 50
    static var WIDTH : CGFloat = 300
    
    init(textForButton text: String) {
        self.buttonSprite = SKSpriteNode(imageNamed: "buttonImage.png")
        self.buttonLbl = SKLabelNode(text: text)
        super.init()
        
        self.buttonSprite.zPosition = 1
        self.buttonSprite.scale(to: CGSize(width: MenuButton.WIDTH, height: MenuButton.HEIGHT))
        self.buttonLbl.zPosition = 2
        self.buttonLbl.position.y -= 12
        
        self.addChild(buttonSprite)
        self.addChild(buttonLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String) {
        buttonLbl.text = text
    }
}
