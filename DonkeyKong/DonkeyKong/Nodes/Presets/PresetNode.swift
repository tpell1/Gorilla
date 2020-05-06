//
//  PresetNode.swift
//  DonkeyKong
//
//  Created by Travis Pell on 01/05/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class PresetNode : SKNode {
    
    func moveAllChildren(toNode node : SKNode) {
        for i in (self.children) {
            i.move(toParent: node)
        }        
    }
}
