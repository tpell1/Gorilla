//
//  LevelReader.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class LevelReader: LevelScene {
    private var fileName: String
    
    init(title: String, fileName: String) {
        self.fileName = fileName
        super.init(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
