//
//  KoopaSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit

class KoopaSprite: SKSpriteNode {
    private var height = 60
    private var width = 50
    private var sizeOfPlatform: CGFloat = 3
    private var timer: Timer?
    private var timerBool = false
    
    // Default constructor, creates a koopa character with one life
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "koopa.png") // Use the mario texture
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(texture: (self.texture)!, size: CGSize(width: CGFloat(55.0), height: CGFloat(60.0)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.name = "Koopa"
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        self.timer = Timer(timeInterval: TimeInterval(sizeOfPlatform*0.5), repeats: true, block: timerWalk)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    convenience init(x: CGFloat, y: CGFloat, sizeOfPlatform: CGFloat) {
        self.init(x: x, y: y)
        self.sizeOfPlatform = sizeOfPlatform
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk() {
        let move = SKAction.move(to: CGPoint(x: self.position.x + sizeOfPlatform*BlockSprite.BLOCK_SIZE, y: self.position.y), duration: TimeInterval(0.5*sizeOfPlatform))
        self.run(move)
    }
    
    func walkBack() {
        let move = SKAction.move(to: CGPoint(x: self.position.x - sizeOfPlatform*BlockSprite.BLOCK_SIZE, y: self.position.y), duration: TimeInterval(0.5*sizeOfPlatform))
        self.run(move)
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        timer?.invalidate() // Memory management
    }
    
    private func timerWalk(timer: Timer) {
        if(timerBool) {
            walkBack()
        } else {
            walk()
        }
    }
}
