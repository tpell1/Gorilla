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
    
    init(phoneFrame: CGRect) {
        translucentRect = SKShapeNode(rect: phoneFrame)
        translucentRect?.blendMode = SKBlendMode.subtract
        translucentRect?.fillColor = UIColor.gray
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
