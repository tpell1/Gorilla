//
//  OptionsMenu.swift
//  Gorilla
//
//  Created by Travis Pell on 30/04/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsMenu : SKNode {
    private var sound : Bool = true
    private var music : Bool = true
    
    var status : MenuStatus = MenuStatus.OPTIONS
    private var soundFxButton : MenuButton = MenuButton(textForButton: "Sound: On")
    private var musicButton : MenuButton = MenuButton(textForButton: "Music: On")
    
    override init() {
        super.init()
        soundFxButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(soundFxButton)
        
        musicButton.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        self.addChild(musicButton)
        
        let data = ConfigData.read()
        sound = data.soundOn
        music = data.musicOn
        
        updateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if (soundFxButton.contains(pos)) {
            sound = !sound
            updateText()
        } else if (musicButton.contains(pos)) {
            music = !music
            updateText()
        }
    }
    
    private func updateText() {
        if (sound) {
            soundFxButton.setText(text: "Sound: On")
        } else {
            soundFxButton.setText(text: "Sound: Off")
        }
        if (music) {
            musicButton.setText(text: "Music: On")
        } else {
            musicButton.setText(text: "Music: Off")
        }
    }
    
    func writeConfig() {
        ConfigData.writeConfig(sound: sound, music: music)
    }
}
