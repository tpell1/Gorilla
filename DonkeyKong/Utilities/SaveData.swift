//
//  SaveData.swift
//  DonkeyKong
//
//  Created by Travis Pell on 01/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation

///////////////////// Config //////////////////////////
struct ConfigStruct: Codable {
    var currentLevel: Int
    var currentScore: Int
    var currentLives: Int
}

class SaveData {
    private var name: String
    
    init(saveName: String = "Config") {
        name = saveName
    }
    
    func read() -> ConfigStruct {
        if (configExistsInDocs()) {
            return readConfigFromDocs() ?? ConfigStruct(currentLevel: 1, currentScore: 0, currentLives: 3)
        } else {
            let config = readConfigFromBundle() ?? ConfigStruct(currentLevel: 1, currentScore: 0, currentLives: 3)
            writeConfig(configData: config)
            return config
        }
    }
    
    private func readConfigFromBundle() -> ConfigStruct? {
        if let file = Bundle.main.path(forResource: name, ofType: "plist"), let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(ConfigStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
    
    private func configExistsInDocs() -> Bool {
        return FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name + ".plist").path)
    }
    
    private func readConfigFromDocs() -> ConfigStruct? {
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name + ".plist").path
        if let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(ConfigStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
    
    func writeConfig(configData: ConfigStruct) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name + ".plist") // ERROR HERE

        print(file.absoluteString)
        do {
            let data = try encoder.encode(configData)
            try data.write(to: file)
        } catch {
            print(error)
        }
    }
    
    func writeConfig(level: Int, lives: Int, score: Int) {
        let config = ConfigStruct(currentLevel: level, currentScore: score, currentLives: lives)
        writeConfig(configData: config)
    }
}
