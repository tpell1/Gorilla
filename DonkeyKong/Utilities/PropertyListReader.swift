//
//  PropertyListReader.swift
//  DonkeyKong
//
//  Created by Travis Pell on 25/03/2020.
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

///////////////////// Config //////////////////////////
struct ConfigStruct: Codable {
    var currentLevel: Int
    var currentScore: Int
    var currentLives: Int
}

// ================ Class implementation =================================
class PropertyListReader {
    static func readFile(fileName: String) -> String {
        return ""
    }
    
    static func readLevelFile(fileName: String) -> LevelsStruct? {
        if let file = Bundle.main.path(forResource: fileName, ofType: "plist"), let plist = FileManager.default.contents(atPath: file), let levels = try? PropertyListDecoder().decode(LevelsStruct.self, from: plist) {
            return levels
        } else {
            return nil
        }
    }
    
    static func readConfigFile(fileName: String) -> ConfigStruct? {
        if let file = Bundle.main.path(forResource: fileName, ofType: "plist"), let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(ConfigStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
}
