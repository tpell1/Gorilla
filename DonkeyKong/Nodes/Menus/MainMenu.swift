//
//  MainMenu.swift
//  DonkeyKong
//
//  Created by Travis Pell on 03/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKNode {
    var playGame: Int = -1
    var gameLevel: Int = 0
    private var playLbl: SKLabelNode?
    private var newGameLbl: SKLabelNode?
    private var saveArray: [MenuButton] = []
    
    init(playGameLabel play : SKLabelNode, newGameLabel new : SKLabelNode) {
        super.init()
        
        playLbl = play
        playLbl?.text = "Play last save"
        newGameLbl = new
        
        for i in 1...SaveData.getNumberOfSaves() {
            let saveLbl = MenuButton(textForButton: "Save " + String(i))
            saveLbl.position = CGPoint(x: frame.midX, y: (frame.midY + 0.3*frame.height)-(MenuButton.HEIGHT+15)*CGFloat(i))
            saveLbl.name = String(i)
            self.addChild(saveLbl)
            saveArray.append(saveLbl)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if (playLbl?.contains(pos) ?? false) {
            playGame = 0
            gameLevel = 0
        } else if (newGameLbl?.contains(pos) ?? false) {
            playGame = 10
            gameLevel = 0
        }
        
        for i in 0...(saveArray.count-1) {
            if (saveArray[i].contains(pos)) {
                playGame = i
            }
        }
    }
}
