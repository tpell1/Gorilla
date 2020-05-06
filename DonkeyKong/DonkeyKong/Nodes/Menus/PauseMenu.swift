//
//  PauseMenu.swift
//  DonkeyKong
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class PauseMenu: SKNode {
    private var translucentRect: SKShapeNode?
    private var returnToMainBtn: MenuButton
    
    init(phoneFrame: CGRect) {
        translucentRect = SKShapeNode(rect: phoneFrame)
        translucentRect?.position = CGPoint(x: phoneFrame.midX, y: 0)
        translucentRect?.blendMode = SKBlendMode.screen
        translucentRect?.fillColor = UIColor.gray
        translucentRect?.strokeColor = UIColor.black
        
        returnToMainBtn = MenuButton(textForButton: "Main Menu")
        returnToMainBtn.name = "MainMenu"
        returnToMainBtn.position = CGPoint(x: phoneFrame.midX, y: phoneFrame.midY)
        
        super.init()
        
        self.addChild(translucentRect!)
        self.addChild(returnToMainBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(phoneFrame: CGRect) {
        translucentRect?.position = CGPoint(x: phoneFrame.midX, y: 0)
        returnToMainBtn.position = CGPoint(x: phoneFrame.midX, y: phoneFrame.midY)
    }
}
