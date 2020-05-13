//
//  LevelUtils.swift
//  Gorilla
//
//  Created by Travis Pell on 26/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation

// =============== Data structures =======================================
//////////////////////// Levels ////////////////////////////
// Root node, loads in an array of levels
struct LevelsStruct: Codable {
    var levels: [LevelStruct]
}

// Level node, splits each level into two arrays of blocks and
// enemies respectively
struct LevelStruct: Codable {
    var blocks: [BlockStruct]
    var enemies: [EnemyStruct]
    var presets: [PresetStruct]
    var levelType: String
}

// Block node, splits each block into the required attributes
struct BlockStruct: Codable {
    var blockType: String
    var blockX: Int
    var blockY: Int
    var itemType: String
}

// Enemy node, splits each enemy into the required attributes
struct EnemyStruct: Codable {
    var enemyType: String
    var enemyX: Int
    var enemyY: Int
}

// Preset node, found in Levels/Nodes/Presets
struct PresetStruct: Codable {
    var presetType: String
    var presetX: Int
    var presetY: Int
    var presetSize: Int
}

class LevelUtils {
    
    static func getLevelArray() -> [LevelReader] {
        let levelsStruct = readLevelFile()
        var array: [LevelReader] = []
        for i in 0...((levelsStruct?.levels.count)!-1) {
            guard let level = levelsStruct?.levels[i] else { return array }
            array.append(LevelReader(title: "level: " + String(i+1), levelData: level))
        }
        return array
    }
    
    static func readLevelFile(fileName: String = "Levels") -> LevelsStruct? {
        if let file = Bundle.main.path(forResource: fileName, ofType: "plist") {
            if let plist = FileManager.default.contents(atPath: file), let levels = try? PropertyListDecoder().decode(LevelsStruct.self, from: plist) {
                return levels
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
