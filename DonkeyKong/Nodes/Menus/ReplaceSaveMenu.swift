//
//  ReplaceSaveMenu.swift
//  DonkeyKong
//
//  Created by Travis Pell on 03/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class ReplaceSaveMenu: MainMenu {
    
    override func touchDown(atPoint pos : CGPoint) {
        for i in 0...(saveArray.count-1) {
            if (saveArray[i].contains((scene?.convert(pos, to: self))!)) {
                playGame = 20
                gameLevel = 20+i
            }
        }
    }
}
