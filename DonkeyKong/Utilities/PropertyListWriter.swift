//
//  PropertyListWriter.swift
//  DonkeyKong
//
//  Created by Travis Pell on 26/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation

class PropertyListWriter {
    
    static func writeConfig(fileName: String, configData: ConfigStruct) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            let data = try encoder.encode(configData)
            try data.write(to: file)
        } catch {
            print(error)
        }
    }
    
    static func writeConfig(fileName: String, level: Int, lives: Int, score: Int) {
        let config = ConfigStruct(currentLevel: level, currentScore: score, currentLives: lives)
        writeConfig(fileName: fileName, configData: config)
    }
}
