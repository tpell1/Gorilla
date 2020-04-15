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
    var status: LevelSelectStatus = LevelSelectStatus.WAITING
    var saveNumber: Int = -1
    
    internal var saveArray: [MenuButton] = []
    
    override init() {
        super.init()
        
        let numberOfSaves = SaveData.getNumberOfSaves()
        
        if numberOfSaves == 0 {
            
        } else {
            for i in 1...SaveData.getNumberOfSaves() {
                let saveLbl = MenuButton(textForButton: "Save " + String(i))
                saveLbl.position = CGPoint(x: frame.midX, y: (frame.midY)-(MenuButton.HEIGHT+15)*CGFloat(i))
                saveLbl.name = String(i)
                self.addChild(saveLbl)
                saveArray.append(saveLbl)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let numberOfSaves = SaveData.getNumberOfSaves()
        
        if numberOfSaves != 0 {
            for i in 0...(saveArray.count-1) {
                if (saveArray[i].contains((scene?.convert(pos, to: self))!)) { // TODO: pos must be replaced with pos relative to grandparent node (aka scene)
                    status = LevelSelectStatus.CONTINUE_SAVE
                    saveNumber = i
                    print(i)
                }
            }
        }
    }
}
