//
//  SaveData.swift
//  Gorilla
//
//  Created by Travis Pell on 01/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation

///////////////////// Save //////////////////////////
struct SaveStruct: Codable {
    var currentLevel: Int
    var currentScore: Int
    var currentLives: Int
}

class SaveData {
    static var MAX_AMOUNT_OF_SAVES: Int = 5
    private var name: String
    private static var configFolder: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("saves/")
    
    init(saveName: String = "Save") {
        name = saveName
    }
    
    func read() -> SaveStruct {
        if (saveExistsInDocs()) {
            return readSaveFromDocs() ?? SaveStruct(currentLevel: 1, currentScore: 0, currentLives: 3)
        } else {
            let config = readSaveFromBundle() ?? SaveStruct(currentLevel: 1, currentScore: 0, currentLives: 3)
            writeSave(saveData: config)
            return config
        }
    }
    
    private func readSaveFromBundle() -> SaveStruct? {
        if let file = Bundle.main.path(forResource: "Config", ofType: "plist"), let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(SaveStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
    
    private func saveExistsInDocs() -> Bool {
        return FileManager.default.fileExists(atPath: SaveData.configFolder.appendingPathComponent(name + ".plist").path)
    }
    
    private func readSaveFromDocs() -> SaveStruct? {
        let file = SaveData.configFolder.appendingPathComponent(name + ".plist").path
        if let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(SaveStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
    
    func writeSave(saveData: SaveStruct) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let file = SaveData.configFolder.appendingPathComponent(name + ".plist") // ERROR HERE
        
        if !FileManager.default.fileExists(atPath: SaveData.configFolder.path) {
            if ((try? FileManager.default.createDirectory(at: SaveData.configFolder, withIntermediateDirectories: true, attributes: nil)) != nil) {
                
            } else {
                print ("Couldnt create folder")
            }
        } else {
            print("Folder already created.")
        }
        
        do {
            let data = try encoder.encode(saveData)
            try data.write(to: file)
        } catch {
            print(error)
        }
    }
    
    func writeSave(level: Int, lives: Int, score: Int) {
        let config = SaveStruct(currentLevel: level, currentScore: score, currentLives: lives)
        writeSave(saveData: config)
    }
    
    static func getNumberOfSaves() -> Int{
        if let contents =  try? FileManager.default.contentsOfDirectory(atPath: SaveData.configFolder.path) {
            return contents.count
        } else {
            return 0
        }
    }
}
