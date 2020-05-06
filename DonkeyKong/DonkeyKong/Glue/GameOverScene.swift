//
//  GameOverScene.swift
//  DonkeyKong
//
//  Created by Travis Pell on 06/05/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    private var lbl : SKLabelNode?
    private var btn : MenuButton?
    var status : MenuStatus = MenuStatus.WAITING
    
    override func sceneDidLoad() {
        lbl = self.childNode(withName: "//lbl") as? SKLabelNode
        btn = MenuButton(textForButton: "Restart Game")
        btn?.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        self.addChild(btn!)
    }
    
    func isGameCompleted(true b : Bool) {
        if (b) {
            lbl?.text = "Congratulations! you have completed the game."
        } else {
            lbl?.text = "Unfortunately, you have run out of lives."
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        if (btn?.contains(pos) ?? false) {
            status = MenuStatus.NEW_SAVE
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
