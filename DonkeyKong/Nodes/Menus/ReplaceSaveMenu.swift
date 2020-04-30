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
        
    override init() {
        super.init()
        
        status = MenuStatus.NEW_GAME_WAITING
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchDown(atPoint pos : CGPoint) {
        for i in 0...(saveArray.count-1) {
            if (saveArray[i].contains((scene?.convert(pos, to: self))!)) {
                status = MenuStatus.REPLACE_SAVE
                saveNumber = i
            }
        }
    }
}
