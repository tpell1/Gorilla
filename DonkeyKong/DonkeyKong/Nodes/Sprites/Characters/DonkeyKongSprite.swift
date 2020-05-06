//
//  DonkeyKongSprite.swift
//  DonkeyKong
//
//  Created by Travis Pell on 27/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

class DonkeyKongSprite: SKSpriteNode {
    private var height = 100
    private var width = 80
    private var health = 10
    private var hitTimer : Timer?
    private var isHit = false
    
    // Default constructor, creates a koopa character with one life
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "donkeyKong.png") // Use the mario texture
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        self.name = "donkeyKong"
        self.zPosition = 10
        ///////// My physics //////////
        physicsObj = PhysicsObject(withNode: self, mass: 3)
        physicsObj?.restitution = 0.4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fightMario(marioPos: CGPoint) {
        let marioX = marioPos.x
        let marioY = marioPos.y
        
        if (abs(marioX - self.position.x) < 100 && abs(marioY - self.position.y) < 30) {
            attack(position: marioPos)
        } else {
            walk(to: marioPos)
        }
    }
    
    private func attack(position: CGPoint) {
        self.physicsObj?.velocity.dx = 0
        self.physicsObj?.applyForce(dx: 0, dy: 165000)
        walk(to: position)
    }
    
    private func walk(to: CGPoint) {
        self.physicsObj?.velocity.dx = 0
        if (to.x > position.x) {
            self.physicsObj?.applyImpulse(dx: 850, dy: 0)
        } else {
            self.physicsObj?.applyImpulse(dx: -850, dy: 0)
        }
    }

    public func hit() {
        if (!isHit) {
            health -= 1
            if (health <= 0) {
                die()
            }
            isHit=true
            self.hitTimer = Timer(timeInterval: TimeInterval(1.5), repeats: true, block: hitTime)
            RunLoop.current.add(hitTimer!, forMode: .commonModes)
        }
    }
    
    @objc func hitTime(timer: Timer) {
        isHit=false
        timer.invalidate()
    }
    
    private func die() {
        removeFromParent()
    }
    
    public func getHealth() -> Int{
        return health
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
    }
}
