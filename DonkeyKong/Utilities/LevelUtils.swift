//
//  LevelUtils.swift
//  DonkeyKong
//
//  Created by Travis Pell on 26/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation

class LevelUtils {
    
    static func getLevelArray(fileName: String) -> [LevelReader] {
        let levelsStruct = PropertyListReader.readLevelFile(fileName: fileName)
        var array: [LevelReader] = []
        for i in 0...((levelsStruct?.levels.count)!-1) {
            guard let level = levelsStruct?.levels[i] else { return array }
            array.append(LevelReader(title: "level: " + String(i+1), levelData: level))
        }
        return array
    }
}
