//
//  ConfigData.swift
//  Gorilla
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation

struct ConfigStruct : Codable{
    var soundOn : Bool
    var musicOn : Bool
}

class ConfigData {
    private static var configFolder: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Config/")
    
    static func read() -> ConfigStruct {
        if (configExistsInDocs()) {
            return readConfigFromDocs() ?? ConfigStruct(soundOn: true, musicOn: true)
        } else {
            let config = readConfigFromBundle() ?? ConfigStruct(soundOn: true, musicOn: true)
            writeConfig(sound: config.soundOn, music: config.musicOn)
            return config
        }
    }
    
    private static func readConfigFromBundle() -> ConfigStruct? {
        if let file = Bundle.main.path(forResource: "config", ofType: "plist"), let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(ConfigStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
    
    private static func configExistsInDocs() -> Bool {
        return FileManager.default.fileExists(atPath: configFolder.appendingPathComponent("config.plist").path)
    }
    
    private static func readConfigFromDocs() -> ConfigStruct? {
        let file = configFolder.appendingPathComponent("config.plist").path
        if let plist = FileManager.default.contents(atPath: file), let config = try? PropertyListDecoder().decode(ConfigStruct.self, from: plist) {
            return config
        } else {
            return nil
        }
    }
    
    static func writeConfig(sound: Bool, music: Bool) {
        let config = ConfigStruct(soundOn: sound, musicOn: music)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let file = configFolder.appendingPathComponent("config.plist") // ERROR HERE

        print(file.absoluteString)
        
        if !FileManager.default.fileExists(atPath: configFolder.path) {
            if ((try? FileManager.default.createDirectory(at: configFolder, withIntermediateDirectories: true, attributes: nil)) != nil) {
                
            } else {
                print ("Couldnt create folder")
            }
        } else {
            print("Folder already created.")
        }
        
        do {
            let data = try encoder.encode(config)
            try data.write(to: file)
        } catch {
            print(error)
        }
    }
}
